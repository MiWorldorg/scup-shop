<?php

namespace Database\Seeders;

use App\Models\ProductCategory;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function () {
            $sculptures = ProductCategory::firstOrCreate(
                ['name' => 'Sculptures'],
                ['desc' => 'Sculptures inspired by classic forms and artists.'],
            );
            $collectibles = ProductCategory::firstOrCreate(
                ['name' => 'Collectibles'],
                ['desc' => 'Small decorative objects for home and studio.'],
            );

            $products = [
                [
                    'name' => 'Marble Thinker',
                    'desc' => 'A contemplative figure carved in a warm marble finish.',
                    'sku' => 'SC-THINK-001',
                    'image' => 'assets/images/products/marble-think.png',
                    'category_id' => $sculptures->id,
                    'price' => 1250,
                    'quantity' => 8,
                ],
                [
                    'name' => 'Seated Marble Figure',
                    'desc' => 'A compact seated figure with a smooth stone finish.',
                    'sku' => 'SC-SEAT-002',
                    'image' => 'assets/images/products/marble-sit.png',
                    'category_id' => $sculptures->id,
                    'price' => 890,
                    'quantity' => 5,
                ],
                [
                    'name' => 'Greek Guardian',
                    'desc' => 'A classical figure inspired by ancient Greek sculpture.',
                    'sku' => 'SC-GREEK-003',
                    'image' => 'assets/images/products/ancient-greek -statues.png',
                    'category_id' => $sculptures->id,
                    'price' => 1650,
                    'quantity' => 3,
                ],
                [
                    'name' => 'Butterfly Object',
                    'desc' => 'A delicate butterfly form designed for a shelf or desk.',
                    'sku' => 'CO-BUTTERFLY-004',
                    'image' => 'assets/images/products/butterfly-object.png',
                    'category_id' => $collectibles->id,
                    'price' => 185,
                    'quantity' => 14,
                ],
                [
                    'name' => 'Infinity Stone',
                    'desc' => 'A flowing abstract form with a polished stone look.',
                    'sku' => 'CO-INFINITY-005',
                    'image' => 'assets/images/products/infinity-stone.png',
                    'category_id' => $collectibles->id,
                    'price' => 240,
                    'quantity' => 10,
                ],
            ];

            foreach ($products as $attributes) {
                $quantity = $attributes['quantity'];
                unset($attributes['quantity']);
                $attributes['updated_at'] = now();
                $existing = DB::table('products')->where('sku', $attributes['sku'])->first();

                if ($existing) {
                    DB::table('products')
                        ->where('id', $existing->id)
                        ->update($attributes);
                    DB::table('product_inventories')
                        ->where('id', $existing->inventory_id)
                        ->update(['quantity' => $quantity, 'updated_at' => now()]);

                    continue;
                }

                $inventoryId = DB::table('product_inventories')->insertGetId([
                    'quantity' => $quantity,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                DB::table('products')->insert($attributes + [
                    'inventory_id' => $inventoryId,
                    'created_at' => now(),
                ]);
            }
        });
    }
}
