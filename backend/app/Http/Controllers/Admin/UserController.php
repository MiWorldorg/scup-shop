<?php

namespace App\Http\Controllers\Admin;

use App\Actions\Admin\ChangeUserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateUserRoleRequest;
use App\Http\Resources\UserResource;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function select(
        Request $request,
        UserRepositoryInterfaceApi $userRepository
    ): JsonResponse {
        $data = UserResource::collection($userRepository->select(
                $request->query('search'),
                $request->query('role'),
            ))
            ->response()
            ->getData(true);

        return response()->json([
            'code' => 1,
            'message' => 'Users.',
            'data' => $data,
        ]);
    }

    public function updateRole(
        UpdateUserRoleRequest $request,
        ChangeUserRole $changeUserRole
    ): JsonResponse {
        $validated = $request->validated();
        $updated = $changeUserRole->execute(
            (int) $request->user()->getKey(),
            (int) $validated['id'],
            $validated['role'],
        );

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
