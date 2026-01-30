<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemAttachmentType;

class AttachmentTypeController extends Backend
{

    protected $dataLimit = true;

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAttachmentType();
    }

    public function index(Request $request)
    {
        $list = $this->model->get()->toArray();
        return $this->success(trans('ok'), array_merge([
            [
                'id' => 0,
                'name' => '未分组'
            ]
        ], $list));
    }
}
