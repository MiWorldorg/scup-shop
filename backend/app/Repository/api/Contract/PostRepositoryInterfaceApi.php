<?php

namespace App\Repository\api\Contract;

use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\DeletePostRequest;
use App\Http\Requests\UpdatePostRequest;
use Illuminate\Http\JsonResponse;

interface PostRepositoryInterfaceApi
{
    public function selectPublished(): JsonResponse;

    public function selectAll(): JsonResponse;

    public function insert(CreatePostRequest $request): JsonResponse;

    public function destroy(DeletePostRequest $request): JsonResponse;

    public function update(UpdatePostRequest $request): JsonResponse;
}
