<?php

namespace App\Http\Controllers\Admin;

use App\Actions\Admin\ManagePosts;
use App\Http\Controllers\Controller;
use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\DeletePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Http\Resources\PostResource;
use App\Models\PostCategory;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function selectPublic(PostRepositoryInterfaceApi $posts): JsonResponse
    {
        $data = PostResource::collection($posts->selectPublished())
            ->response()
            ->getData(true);

        return response()->json([
            'code' => 1,
            'message' => 'Published posts.',
            'data' => $data,
        ]);
    }

    public function selectAdmin(
        Request $request,
        PostRepositoryInterfaceApi $posts
    ): JsonResponse {
        $search = trim($request->string('search')->toString());
        $data = PostResource::collection(
            $posts->selectAll($search !== '' ? $search : null)
        )
            ->response()
            ->getData(true);

        return response()->json([
            'code' => 1,
            'message' => 'Posts.',
            'data' => $data,
        ]);
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

    public function insert(
        CreatePostRequest $request,
        ManagePosts $managePosts
    ): JsonResponse {
        $post = $managePosts->create(
            $request->validated(),
            (int) $request->user()->getKey(),
        );

        return response()->json([
            'code' => 1,
            'message' => 'Post created successfully.',
            'data' => new PostResource($post),
        ], 201);
    }

    public function destroy(
        DeletePostRequest $request,
        ManagePosts $managePosts
    ): JsonResponse {
        $managePosts->delete((int) $request->validated('id'));

        return response()->json([
            'code' => 1,
            'message' => 'Post deleted successfully.',
            'data' => true,
        ]);
    }

    public function update(
        UpdatePostRequest $request,
        ManagePosts $managePosts
    ): JsonResponse {
        $validated = $request->validated();
        $post = $managePosts->update((int) $validated['id'], $validated);

        return response()->json([
            'code' => 1,
            'message' => 'Post updated successfully.',
            'data' => new PostResource($post),
        ]);
    }
}
