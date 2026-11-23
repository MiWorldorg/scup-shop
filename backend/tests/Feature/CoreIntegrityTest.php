<?php

namespace Tests\Feature;

use App\Http\Requests\RegisterRequest;
use App\Models\Post;
use App\Models\Product;
use App\Models\ProductCategory;
use App\Models\ProductInventory;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Laravel\Passport\Passport;
use Tests\TestCase;

class CoreIntegrityTest extends TestCase
{
    use RefreshDatabase;

    public function test_public_registration_cannot_assign_an_administrator_role(): void
    {
        $payload = [
            'username' => 'new-customer',
            'first_name' => 'New',
            'last_name' => 'Customer',
            'phone' => '123456789',
            'address' => '1 Example Street',
            'email' => 'new-customer@example.test',
            'password' => 'Str0ng!Password2026',
            'password_confirmation' => 'Str0ng!Password2026',
            'role' => 'admin',
        ];

        $request = new RegisterRequest();
        $validated = Validator::make($payload, $request->rules())->validate();
        $user = User::create($validated);

        $this->assertSame('user', $user->fresh()->role);
        $this->assertArrayNotHasKey('role', $validated);
    }

    public function test_admin_api_rejects_missing_and_non_admin_tokens(): void
    {
        $this->getJson('/api/v1/admin/product')->assertUnauthorized();
        $this->withHeader('Authorization', 'Bearer invalid-token')
            ->getJson('/api/v1/admin/product')
            ->assertUnauthorized();

        $customer = User::factory()->create(['role' => 'user']);
        Passport::actingAs($customer, [], 'api');

        $this->getJson('/api/v1/admin/product')->assertForbidden();
    }

    public function test_current_session_endpoint_exposes_only_safe_user_fields(): void
    {
        $customer = User::factory()->create(['role' => 'user']);
        Passport::actingAs($customer, [], 'api');

        $this->getJson('/api/v1/me')
            ->assertOk()
            ->assertJsonPath('data.id', $customer->id)
            ->assertJsonPath('data.role', 'user')
            ->assertJsonMissingPath('data.password')
            ->assertJsonMissingPath('data.phone')
            ->assertJsonMissingPath('data.address');
    }

