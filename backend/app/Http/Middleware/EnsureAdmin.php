<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user()?->role !== 'admin') {
            return response()->json([
                'code' => 2,
                'message' => 'Administrator access is required.',
                'data' => null,
            ], 403);
        }

        return $next($request);
    }
}
