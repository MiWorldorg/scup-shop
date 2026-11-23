<?php

namespace App\\Http\\Requests;

use Illuminate\\Foundation\\Http\\FormRequest;

class ContactMessageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'first_name' => ['required', 'string', 'max:80'],
            'last_name' => ['required', 'string', 'max:80'],
            'email' => ['required', 'email:rfc', 'max:255'],
            'message' => ['required', 'string', 'min:10', 'max:5000'],
            // A hidden honeypot field helps reject basic automated submissions.
            'website' => ['nullable', 'string', 'max:0'],
        ];
    }
}
