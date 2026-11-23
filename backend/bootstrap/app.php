<?php

use App\Http\Middleware\ApiSecurityHeaders;
use App\Http\Middleware\EnsureAdmin;
use App\Http\Middleware\RequireHttps;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->alias([
            'admin' => EnsureAdmin::class,
        ]);
        $middleware->api(append: [ApiSecurityHeaders::class, RequireHttps::class]);
        $middleware->trustProxies(at: config('app.trusted_proxies', []));
    })
    ->withExceptions(function (Exceptions $exceptions) {
        $exceptions->render(function (
            ValidationException $exception,
            Request $request
        ) {
            if (!$request->is('api/*')) {
                return null;
            }

            return response()->json([
                'code' => 2,
                'message' => 'The submitted data is invalid.',
                'errors' => $exception->errors(),
                'data' => null,
            ], 422);
        });

        $exceptions->render(function (
            AuthenticationException $exception,
            Request $request
        ) {
            if (!$request->is('api/*')) {
                return null;
            }

            return response()->json([
                'code' => 2,
                'message' => 'Unauthenticated.',
                'data' => null,
            ], 401);
        });

        $exceptions->render(function (
            AuthorizationException $exception,
            Request $request
        ) {
            if (!$request->is('api/*')) {
                return null;
            }

            return response()->json([
                'code' => 2,
                'message' => $exception->getMessage() ?: 'Forbidden.',
                'data' => null,
            ], 403);
        });

        $exceptions->render(function (
            ModelNotFoundException|NotFoundHttpException $exception,
            Request $request
        ) {
            if (!$request->is('api/*')) {
                return null;
            }

            return response()->json([
                'code' => 2,
                'message' => 'The requested resource was not found.',
                'data' => null,
            ], 404);
        });
    })->create();
