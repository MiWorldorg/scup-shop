<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PostCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            'Sculpture & Art' => 'Stories about sculpture, materials, and artistic practice.',
            'Artists & Ideas' => 'Profiles, ideas, and influences from the art world.',
            'Studio Journal' => 'Notes from the studio, exhibitions, and creative process.',
        ];

        foreach ($categories as $title => $description) {
            $existing = DB::table('post_categories')->where('title', $title)->first();

            if ($existing) {
                DB::table('post_categories')->where('id', $existing->id)->update([
                    'desc' => $description,
                    'updated_at' => now(),
                ]);
                continue;
            }

            DB::table('post_categories')->insert([
                'title' => $title,
                'image' => '',
                'desc' => $description,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}
