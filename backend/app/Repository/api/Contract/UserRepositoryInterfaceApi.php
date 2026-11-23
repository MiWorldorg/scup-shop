<?php

namespace App\Repository\api\Contract;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

interface UserRepositoryInterfaceApi
{
    public function select(Request $request): JsonResponse;
}
