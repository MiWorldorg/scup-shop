<?php

namespace App\Actions\Auth;

use App\Models\User;

class RegisterUser
{
    /**
     * @return array{user: User, token: string}
     */
    public function execute(array $validated): array
    {
        $user = User::create([
            ...$validated,
            'role' => 'user',
        ]);

        return [
            'user' => $user,
            'token' => $user->createToken('authToken')->accessToken,
        ];
    }
}
