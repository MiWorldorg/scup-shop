<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Replace the five portfolio demo prices with whole-dollar USD amounts.
     * These are sample catalog values, not currency conversions or valuations.
     */
    public function up(): void
    {
        $prices = [
            'SC-THINK-001' => 1250,
            'SC-SEAT-002' => 890,
            'SC-GREEK-003' => 1650,
            'CO-BUTTERFLY-004' => 185,
            'CO-INFINITY-005' => 240,
        ];

        foreach ($prices as $sku => $price) {
            DB::table('products')->where('sku', $sku)->update([
                'price' => $price,
                'updated_at' => now(),
            ]);
        }
    }

    public function down(): void
    {
        $prices = [
            'SC-THINK-001' => 24500000,
            'SC-SEAT-002' => 18900000,
            'SC-GREEK-003' => 32000000,
            'CO-BUTTERFLY-004' => 6800000,
            'CO-INFINITY-005' => 9250000,
        ];

        foreach ($prices as $sku => $price) {
            DB::table('products')->where('sku', $sku)->update([
                'price' => $price,
                'updated_at' => now(),
            ]);
        }
    }
};
