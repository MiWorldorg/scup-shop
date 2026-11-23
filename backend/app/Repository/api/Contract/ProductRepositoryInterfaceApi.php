<?php

namespace App\Repository\api\Contract;

use Illuminate\Contracts\Pagination\LengthAwarePaginator;

interface ProductRepositoryInterfaceApi
{
    public function select(): LengthAwarePaginator;
}
