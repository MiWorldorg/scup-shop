<?php

namespace App\Repository\api;

use App\Http\Requests\DeleteProductRequest;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use App\Models\ProductInventory;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class ProductRepositoryApi implements ProductRepositoryInterfaceApi
{
    public function select(): JsonResponse
    {
        $products = Product::query()
            ->with(['category:id,name', 'inventory:id,quantity'])
            ->orderBy('id')
            ->paginate(20);

        return response()->json([
            'code' => 1,
            'message' => 'Products.',
            'data' => ProductResource::collection($products)->response()->getData(true),
        ]);
    }

    public function insert(StoreProductRequest $request): JsonResponse
    {
        $data = $request->validated();
        $product = DB::transaction(function () use ($data) {
            $inventoryId = $data['inventory_id'] ?? null;
            $quantity = $data['quantity'] ?? null;
            unset($data['inventory_id'], $data['quantity']);

            if ($inventoryId === null) {
                $inventoryId = ProductInventory::create([
                    'quantity' => $quantity ?? 0,
                ])->id;
            } elseif ($quantity !== null) {
                ProductInventory::whereKey($inventoryId)->update(['quantity' => $quantity]);
            }

            $data['inventory_id'] = $inventoryId;
            $data['image'] = $data['image'] ?? 'assets/images/products/marble-think.png';

            return Product::create($data)->load(['category:id,name', 'inventory:id,quantity']);
        });

        return response()->json([
            'code' => 1,
            'message' => 'Product created successfully.',
            'data' => new ProductResource($product),
        ], 201);
    }

    public function destroy(DeleteProductRequest $request): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer'],
        ]);

        $deleted = DB::transaction(function () use ($validated) {
            $product = Product::lockForUpdate()->findOrFail($validated['id']);

            $hasLegacyReferences = DB::table('cart_items')
                ->where('product_id', $product->id)
                ->exists()
                || DB::table('order_items')
                    ->where('product_id', $product->id)
                    ->exists();

            if ($hasLegacyReferences) {
                return false;
            }

            $inventoryId = $product->inventory_id;
            $product->delete();

            if ($inventoryId !== null) {
                ProductInventory::whereKey($inventoryId)->delete();
            }

            return true;
        });

        if (!$deleted) {
            return response()->json([
                'code' => 2,
                'message' => 'This product is referenced by legacy cart or order records and cannot be deleted.',
                'data' => null,
            ], 409);
        }

        return response()->json([
            'code' => 1,
            'message' => 'Product deleted successfully.',
            'data' => true,
        ]);
    }

    public function update(UpdateProductRequest $request): JsonResponse
    {
        $data = $request->validated();
        $id = $data['id'];
        unset($data['id']);

        $product = DB::transaction(function () use ($id, $data) {
            $product = Product::lockForUpdate()->findOrFail($id);
            $previousInventoryId = $product->inventory_id;
            $quantity = $data['quantity'] ?? null;
            $inventoryId = $data['inventory_id'] ?? $previousInventoryId;
            unset($data['quantity']);

            $product->update($data);

            if ($quantity !== null) {
                ProductInventory::whereKey($inventoryId)->update(['quantity' => $quantity]);
            }

            if ($inventoryId !== $previousInventoryId) {
                ProductInventory::whereKey($previousInventoryId)->delete();
            }

            return $product->refresh()->load(['category:id,name', 'inventory:id,quantity']);
        });

        return response()->json([
            'code' => 1,
            'message' => 'Product updated successfully.',
            'data' => new ProductResource($product),
        ]);
    }
}
