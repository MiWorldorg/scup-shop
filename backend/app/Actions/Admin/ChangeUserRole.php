<?php

namespace App\Actions\Admin;

use App\Models\User;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class ChangeUserRole
{
    public function execute(int $actorId, int $targetId, string $role): User
    {
        return DB::transaction(function () use ($actorId, $targetId, $role) {
            // Lock all administrators in a stable order so concurrent demotions serialize.
            $administrators = User::query()
                ->where('role', 'admin')
                ->orderBy('id')
                ->lockForUpdate()
                ->get();

            $actor = User::query()->lockForUpdate()->find($actorId);
            if (!$actor || $actor->role !== 'admin') {
                throw new AuthorizationException('Administrator access is required.');
            }

            $target = User::query()->lockForUpdate()->findOrFail($targetId);

            if ($actorId === $targetId && $role !== 'admin') {
                throw ValidationException::withMessages([
                    'role' => 'You cannot remove your own administrator access.',
                ]);
            }

            if (
                $target->role === 'admin'
                && $role === 'user'
                && $administrators->count() <= 1
            ) {
                throw ValidationException::withMessages([
                    'role' => 'At least one administrator account must remain.',
                ]);
            }

            $target->forceFill(['role' => $role])->save();

            return $target->refresh();
        });
    }
}
