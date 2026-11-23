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

    public function selectAll(?string $search = null): LengthAwarePaginator
    {
        return Post::query()
            ->when($search !== null && $search !== '', function ($query) use ($search) {
                $query->where(function ($matches) use ($search) {
                    $matches
                        ->where('title', 'like', '%'.$search.'%')
                        ->orWhere('slug', 'like', '%'.$search.'%')
                        ->orWhere('summary', 'like', '%'.$search.'%');
                });
            })
            ->orderByDesc('created_at')
            ->paginate(20);
    }
}
