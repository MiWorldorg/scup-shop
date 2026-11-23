<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        $authorMap = [];
        foreach (DB::table('admins')->orderBy('id')->get() as $admin) {
            $user = DB::table('users')->where('email', $admin->email)->first();

            if ($user) {
                DB::table('users')->where('id', $user->id)->update([
                    'role' => 'admin',
                    'updated_at' => now(),
                ]);
                $userId = $user->id;
            } else {
                $userId = DB::table('users')->insertGetId([
                    'role' => 'admin',
                    'username' => $admin->username,
                    'password' => $admin->password,
                    'first_name' => $admin->first_name,
                    'last_name' => $admin->last_name,
                    'phone' => $admin->phone,
                    'address' => $admin->address,
                    'email' => $admin->email,
                    'email_verified_at' => null,
                    'remember_token' => $admin->remember_token,
                    'created_at' => $admin->created_at,
                    'updated_at' => $admin->updated_at,
                ]);
            }

            $authorMap[$admin->id] = $userId;
        }

        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign(['author_id']);
        });

        foreach (DB::table('posts')->orderBy('id')->get(['id', 'author_id']) as $post) {
            if (!isset($authorMap[$post->author_id])) {
                throw new RuntimeException(
                    "Cannot migrate post {$post->id}: its admin author was not found."
                );
            }

            DB::table('posts')->where('id', $post->id)->update([
                'author_id' => $authorMap[$post->author_id],
            ]);
        }

        Schema::table('posts', function (Blueprint $table) {
            $table->foreign('author_id')->references('id')->on('users');
            $table->timestamp('published')->nullable()->change();
            $table->string('post_picture')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign(['author_id']);
        });

        $authorMap = [];
        foreach (DB::table('users')
            ->whereIn('id', DB::table('posts')->select('author_id')->distinct())
            ->orderBy('id')
            ->get() as $user) {
            $admin = DB::table('admins')->where('email', $user->email)->first();

            if ($admin) {
                $adminId = $admin->id;
            } else {
                $adminId = DB::table('admins')->insertGetId([
                    'role' => 'admin',
                    'type' => 'manager',
                    'username' => $user->username,
                    'password' => $user->password,
                    'first_name' => $user->first_name,
                    'last_name' => $user->last_name,
                    'phone' => $user->phone,
                    'address' => $user->address,
                    'email' => $user->email,
                    'remember_token' => $user->remember_token,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }

            $authorMap[$user->id] = $adminId;
        }

        foreach (DB::table('posts')->orderBy('id')->get(['id', 'author_id']) as $post) {
            if (isset($authorMap[$post->author_id])) {
                DB::table('posts')->where('id', $post->id)->update([
                    'author_id' => $authorMap[$post->author_id],
                ]);
            }
        }

        DB::table('posts')->whereNull('published')->update(['published' => now()]);
        DB::table('posts')->whereNull('post_picture')->update(['post_picture' => '']);

        Schema::table('posts', function (Blueprint $table) {
            $table->foreign('author_id')->references('id')->on('admins');
            $table->timestamp('published')->nullable(false)->change();
            $table->string('post_picture')->nullable(false)->change();
        });
    }
}
