<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateProductRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $productId = $this->input('id');

        return [
            'id' => ['required', 'integer'],
            'name' => ['sometimes', 'required', 'string', 'max:255'],
            'desc' => ['sometimes', 'required', 'string', 'max:255'],
            'sku' => [
                'sometimes',
                'required',
                'string',
                'max:255',
                Rule::unique('products', 'sku')->ignore($productId),
            ],
            'image' => [
                'sometimes',
                'nullable',
                'string',
                'max:255',
                'regex:/^assets\\/images\\/products\\/[A-Za-z0-9 _.-]+\\.(png|jpe?g|webp)$/i',
            ],
            'category_id' => ['sometimes', 'required', 'integer', 'exists:product_categories,id'],
            'inventory_id' => [
                'sometimes',
                'required',
                'integer',
                'exists:product_inventories,id',
                Rule::unique('products', 'inventory_id')->ignore($productId),
            ],
            'quantity' => ['sometimes', 'required', 'integer', 'min:0'],
            'price' => ['sometimes', 'required', 'integer', 'min:0'],
        ];
    }
}
