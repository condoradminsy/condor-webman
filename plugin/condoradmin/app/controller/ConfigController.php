<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemConfig;
use plugin\condoradmin\app\service\SystemConfig as ConfigService;

class ConfigController extends Backend
{

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemConfig();
    }

    public function index(Request $request)
    {
        $group_id = $request->input('group_id', 0);
        $list = $this->model->where(function ($query) use ($group_id) {
            if ($group_id) {
                $query->where('group_id', $group_id);
            }
        })->orderBy('weigh', 'asc')->get();
        return $this->success(trans('condoradmin.ok'), $list);
    }

    // 保存配置项
    public function save(Request $request)
    {
        $group_code = $request->input('group_code', 0);
        $configs = $request->input('configs', []);
        if (empty($group_code) || empty($configs)) {
            return $this->fail(trans('condoradmin.invalid.parameters'));
        }
        $service = new ConfigService();
        $service->saveConfig($configs, $group_code);
        return $this->success(trans('condoradmin.saved.successfully'));
    }
}
