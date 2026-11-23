<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function select(Request $request, UserRepositoryInterfaceApi $userRepositoryApi): JsonResponse
    {
        return $userRepositoryApi->select($request);
    }

    public function updateRole(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer', 'exists:users,id'],
            'role' => ['required', Rule::in(['user', 'admin'])],
        ]);

        $target = User::findOrFail($validated['id']);
        $actorId = $request->user()?->getKey();

        if ($actorId === null) {
            return response()->json([
                'code' => 2,
                'message' => 'Unauthenticated.',
                'data' => null,
            ], 401);
        }

        if ($actorId === $target->getKey() && $validated['role'] !== 'admin') {
            return response()->json([
                'code' => 2,
                'message' => 'You cannot remove your own administrator access.',
                'data' => null,
            ], 422);
        }

        $result = DB::transaction(function () use ($actorId, $target, $validated) {
            // Lock administrators in a stable order so concurrent role changes serialize.
            $admins = User::where('role', 'admin')
                ->orderBy('id')
                ->lockForUpdate()
                ->get();

            // Re-check the actor inside the transaction; middleware authorization may be stale.
            $lockedActor = User::whereKey($actorId)->lockForUpdate()->first();
            if (!$lockedActor || $lockedActor->role !== 'admin') {
                return ['status' => 'forbidden'];
            }

            $lockedTarget = User::whereKey($target->getKey())
                ->lockForUpdate()
                ->firstOrFail();

            if (
                $lockedTarget->role === 'admin'
                && $validated['role'] === 'user'
                && $admins->count() <= 1
            ) {
                return ['status' => 'last_admin'];
            }

            $lockedTarget->forceFill(['role' => $validated['role']])->save();

            return ['status' => 'updated', 'user' => $lockedTarget];
        });

        if ($result['status'] === 'forbidden') {
            return response()->json([
                'code' => 2,
                'message' => 'Administrator access is required.',
                'data' => null,
            ], 403);
        }

        if ($result['status'] === 'last_admin') {
            return response()->json([
                'code' => 2,
                'message' => 'At least one administrator account must remain.',
                'data' => null,
            ], 422);
        }

        $updated = $result['user'];

        return response()->json([
            'code' => 1,
            'message' => 'Account role updated.',
            'data' => [
                'id' => $updated->id,
                'role' => $updated->role,
            ],
        ]);
    }
}
