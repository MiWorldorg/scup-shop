<?php

namespace App\Repository\api;

use App\Models\User;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class UserRepositoryApi implements UserRepositoryInterfaceApi
{
    public function select(?string $search, ?string $role): LengthAwarePaginator
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

        if (in_array($role, ['user', 'admin'], true)) {
            $query->where('role', $role);
        }

        $search = trim((string) $search);
        if ($search !== '') {
            $query->where(function ($users) use ($search) {
                $users->where('username', 'like', "%{$search}%")
                    ->orWhere('first_name', 'like', "%{$search}%")
                    ->orWhere('last_name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        return $query->orderBy('id')->paginate(20)->appends(array_filter([
            'search' => $search,
            'role' => $role,
        ], fn ($value) => $value !== null && $value !== ''));
    }
}
