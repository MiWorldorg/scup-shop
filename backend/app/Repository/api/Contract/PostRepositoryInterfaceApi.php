<?php

namespace App\Repository\api\Contract;

use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\UpdatePostRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

interface PostRepositoryInterfaceApi
{
    public function selectPublished(): JsonResponse;

    public function selectAll(): JsonResponse;

    public function insert(CreatePostRequest $request): JsonResponse;

    public function destroy(Request $request): JsonResponse;

    public function update(UpdatePostRequest $request): JsonResponse;
}
