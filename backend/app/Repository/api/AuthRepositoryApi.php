<?php

namespace App\Repository\api;

use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use App\Repository\api\Contract\AuthRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

class AuthRepositoryApi implements AuthRepositoryInterfaceApi
{
    public function login(LoginRequest $request): JsonResponse
    {
        $credentials = $request->validated();
        $user = User::where('email', $credentials['email'])->first();

        if (!$user || !Hash::check($credentials['password'], $user->password)) {
            return response()->json([
                'code' => 2,
                'message' => 'The email or password is incorrect.',
                'data' => null,
            ], 401);
        }

        $accessToken = $user->createToken('authToken')->accessToken;

        return response()->json([
            'code' => 1,
            'message' => 'Login successful.',
            'data' => [
                'id' => $user->id,
                'username' => $user->username,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
                'token' => $accessToken,
            ],
        ]);
    }

    public function register(RegisterRequest $request): JsonResponse
    {
        // Public registration deliberately accepts no role or privilege fields.
        $user = User::create($request->safe()->only([
            'username',
            'first_name',
            'last_name',
            'phone',
            'address',
            'email',
            'password',
        ]));

        $accessToken = $user->createToken('authToken')->accessToken;

        return response()->json([
            'code' => 1,
            'message' => 'Account created successfully.',
            'data' => [
                'id' => $user->id,
                'username' => $user->username,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
                'token' => $accessToken,
            ],
        ], 201);
    }
}
