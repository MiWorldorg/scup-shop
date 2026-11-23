<?php

namespace App\Repository\api\Contract;

use Illuminate\Contracts\Pagination\LengthAwarePaginator;

interface UserRepositoryInterfaceApi
{
    public function select(?string $search, ?string $role): LengthAwarePaginator;
}
