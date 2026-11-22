<?php

namespace App\Repository\api;


use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use App\Repository\api\Contract\AuthRepositoryInterfaceApi;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;




class AuthRepositoryApi implements AuthRepositoryInterfaceApi
{

    public function login(LoginRequest $request): JsonResponse
    {
        $email = $request["email"];
        $password = $request["password"];

        $user = User::where('email', $email)->first();
        if (!$user || !Hash::check($password, $user->password)) {
            return response()->json([
                'code' => 2,
                'message' => 'The email or password is incorrect.',
                'data' => null,
            ], 400);
        }

        $accessToken = $user->createToken("authToken")->accessToken;

        return response()->json([
            'code' => 1,
            'message' => 'Login successful',
            'data' => [
                'id' => $user->id,
                'username' => $user->username,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
                'token' => $accessToken,
            ],
        ], 200);
    }

    public function register(RegisterRequest $request): JsonResponse
    {
        $user=User::create($request->all());
        $accessToken = $user->createToken("authToken")->accessToken;
        $user['token']=$accessToken;

        if ($user){
            return response()->json([
                'code' => 1,
                'message' => 'Operation completed successfully.',
                'data' => $user,
            ], 200);
        }
        return response()->json([
            'code' => 2,
            'message' => 'The email or password is incorrect.',
            'data' => null,
        ], 400);
    }
}
