<?php

namespace App\Repository\api;

use App\Models\User;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;


class UserRepositoryApi implements UserRepositoryInterfaceApi
{

    //select users and pagination in address domain/v1/api/admin/user
    public function select(Request $request): JsonResponse
    {
        $query = User::select(
            "id",
            "role",
            "username",
            "first_name",
            "last_name",
            "phone",
            "address",
            "email",
            "email_verified_at"
        );

        if (in_array($request->query('role'), ['user', 'admin'], true)) {
            $query->where('role', $request->query('role'));
        }

        $search = trim((string) $request->query('search', ''));
        if ($search !== '') {
            $query->where(function ($users) use ($search) {
                $users->where('username', 'like', "%{$search}%")
                    ->orWhere('first_name', 'like', "%{$search}%")
                    ->orWhere('last_name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $users = $query->paginate(20)->appends($request->query());

        return response()->json([
            'code' => 1,
            'message' => 'Users',
            'data' => $users,
        ], 200);
    }
}
