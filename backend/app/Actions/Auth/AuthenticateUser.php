<?php

namespace App\Actions\Auth;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthenticateUser
{
    /**
     * Return the authenticated user and bearer token, or null for bad credentials.
     *
     * @return array{user: User, token: string}|null
     */
    public function execute(string $email, string $password): ?array
    {
        $user = User::query()->where('email', $email)->first();

        if (!$user || !Hash::check($password, $user->password)) {
            return null;
        }

        return [
            'user' => $user,
            'token' => $user->createToken('authToken')->accessToken,
        ];
    }
}
