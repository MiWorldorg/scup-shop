<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CreatePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'category_id' => ['required', 'integer', 'exists:post_categories,id'],
            'slug' => ['required', 'string', 'max:255', Rule::unique('posts', 'slug')],
            'title' => ['required', 'string', 'max:255'],
            'published' => ['nullable', 'date'],
            'summary' => ['required', 'string', 'max:1000'],
            'content' => ['required', 'string'],
            'post_picture' => ['nullable', 'string', 'max:255'],
        ];
    }
}