    public function test_public_blog_excludes_drafts_and_admin_can_manage_them(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $categoryId = DB::table('post_categories')->insertGetId([
            'title' => 'Sculpture & Art',
            'image' => '',
            'desc' => 'Editorial category',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $draft = Post::create([
            'author_id' => $admin->id,
            'category_id' => $categoryId,
            'slug' => 'private-draft',
            'title' => 'Private draft',
            'published' => null,
            'summary' => 'A draft summary.',
            'content' => 'Draft content.',
            'post_picture' => null,
        ]);

        Post::create([
            'author_id' => $admin->id,
            'category_id' => $categoryId,
            'slug' => 'published-story',
            'title' => 'Published story',
            'published' => now(),
            'summary' => 'A public summary.',
            'content' => 'Published content.',
            'post_picture' => null,
        ]);

        $this->getJson('/api/v1/post')
            ->assertOk()
            ->assertJsonCount(1, 'data.data')
            ->assertJsonPath('data.data.0.slug', 'published-story');

        Passport::actingAs($admin, [], 'api');
        $this->getJson('/api/v1/admin/post')
            ->assertOk()
            ->assertJsonCount(2, 'data.data');

        $response = $this->postJson('/api/v1/admin/post/create', [
            'author_id' => 999999,
            'category_id' => $categoryId,
            'slug' => 'created-by-current-admin',
            'title' => 'Created post',
            'published' => null,
            'summary' => 'A valid summary.',
            'content' => 'A valid article body.',
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.author_id', $admin->id)
            ->assertJsonPath('data.published', null);

        $this->postJson('/api/v1/admin/post/create', [
            'category_id' => $categoryId,
            'slug' => 'published-story',
            'title' => 'Duplicate slug',
            'summary' => 'A duplicate.',
            'content' => 'Duplicate content.',
        ])->assertUnprocessable();

        $this->postJson('/api/v1/admin/post/create', [
            'category_id' => 999999,
            'slug' => 'invalid-category',
            'title' => 'Invalid category',
            'summary' => 'A summary.',
            'content' => 'Article content.',
        ])->assertUnprocessable();

        $this->postJson('/api/v1/admin/post/create', [
            'category_id' => $categoryId,
            'slug' => 'remote-image-post',
            'title' => 'Remote image post',
            'summary' => 'A summary.',
            'content' => 'Article content.',
            'post_picture' => 'https://example.test/image.png',
        ])->assertUnprocessable();

        $this->putJson('/api/v1/admin/post/update', [
            'id' => $draft->id + 999,
            'title' => 'Missing post',
        ])->assertNotFound();

        $this->putJson('/api/v1/admin/post/update', [
            'id' => $draft->id,
            'title' => 'Now published',
            'published' => now()->toISOString(),
        ])->assertOk();

        $this->assertDatabaseHas('posts', [
            'id' => $draft->id,
            'title' => 'Now published',
        ]);

        $this->deleteJson('/api/v1/admin/post/delete?id='.$draft->id)
            ->assertOk();

        $this->assertDatabaseMissing('posts', ['id' => $draft->id]);
    }

    public function test_product_inventory_is_owned_and_zero_stock_is_preserved(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $category = ProductCategory::create([
            'name' => 'Sculptures',
            'desc' => 'Sculpture products.',
        ]);
        $inventory = ProductInventory::create(['quantity' => 7]);
        $product = Product::create([
            'name' => 'Test sculpture',
            'desc' => 'A test item.',
            'sku' => 'TEST-SCULPTURE-001',
            'image' => '',
            'category_id' => $category->id,
            'inventory_id' => $inventory->id,
            'price' => 100,
        ]);

        Passport::actingAs($admin, [], 'api');

        $this->postJson('/api/v1/admin/product/create', [
            'name' => 'Second sculpture',
            'desc' => 'Another test item.',
            'sku' => 'TEST-SCULPTURE-002',
            'category_id' => $category->id,
            'inventory_id' => $inventory->id,
            'quantity' => 4,
            'price' => 150,
        ])->assertUnprocessable();

        $this->postJson('/api/v1/admin/product/create', [
            'name' => 'Remote image product',
            'desc' => 'Invalid external image.',
            'sku' => 'REMOTE-IMAGE-001',
            'category_id' => $category->id,
            'image' => 'https://example.test/image.png',
            'price' => 150,
        ])->assertUnprocessable();

        $this->putJson('/api/v1/admin/product/update', [
            'id' => $product->id,
            'quantity' => 0,
        ])->assertOk();

        $this->assertDatabaseHas('product_inventories', [
            'id' => $inventory->id,
            'quantity' => 0,
        ]);

        $this->deleteJson('/api/v1/admin/product/delete?id='.$product->id)
            ->assertOk();

        $this->assertDatabaseMissing('products', ['id' => $product->id]);
        $this->assertDatabaseMissing('product_inventories', ['id' => $inventory->id]);
    }

    public function test_product_with_legacy_cart_references_cannot_be_deleted(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $category = ProductCategory::create([
            'name' => 'Sculptures',
            'desc' => 'Sculpture products.',
        ]);
        $inventory = ProductInventory::create(['quantity' => 2]);
        $product = Product::create([
            'name' => 'Referenced sculpture',
            'desc' => 'A retained cart item.',
            'sku' => 'TEST-REFERENCED-001',
            'image' => '',
            'category_id' => $category->id,
            'inventory_id' => $inventory->id,
            'price' => 100,
        ]);
        $sessionId = DB::table('shopping_sessions')->insertGetId([
            'user_id' => $admin->id,
            'total' => '100',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('cart_items')->insert([
            'session_id' => $sessionId,
            'product_id' => $product->id,
            'quantity' => 1,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        Passport::actingAs($admin, [], 'api');

        $this->deleteJson('/api/v1/admin/product/delete?id='.$product->id)
            ->assertStatus(409);

        $this->assertDatabaseHas('products', ['id' => $product->id]);
        $this->assertDatabaseHas('product_inventories', ['id' => $inventory->id]);
    }

    public function test_admin_can_change_another_users_role(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $customer = User::factory()->create(['role' => 'user']);
        Passport::actingAs($admin, [], 'api');

        $this->putJson('/api/v1/admin/user/role', [
            'id' => $customer->id,
            'role' => 'admin',
        ])->assertOk()->assertJsonPath('data.role', 'admin');

        $this->assertDatabaseHas('users', [
            'id' => $customer->id,
            'role' => 'admin',
        ]);
    }

    public function test_product_creation_creates_a_dedicated_zero_stock_inventory(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $category = ProductCategory::create([
            'name' => 'Collectibles',
            'desc' => 'Small art objects.',
        ]);
        Passport::actingAs($admin, [], 'api');

        $response = $this->postJson('/api/v1/admin/product/create', [
            'name' => 'Zero stock item',
            'desc' => 'A product with no available stock.',
            'sku' => 'ZERO-STOCK-001',
            'category_id' => $category->id,
            'quantity' => 0,
            'price' => 250,
        ]);

        $response->assertCreated();
        $inventoryId = $response->json('data.inventory_id');
        $this->assertNotNull($inventoryId);
        $this->assertDatabaseHas('product_inventories', [
            'id' => $inventoryId,
            'quantity' => 0,
        ]);
    }

    public function test_stale_admin_actor_cannot_change_roles_after_demotion(): void
    {
        $actor = User::factory()->create(['role' => 'admin']);
        $target = User::factory()->create(['role' => 'user']);

        DB::table('users')->where('id', $actor->id)->update(['role' => 'user']);

        $request = Request::create('/api/v1/admin/user/role', 'PUT', [
            'id' => $target->id,
            'role' => 'admin',
        ]);
        $request->setUserResolver(fn () => $actor);

        $response = app(\App\Http\Controllers\Admin\UserController::class)
            ->updateRole($request);

        $this->assertSame(403, $response->getStatusCode());
        $this->assertDatabaseHas('users', [
            'id' => $target->id,
            'role' => 'user',
        ]);
    }

    public function test_last_administrator_cannot_demote_themselves(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        Passport::actingAs($admin, [], 'api');

        $this->putJson('/api/v1/admin/user/role', [
            'id' => $admin->id,
            'role' => 'user',
        ])->assertUnprocessable();

        $this->assertDatabaseHas('users', [
            'id' => $admin->id,
            'role' => 'admin',
        ]);
    }
}
