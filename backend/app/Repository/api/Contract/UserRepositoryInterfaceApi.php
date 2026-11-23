<?php

namespace App\Repository\api\Contract;

use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Request;

interface UserRepositoryInterfaceApi
{
    public function select(Request $request): LengthAwarePaginator;
}
