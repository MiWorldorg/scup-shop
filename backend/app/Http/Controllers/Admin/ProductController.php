<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Models\ProductCategory;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function select(ProductRepositoryInterfaceApi $productRepositoryApi)
    {
        return $productRepositoryApi->select();
    }

    public function categories()
    {
        return response()->json([
            'code' => 1,
            'message' => 'Product categories',
            'data' => ProductCategory::query()
                ->select('id', 'name')
                ->orderBy('name')
                ->get(),
        ]);
    }

    public function insert(ProductRepositoryApi $productRepositoryApi, StoreProductRequest $request)
    {
        return $productRepositoryApi->insert($request);
    }

    public function destroy(ProductRepositoryApi $productRepositoryApi, Request $request)
    {
        return $productRepositoryApi->destroy($request);
    }

    public function update(ProductRepositoryApi $productRepositoryApi, UpdateProductRequest $request)
    {
        return $productRepositoryApi->update($request);
    }
}
