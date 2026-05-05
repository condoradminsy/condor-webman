<?php
namespace plugin\condorauth\app\factory;

class LoginResult
{
    public function __construct(
        public bool $success,
        public ?array $user = null,
        public ?string $message = null
    ) {}
}