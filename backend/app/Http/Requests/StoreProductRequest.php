<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProductRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'desc' => ['required', 'string', 'max:255'],
            'sku' => ['required', 'string', 'max:255', Rule::unique('products', 'sku')],
            'image' => ['nullable', 'string', 'max:255'],
            'category_id' => ['required', 'integer', 'exists:product_categories,id'],
            'inventory_id' => [
                'nullable',
                'integer',
                'exists:product_inventories,id',
                Rule::unique('products', 'inventory_id'),
            ],
            'quantity' => ['nullable', 'integer', 'min:0'],
            'price' => ['required', 'integer', 'min:0'],
        ];
    }
}
