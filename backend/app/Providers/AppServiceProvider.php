<?php

namespace App\Providers;

use App\Repository\api\AuthRepositoryApi;
use App\Repository\api\Contract\AuthRepositoryInterfaceApi;
use App\Repository\api\Contract\PostRepositoryInterfaceApi;
use App\Repository\api\Contract\ProductRepositoryInterfaceApi;
use App\Repository\api\Contract\UserRepositoryInterfaceApi;
use App\Repository\api\PostRepositoryApi;
use App\Repository\api\ProductRepositoryApi;
use App\Repository\api\UserRepositoryApi;
use Illuminate\Support\ServiceProvider;
use Laravel\Passport\Passport;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(AuthRepositoryInterfaceApi::class, AuthRepositoryApi::class);
        $this->app->bind(PostRepositoryInterfaceApi::class, PostRepositoryApi::class);
        $this->app->bind(ProductRepositoryInterfaceApi::class, ProductRepositoryApi::class);
        $this->app->bind(UserRepositoryInterfaceApi::class, UserRepositoryApi::class);
    }

    public function boot(): void
    {
        Passport::tokensExpireIn(now()->addHours(2));
        Passport::refreshTokensExpireIn(now()->addDays(30));
        Passport::personalAccessTokensExpireIn(now()->addDays(30));
    }
}
