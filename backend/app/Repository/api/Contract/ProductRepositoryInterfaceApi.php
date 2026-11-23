<?php

namespace App\Repository\api\Contract;

use App\Http\Requests\DeleteProductRequest;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use Illuminate\Http\JsonResponse;

interface ProductRepositoryInterfaceApi
{
    public function select(): JsonResponse;

    public function insert(StoreProductRequest $request): JsonResponse;

    public function destroy(DeleteProductRequest $request): JsonResponse;

    public function update(UpdateProductRequest $request): JsonResponse;
}
