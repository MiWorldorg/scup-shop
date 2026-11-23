<?php

namespace Tests\Feature;

use App\Models\Post;
use App\Models\Product;
use App\Models\ProductCategory;
use App\Models\ProductInventory;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Laravel\Passport\Passport;
use Tests\TestCase;

class ProductCatalogTest extends TestCase
{
    use RefreshDatabase;

    public function test_public_catalog_searches_by_name_sku_and_description_and_filters_category(): void
    {
        $sculptures = ProductCategory::create([
            'name' => 'Sculptures',
            'desc' => 'Sculptural works.',
        ]);
        $collectibles = ProductCategory::create([
            'name' => 'Collectibles',
            'desc' => 'Small objects.',
        ]);

        $marble = $this->createProduct(
            $sculptures,
            'Marble Thinker',
            'SC-THINK-001',
            'A contemplative figure.',
            1250,
            8,
        );
        $this->createProduct(
            $collectibles,
            'Butterfly Object',
            'CO-BUTTERFLY-004',
            'A delicate winged form.',
            185,
            14,
        );

        $this->getJson('/api/v1/product?search=Thinker&category_id='.$sculptures->id)
            ->assertOk()
            ->assertJsonPath('data.data.0.id', $marble->id)
            ->assertJsonPath('data.data.0.price', 1250)
            ->assertJsonPath('data.data.0.inventory.quantity', 8)
            ->assertJsonPath('data.meta.total', 1);

        $this->getJson('/api/v1/product?search=CO-BUTTERFLY')
            ->assertOk()
            ->assertJsonPath('data.meta.total', 1);

        $this->getJson('/api/v1/product?search=winged')
            ->assertOk()
            ->assertJsonPath('data.meta.total', 1);
    }

    public function test_public_product_categories_are_available_without_authentication(): void
    {
        ProductCategory::create([
            'name' => 'Sculptures',
            'desc' => 'Sculptural works.',
        ]);

        $this->getJson('/api/v1/product/categories')
            ->assertOk()
            ->assertJsonPath('data.0.name', 'Sculptures');
    }

    public function test_admin_product_search_uses_the_same_category_and_search_filters(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $sculptures = ProductCategory::create([
            'name' => 'Sculptures',
            'desc' => 'Sculptural works.',
        ]);
        $this->createProduct(
            $sculptures,
            'Greek Guardian',
            'SC-GREEK-003',
            'A classical figure.',
            1650,
            3,
        );

        Passport::actingAs($admin, [], 'api');

        $this->getJson('/api/v1/admin/product?category_id='.$sculptures->id.'&search=Greek')
            ->assertOk()
            ->assertJsonPath('data.meta.total', 1)
            ->assertJsonPath('data.data.0.name', 'Greek Guardian');
    }

    public function test_admin_post_search_matches_title_slug_and_summary(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $categoryId = DB::table('post_categories')->insertGetId([
            'title' => 'Sculpture & Art',
            'image' => '',
            'desc' => 'Editorial category.',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        Post::create([
            'author_id' => $admin->id,
            'category_id' => $categoryId,
            'slug' => 'stone-and-form',
            'title' => 'Stone and Form',
            'published' => now(),
            'summary' => 'Notes on marble craft.',
            'content' => 'Editorial body.',
            'post_picture' => null,
        ]);
        Post::create([
            'author_id' => $admin->id,
            'category_id' => $categoryId,
            'slug' => 'studio-journal',
            'title' => 'Studio Journal',
            'published' => null,
            'summary' => 'A private work in progress.',
            'content' => 'Draft body.',
            'post_picture' => null,
        ]);

        Passport::actingAs($admin, [], 'api');

        $this->getJson('/api/v1/admin/post?search=marble')
            ->assertOk()
            ->assertJsonPath('data.meta.total', 1)
            ->assertJsonPath('data.data.0.slug', 'stone-and-form');

        $this->getJson('/api/v1/admin/post?search=studio-journal')
            ->assertOk()
            ->assertJsonPath('data.meta.total', 1)
            ->assertJsonPath('data.data.0.slug', 'studio-journal');
    }

    private function createProduct(
        ProductCategory $category,
        string $name,
        string $sku,
        string $description,
        int $price,
        int $quantity,
    ): Product {
        $inventory = ProductInventory::create(['quantity' => $quantity]);

        return Product::create([
            'name' => $name,
            'desc' => $description,
            'sku' => $sku,
            'image' => 'assets/images/products/marble-think.png',
            'category_id' => $category->id,
            'inventory_id' => $inventory->id,
            'price' => $price,
        ]);
    }
}
