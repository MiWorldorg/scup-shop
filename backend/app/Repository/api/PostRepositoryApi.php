<?php

namespace App\Repository\api;

use App\Models\Post;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class PostRepositoryApi implements PostRepositoryInterfaceApi
{
    public function selectPublished(): LengthAwarePaginator
    {
        return Post::query()
            ->whereNotNull('published')
            ->orderByDesc('published')
            ->paginate(20);
    }

    public function selectAll(): LengthAwarePaginator
    {
        return Post::query()
            ->orderByDesc('created_at')
            ->paginate(20);
    }
}
