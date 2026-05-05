<?php
namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\factory\LoginResult;

interface LoginStrategy
{
    public function login(array $params): LoginResult;
}