<?php

namespace App\Repository\api;

use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Http\Resources\PostResource;
use App\Models\Post;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

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

    public function insert(CreatePostRequest $request): JsonResponse
    {
        $data = $request->validated();
        $data['author_id'] = $request->user()->getKey();

        $post = Post::create($data);

        return response()->json([
            'code' => 1,
            'message' => 'Post created successfully.',
            'data' => new PostResource($post),
        ], 201);
    }

    public function destroy(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'id' => ['required', 'integer', 'exists:posts,id'],
        ]);

        $post = Post::findOrFail($validated['id']);
        $post->delete();

        return response()->json([
            'code' => 1,
            'message' => 'Post deleted successfully.',
            'data' => true,
        ]);
    }

    public function update(UpdatePostRequest $request): JsonResponse
    {
        $data = $request->validated();
        $id = $data['id'];
        unset($data['id']);

        $post = Post::findOrFail($id);
        $post->update($data);
        $post->refresh();

        return response()->json([
            'code' => 1,
            'message' => 'Post updated successfully.',
            'data' => new PostResource($post),
        ]);
    }
}
