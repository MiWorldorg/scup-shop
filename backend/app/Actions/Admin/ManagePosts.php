<?php

namespace App\Actions\Admin;

use App\Models\Post;
use Illuminate\Support\Facades\DB;

class ManagePosts
{
    public function create(array $data, int $authorId): Post
    {
        $data['author_id'] = $authorId;

        return Post::create($data);
    }

    public function update(int $id, array $data): Post
    {
        unset($data['id']);

        $post = Post::query()->findOrFail($id);
        $post->update($data);

        return $post->refresh();
    }

    public function delete(int $id): void
    {
        $post = Post::query()->findOrFail($id);
        $post->delete();
    }
}
