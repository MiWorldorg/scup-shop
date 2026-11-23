<?php

namespace App\Repository\api;

use App\Http\Resources\PostResource;
use App\Models\Post;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;

class PostRepositoryApi implements PostRepositoryInterfaceApi
{
    public function selectPublished(): JsonResponse
    {
        $posts = Post::query()
            ->whereNotNull('published')
            ->orderByDesc('published')
            ->paginate(20);

        return response()->json([
            'code' => 1,
            'message' => 'Published posts.',
            'data' => PostResource::collection($posts)->response()->getData(true),
        ]);
    }

    public function selectAll(): JsonResponse
    {
        $posts = Post::query()
            ->orderByDesc('created_at')
            ->paginate(20);

        return response()->json([
            'code' => 1,
            'message' => 'Posts.',
            'data' => PostResource::collection($posts)->response()->getData(true),
        ]);
    }
}
