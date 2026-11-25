<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Models\PostCategory;
use App\Repository\api\PostRepositoryApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function selectPublic(PostRepositoryApi $repository): JsonResponse
    {
        return $repository->selectPublished();
    }

    public function selectAdmin(PostRepositoryApi $repository): JsonResponse
    {
        return $repository->selectAll();
    }

    public function categories(): JsonResponse
    {
        return response()->json([
            'code' => 1,
            'message' => 'Post categories.',
            'data' => PostCategory::query()
                ->select('id', 'title')
                ->orderBy('title')
                ->get(),
        ]);
    }

    public function insert(PostRepositoryApi $repository, CreatePostRequest $request): JsonResponse
    {
        return $repository->insert($request);
    }

    public function destroy(PostRepositoryApi $repository, Request $request): JsonResponse
    {
        return $repository->destroy($request);
    }

    public function update(PostRepositoryApi $repository, UpdatePostRequest $request): JsonResponse
    {
        return $repository->update($request);
    }
}
