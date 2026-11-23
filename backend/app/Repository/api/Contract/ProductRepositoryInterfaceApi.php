<?php

namespace App\Repository\api\Contract;

use Illuminate\Http\JsonResponse;

interface ProductRepositoryInterfaceApi
{
    public function select(): JsonResponse;
}
