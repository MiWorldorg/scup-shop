<?php

namespace App\Repository\api;


use App\Http\Requests\CreatePostRequest;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Models\Post;
use App\Models\product;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;



class PostRepositoryApi implements PostRepositoryInterfaceApi
{

    //select posts and pagination in address  domain/v1/api/posts
    public function select(): JsonResponse
    {
        $posts = Post::select(
            "id",
            "post_picture",
            "author_id",
            "category_id",
            "slug",
            "title",
            "published",
            "summary",
            "content"
        )
            ->paginate(20);

        return response()->json([
            'code' => 1,
            'message' => 'Posts',
            'data' => $posts,
        ], 200);
    }

    //insert post and pagination in address  domain/v1/api/admin/post/create
    public function insert(CreatePostRequest $request): JsonResponse
    {

        $data = $request->all();
        if (!$data) {
            return response()->json([
                'code' => 2,
                'message' => 'The submitted information is invalid.',
                'data' => null,
            ], 400);
        }

        $post = Post::create($data);

        if ($post) {
            return response()->json([
                'code' => 1,
                'message' => 'Post created successfully.',
                'data' => $post,
            ], 200);
        }

        return response()->json([
            'code' => 2,
            'message' => 'The submitted information is invalid.',
            'data' => null,
        ], 400);
    }

    //delete post and pagination in address  domain/v1/api/admin/post/delete
    public function destroy(Request $request): JsonResponse
    {
        $id = $request->id;

        if (!$id) {
            return response()->json([
                'code' => 2,
                'message' => 'ID not found.',
                'data' => null,
            ], 400);
        }

        $post = Post::find($id);

        if (!$post) {
            return response()->json([
                'code' => 2,
                'message' => 'ID not found.',
                'data' => null,
            ], 400);
        }
        $post->delete();
        return response()->json([
            'code' => 1,
            'message' => 'Post deleted successfully.',
            'data' => true,
        ], 200);
    }


    //update post in address domain/v1/api/admin/post/update
    public function update(UpdatePostRequest $request): JsonResponse
    {
        $data = $request->all();

        $id = $request->id;



        if (!$id) {
            return response()->json([
                'code' => 2,
                'message' => 'Invalid post ID.',
                'data' => null,
            ], 400);
        }

        $post = Post::find($id);



        $post->update($data);

        return response()->json([
            'code' => 1,
            'message' => 'Operation completed successfully.',
            'data' => $post,
        ], 400);
    }
}
