<?php

namespace App\Actions\Admin;

use App\Models\Product;
use App\Models\ProductInventory;
use Illuminate\Support\Facades\DB;

class ManageProducts
{
    public function create(array $data): Product
    {
        return DB::transaction(function () use ($data) {
            $inventoryId = $data['inventory_id'] ?? null;
            $quantity = $data['quantity'] ?? null;
            unset($data['inventory_id'], $data['quantity']);

            if ($inventoryId === null) {
                $inventoryId = ProductInventory::create([
                    'quantity' => $quantity ?? 0,
                ])->id;
            } elseif ($quantity !== null) {
                ProductInventory::whereKey($inventoryId)->update([
                    'quantity' => $quantity,
                ]);
            }

            $data['inventory_id'] = $inventoryId;
            $data['image'] = $data['image'] ?? 'assets/images/products/marble-think.png';

            return Product::create($data)
                ->load(['category:id,name', 'inventory:id,quantity']);
        });
    }

    public function update(int $id, array $data): Product
    {
        unset($data['id']);

        return DB::transaction(function () use ($id, $data) {
            $product = Product::query()->lockForUpdate()->findOrFail($id);
            $previousInventoryId = $product->inventory_id;
            $quantity = $data['quantity'] ?? null;
            $inventoryId = $data['inventory_id'] ?? $previousInventoryId;
            unset($data['quantity']);

            $product->update($data);

            if ($quantity !== null) {
                ProductInventory::whereKey($inventoryId)->update([
                    'quantity' => $quantity,
                ]);
            }

            if ($inventoryId !== $previousInventoryId && $previousInventoryId !== null) {
                ProductInventory::whereKey($previousInventoryId)->delete();
            }

            return $product->refresh()
                ->load(['category:id,name', 'inventory:id,quantity']);
        });
    }

    public function delete(int $id): bool
    {
        return DB::transaction(function () use ($id) {
            $product = Product::query()->lockForUpdate()->findOrFail($id);

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
    }
}
