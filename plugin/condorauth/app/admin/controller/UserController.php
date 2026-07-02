<?php

declare(strict_types=1);

namespace plugin\condorauth\app\admin\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\condorauth\app\model\SystemUser;

class UserController extends Backend
{
    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemUser();
        $this->searchable = ['username', 'nickname', 'email', 'mobile'];
    }
}
