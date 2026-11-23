<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use RuntimeException;
use Tests\TestCase;

class ContactMessageTest extends TestCase
{
    use RefreshDatabase;

    private function validPayload(): array
    {
        return [
            'first_name' => 'Alex',
            'last_name' => 'Morgan',
            'email' => 'alex@example.test',
            'message' => 'I would like to learn more about a sculpture.',
            'website' => '',
        ];
    }

    public function test_contact_message_is_accepted_when_mail_transport_accepts_it(): void
    {
        config(['contact.to_address' => 'studio@example.test']);
        Mail::shouldReceive('raw')->once();

        $this->postJson('/api/v1/contact', $this->validPayload())
            ->assertAccepted()
            ->assertJsonPath('code', 1)
            ->assertJsonPath('data', true);
    }

    public function test_contact_message_requires_valid_sender_fields_and_empty_honeypot(): void
    {
        config(['contact.to_address' => 'studio@example.test']);

        $this->postJson('/api/v1/contact', [
            ...$this->validPayload(),
            'email' => 'not-an-email',
            'message' => 'short',
            'website' => 'bot-filled-this',
        ])->assertUnprocessable()
            ->assertJsonValidationErrors(['email', 'message', 'website']);
    }

    public function test_contact_endpoint_returns_service_unavailable_when_destination_is_missing(): void
    {
        config(['contact.to_address' => null]);

        $this->postJson('/api/v1/contact', $this->validPayload())
            ->assertServiceUnavailable()
            ->assertJsonPath('code', 2);
    }

    public function test_contact_endpoint_returns_service_unavailable_when_mail_transport_fails(): void
    {
        config(['contact.to_address' => 'studio@example.test']);
        Mail::shouldReceive('raw')->once()->andThrow(new RuntimeException('SMTP unavailable'));

        $this->postJson('/api/v1/contact', $this->validPayload())
            ->assertServiceUnavailable();
    }

    public function test_contact_endpoint_is_rate_limited_to_five_requests_per_minute(): void
    {
        config(['contact.to_address' => 'studio@example.test']);
        Mail::shouldReceive('raw')->times(5);

        for ($attempt = 0; $attempt < 5; $attempt++) {
            $this->postJson('/api/v1/contact', $this->validPayload())
                ->assertAccepted();
        }

        $this->postJson('/api/v1/contact', $this->validPayload())
            ->assertTooManyRequests();
    }
}
