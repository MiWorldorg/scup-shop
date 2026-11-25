<?php

namespace App\Repository\api;

use App\Models\Product;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class ProductRepositoryApi implements ProductRepositoryInterfaceApi
{
    public function select(?int $categoryId = null, ?string $search = null): LengthAwarePaginator
    {
        return Product::query()
            ->with(['category:id,name', 'inventory:id,quantity'])
            ->when($categoryId !== null, fn ($query) => $query->where('category_id', $categoryId))
            ->when($search !== null && $search !== '', function ($query) use ($search) {
                $query->where(function ($matches) use ($search) {
                    $matches
                        ->where('name', 'like', '%'.$search.'%')
                        ->orWhere('sku', 'like', '%'.$search.'%')
                        ->orWhere('desc', 'like', '%'.$search.'%');
                });
            })
            ->orderBy('id')
            ->paginate(20);
    }
}
