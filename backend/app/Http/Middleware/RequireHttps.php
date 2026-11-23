<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RequireHttps
{
    public function handle(Request $request, Closure $next): Response
    {
        if (!app()->environment('production') || $request->isSecure()) {
            return $next($request);
        }

        return response()->json([
            'code' => 2,
            'message' => 'HTTPS is required for API requests.',
            'data' => null,
        ], 426);
    }
}
