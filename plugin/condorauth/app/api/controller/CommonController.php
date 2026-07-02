<?php

namespace plugin\condorauth\app\api\controller;

use support\Request;

class CommonController
{

    public function index()
    {
        return view('index/index', ['name' => 'condorauth']);
    }

}
