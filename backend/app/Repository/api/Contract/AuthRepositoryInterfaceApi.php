<?php

namespace App\Repository\api\Contract;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use Illuminate\Http\JsonResponse;

interface AuthRepositoryInterfaceApi
{
    public function login(LoginRequest $request): JsonResponse;

    public function register(RegisterRequest $request): JsonResponse;
}
