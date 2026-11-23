<?php

namespace App\Http\Controllers\Auth;

use App\Actions\Auth\AuthenticateUser;
use App\Actions\Auth\RegisterUser;
use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function login(
        LoginRequest $request,
        AuthenticateUser $authenticateUser
    ): JsonResponse {
        $result = $authenticateUser->execute(
            $request->validated('email'),
            $request->validated('password'),
        );

        if ($result === null) {
            return response()->json([
                'code' => 2,
                'message' => 'The email or password is incorrect.',
                'data' => null,
            ], 401);
        }

        $user = $result['user'];

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
                'token' => $result['token'],
            ],
        ]);
    }

    public function register(
        RegisterRequest $request,
        RegisterUser $registerUser
    ): JsonResponse {
        $result = $registerUser->execute($request->validated());
        $user = $result['user'];

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
                'token' => $result['token'],
            ],
        ], 201);
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
