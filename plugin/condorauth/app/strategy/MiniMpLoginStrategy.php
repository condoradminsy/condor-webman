<?php

namespace plugin\condorauth\app\strategy;

use plugin\condorauth\app\model\SystemUser;
use plugin\condorauth\app\factory\LoginResult;

class MiniMpLoginStrategy implements LoginStrategy
{
    public function login(array $params): LoginResult
    {
        return new LoginResult([]);
    }
}
