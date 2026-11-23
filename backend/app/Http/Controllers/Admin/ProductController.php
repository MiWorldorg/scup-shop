<?php

namespace App\Http\Controllers\Admin;

use App\Actions\Admin\ManageProducts;
use App\Http\Controllers\Controller;
use App\Http\Requests\DeleteProductRequest;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Http\Resources\ProductResource;
use App\Models\ProductCategory;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;

class ProductController extends Controller
{
    public function select(ProductRepositoryInterfaceApi $products): JsonResponse
    {
        $data = ProductResource::collection($products->select())
            ->response()
            ->getData(true);

        return response()->json([
            'code' => 1,
            'message' => 'Products.',
            'data' => $data,
        ]);
    }

    public function categories(): JsonResponse
    {
        return response()->json([
            'code' => 1,
            'message' => 'Product categories.',
            'data' => ProductCategory::query()
                ->select('id', 'name')
                ->orderBy('name')
                ->get(),
        ]);
    }

    public function insert(
        StoreProductRequest $request,
        ManageProducts $manageProducts
    ): JsonResponse {
        $product = $manageProducts->create($request->validated());

        return response()->json([
            'code' => 1,
            'message' => 'Product created successfully.',
            'data' => new ProductResource($product),
        ], 201);
    }

    public function destroy(
        DeleteProductRequest $request,
        ManageProducts $manageProducts
    ): JsonResponse {
        $deleted = $manageProducts->delete((int) $request->validated('id'));

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

    public function update(
        UpdateProductRequest $request,
        ManageProducts $manageProducts
    ): JsonResponse {
        $validated = $request->validated();
        $product = $manageProducts->update((int) $validated['id'], $validated);

        return response()->json([
            'code' => 1,
            'message' => 'Product updated successfully.',
            'data' => new ProductResource($product),
        ]);
    }
}
