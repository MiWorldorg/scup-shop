<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Preserve stock values while splitting any inventory rows shared by products.
        $seenInventoryIds = [];
        foreach (DB::table('products')->orderBy('id')->get(['id', 'inventory_id']) as $product) {
            if (!in_array($product->inventory_id, $seenInventoryIds, true)) {
                $seenInventoryIds[] = $product->inventory_id;
                continue;
            }

            $inventory = DB::table('product_inventories')
                ->where('id', $product->inventory_id)
                ->first();

            if (!$inventory) {
                throw new RuntimeException(
                    "Cannot enforce one-to-one inventory: product {$product->id} has no inventory row."
                );
            }

            $newInventoryId = DB::table('product_inventories')->insertGetId([
                'quantity' => $inventory->quantity,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            DB::table('products')->where('id', $product->id)->update([
                'inventory_id' => $newInventoryId,
            ]);
        }

        Schema::table('products', function (Blueprint $table) {
            $table->unique('inventory_id');
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropUnique(['inventory_id']);
        });
    }
};
