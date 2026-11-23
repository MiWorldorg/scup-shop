<?php

namespace App\Repository\api;

use App\Models\User;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Request;

class UserRepositoryApi implements UserRepositoryInterfaceApi
{
    public function select(Request $request): LengthAwarePaginator
    {
        $query = User::query()->select(
            'id',
            'role',
            'username',
            'first_name',
            'last_name',
            'phone',
            'address',
            'email',
            'email_verified_at',
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

        return $query->orderBy('id')->paginate(20)->appends($request->query());
    }
}
