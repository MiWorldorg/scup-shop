<?php

namespace App\Repository\api;

use App\Models\Product;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class ProductRepositoryApi implements ProductRepositoryInterfaceApi
{
    public function select(): LengthAwarePaginator
    {
        return Product::query()
            ->with(['category:id,name', 'inventory:id,quantity'])
            ->orderBy('id')
            ->paginate(20);
    }
}
