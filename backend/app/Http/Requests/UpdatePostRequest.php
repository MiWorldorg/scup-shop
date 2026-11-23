<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdatePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $postId = $this->input('id');

        return [
            'id' => ['required', 'integer'],
            'category_id' => ['sometimes', 'required', 'integer', 'exists:post_categories,id'],
            'slug' => [
                'sometimes',
                'required',
                'string',
                'max:255',
                Rule::unique('posts', 'slug')->ignore($postId),
            ],
            'title' => ['sometimes', 'required', 'string', 'max:255'],
            'published' => ['sometimes', 'nullable', 'date'],
            'summary' => ['sometimes', 'required', 'string', 'max:1000'],
            'content' => ['sometimes', 'required', 'string'],
            'post_picture' => [
                'sometimes',
                'nullable',
                'string',
                'max:255',
                'regex:/^assets\\/images\\/posts\\/[A-Za-z0-9 _.-]+\\.(png|jpe?g|webp)$/i',
            ],
        ];
    }
}
