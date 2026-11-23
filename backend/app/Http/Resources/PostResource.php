<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'post_picture' => $this->post_picture,
            'author_id' => $this->author_id,
            'category_id' => $this->category_id,
            'slug' => $this->slug,
            'title' => $this->title,
            'published' => $this->published,
            'summary' => $this->summary,
            'content' => $this->content,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
