<?php

use App\Http\Controllers\Admin\PostController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:api');

Route::prefix('v1')->group(function () {
    Route::prefix('admin')->middleware(['auth:api', 'admin'])->group(function () {
        Route::prefix('product')->group(function () {
            Route::get('/', [ProductController::class, 'select']);
            Route::get('/categories', [ProductController::class, 'categories']);
            Route::post('/create', [ProductController::class, 'insert']);
            Route::put('/update', [ProductController::class, 'update']);
            Route::delete('/delete', [ProductController::class, 'destroy']);
        });

        Route::prefix('post')->group(function () {
            Route::get('/', [PostController::class, 'selectAdmin']);
            Route::get('/categories', [PostController::class, 'categories']);
            Route::post('/create', [PostController::class, 'insert']);
            Route::put('/update', [PostController::class, 'update']);
            Route::delete('/delete', [PostController::class, 'destroy']);
        });

        Route::prefix('user')->group(function () {
            Route::get('/', [UserController::class, 'select']);
            Route::put('/role', [UserController::class, 'updateRole']);
        });
    });

    Route::get('/post', [PostController::class, 'selectPublic']);
    Route::get('/product', [ProductController::class, 'select']);
});

require __DIR__.'/auth.php';
