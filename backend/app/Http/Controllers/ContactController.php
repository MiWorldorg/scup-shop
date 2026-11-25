<?php

namespace App\Http\Controllers;

use App\Http\Requests\ContactMessageRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Mail;
use Throwable;

class ContactController extends Controller
{
    public function store(ContactMessageRequest $request): JsonResponse
    {
        $recipient = config('contact.to_address');

        if (!is_string($recipient) || filter_var($recipient, FILTER_VALIDATE_EMAIL) === false) {
            return response()->json([
                'code' => 2,
                'message' => 'The contact service is not configured yet.',
                'data' => null,
            ], 503);
        }

        $message = $request->validated();
        $senderName = trim($message['first_name'].' '.$message['last_name']);
        $body = implode("\n", [
            'A new message was submitted through the Scup-Shop contact form.',
            '',
            'Name: '.$senderName,
            'Email: '.$message['email'],
            '',
            'Message:',
            $message['message'],
        ]);

        try {
            Mail::raw($body, function ($mail) use ($recipient, $message, $senderName): void {
                $mail
                    ->to($recipient)
                    ->replyTo($message['email'], $senderName)
                    ->subject('New Scup-Shop contact message');
            });
        } catch (Throwable $exception) {
            report($exception);

            return response()->json([
                'code' => 2,
                'message' => 'Your message could not be sent right now. Please try again later.',
                'data' => null,
            ], 503);
        }

        return response()->json([
            'code' => 1,
            'message' => 'Your message has been accepted.',
            'data' => true,
        ], 202);
    }
}
