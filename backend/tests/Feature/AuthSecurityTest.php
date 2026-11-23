<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthSecurityTest extends TestCase
{
    use RefreshDatabase;

    public function test_login_uses_the_same_generic_error_for_unknown_and_wrong_credentials(): void
    {
        $user = User::factory()->create([
            'email' => 'known@example.test',
            'password' => 'Valid!Password2026',
        ]);

        $wrongPassword = $this->postJson('/api/v1/login', [
            'email' => $user->email,
            'password' => 'Wrong!Password2026',
        ]);

        $unknownEmail = $this->postJson('/api/v1/login', [
            'email' => 'unknown@example.test',
            'password' => 'Wrong!Password2026',
        ]);

        $wrongPassword->assertUnauthorized()
            ->assertJsonPath('message', 'The email or password is incorrect.');
        $unknownEmail->assertUnauthorized()
            ->assertJsonPath('message', 'The email or password is incorrect.');
    }

    public function test_login_endpoint_is_rate_limited(): void
    {
        for ($attempt = 0; $attempt < 5; $attempt++) {
            $this->postJson('/api/v1/login', [
                'email' => 'missing@example.test',
                'password' => 'Wrong!Password2026',
            ])->assertUnauthorized();
        }

        $this->postJson('/api/v1/login', [
            'email' => 'missing@example.test',
            'password' => 'Wrong!Password2026',
        ])->assertTooManyRequests();
    }

    public function test_production_api_rejects_plain_http_requests(): void
    {
        $this->app['env'] = 'production';

        $this->getJson('/api/v1/post')->assertStatus(426);
    }

    public function test_production_api_accepts_https_requests_and_sets_hsts(): void
    {
        $this->app['env'] = 'production';

        $this->withServerVariables(['HTTPS' => 'on'])
            ->getJson('/api/v1/post')
            ->assertOk()
            ->assertHeader(
                'Strict-Transport-Security',
                'max-age=31536000; includeSubDomains',
            );
    }

    public function test_api_responses_include_baseline_security_headers(): void
    {
        $this->getJson('/api/v1/post')
            ->assertOk()
            ->assertHeader('X-Content-Type-Options', 'nosniff')
            ->assertHeader('X-Frame-Options', 'DENY')
            ->assertHeader('Referrer-Policy', 'no-referrer')
            ->assertHeader(
                'Permissions-Policy',
                'camera=(), microphone=(), geolocation=()',
            );
    }

    public function test_registration_rejects_weak_passwords(): void
    {
        $this->postJson('/api/v1/register', [
            'username' => 'weak-password-user',
            'first_name' => 'Weak',
            'last_name' => 'Password',
            'phone' => '123456789',
            'address' => '1 Example Street',
            'email' => 'weak@example.test',
            'password' => 'password',
            'password_confirmation' => 'password',
        ])->assertUnprocessable();
    }
}
