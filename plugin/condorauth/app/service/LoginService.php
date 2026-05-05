<?php

namespace plugin\condorauth\app\service;

use plugin\condorauth\app\factory\LoginStrategyFactory;
use plugin\condorauth\app\factory\LoginResult;

class LoginService
{
    public function login(string $type, array $params): LoginResult
    {
        $strategy = LoginStrategyFactory::make($type);

        $result = $strategy->login($params);

        if ($result->success) {
            $this->afterLogin($result->user);
        }

        return $result;
    }

    private function afterLogin(array $user)
    {
        // 模拟 token
        $user['token'] = base64_encode($user['id'] . '|' . time());
    }
}
