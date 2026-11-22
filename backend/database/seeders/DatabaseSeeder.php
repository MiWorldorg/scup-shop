<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $customerPassword = config('app.demo_customer_password');
        if (
            app()->environment('local')
            && is_string($customerPassword)
            && trim($customerPassword) !== ''
        ) {
            User::updateOrCreate(
                ['email' => 'test@example.test'],
                [
                    'username' => 'test-customer',
                    'first_name' => 'Demo',
                    'last_name' => 'Customer',
                    'phone' => '000-000-0000',
                    'address' => '1 Demo Street',
                    'password' => $customerPassword,
                ],
            );
        }

        $adminPassword = config('app.demo_admin_password');
        if (
            app()->environment('local')
            && is_string($adminPassword)
            && trim($adminPassword) !== ''
        ) {
            $admin = User::updateOrCreate(
                ['email' => 'admin@example.test'],
                [
                    'username' => 'demo-admin',
                    'first_name' => 'Demo',
                    'last_name' => 'Administrator',
                    'phone' => '000-000-0001',
                    'address' => '1 Demo Street',
                    'password' => $adminPassword,
                ],
            );
            $admin->forceFill(['role' => 'admin'])->save();
        }

        $this->call(ProductSeeder::class);
    }
}
