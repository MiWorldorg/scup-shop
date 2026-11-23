<?php

namespace App\Repository\api\Contract;

use Illuminate\Http\JsonResponse;

interface PostRepositoryInterfaceApi
{
    public function selectPublished(): JsonResponse;

    public function selectAll(): JsonResponse;
}
