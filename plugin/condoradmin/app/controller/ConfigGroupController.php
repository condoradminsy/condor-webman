<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemConfigGroup;

class ConfigGroupController extends Backend
{
    protected $createdByField = 'created_by';
    protected $updatedByField = 'updated_by';

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemConfigGroup();
    }

    public function index(Request $request)
    {
        $list = $this->model->orderBy('id', 'asc')->get();
        return $this->success(trans('condoradmin.ok'), $list);
    }
}
