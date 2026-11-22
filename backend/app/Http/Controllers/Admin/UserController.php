<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Repository\api\UserRepositoryApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function select(Request $request, UserRepositoryApi $userRepositoryApi): JsonResponse
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
        $actor = $request->user();

        if ($actor?->is($target) && $validated['role'] !== 'admin') {
            return response()->json([
                'code' => 2,
                'message' => 'You cannot remove your own administrator access.',
                'data' => null,
            ], 422);
        }

        $updated = DB::transaction(function () use ($target, $validated) {
            $admins = User::where('role', 'admin')->lockForUpdate()->get();
            $lockedTarget = User::whereKey($target->getKey())->lockForUpdate()->firstOrFail();

            if ($lockedTarget->role === 'admin'
                && $validated['role'] === 'user'
                && $admins->count() <= 1) {
                return false;
            }

            $lockedTarget->forceFill(['role' => $validated['role']])->save();
            return $lockedTarget;
        });

        if ($updated === false) {
            return response()->json([
                'code' => 2,
                'message' => 'At least one administrator account must remain.',
                'data' => null,
            ], 422);
        }

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
