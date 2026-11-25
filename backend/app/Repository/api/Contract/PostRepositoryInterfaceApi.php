<?php

namespace App\Repository\api\Contract;

use Illuminate\Contracts\Pagination\LengthAwarePaginator;

interface PostRepositoryInterfaceApi
{
    public function selectPublished(): LengthAwarePaginator;

    public function selectAll(?string $search = null): LengthAwarePaginator;
}
