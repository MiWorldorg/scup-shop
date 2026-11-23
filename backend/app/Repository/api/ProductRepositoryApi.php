<?php

namespace App\Repository\api;

use App\Http\Resources\ProductResource;
use App\Models\Product;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;

class ProductRepositoryApi implements ProductRepositoryInterfaceApi
{
    public function select(): JsonResponse
    {
        $products = Product::query()
            ->with(['category:id,name', 'inventory:id,quantity'])
            ->orderBy('id')
            ->paginate(20);

        return response()->json([
            'code' => 1,
            'message' => 'Products.',
            'data' => ProductResource::collection($products)->response()->getData(true),
        ]);
    }
}
