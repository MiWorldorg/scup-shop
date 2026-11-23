<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Repository\api\Contract\AuthRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function login(AuthRepositoryInterfaceApi $authRepository, LoginRequest $request): JsonResponse
    {
        return $authRepository->login($request);
    }

    public function register(AuthRepositoryInterfaceApi $authRepository, RegisterRequest $request): JsonResponse
    {
        return $authRepository->register($request);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()?->token()?->revoke();

        return response()->json([
            'code' => 1,
            'message' => 'Signed out successfully.',
            'data' => true,
        ]);
    }
}
