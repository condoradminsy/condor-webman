<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemCrontab;

class CrontabController extends Backend
{

    protected array $searchable = [
        'status' => ['type','int'],
        'name' => ['type','string']
    ];

    protected $createdByField = 'created_by';
    protected $updatedByField = 'updated_by';

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemCrontab();
    }

    // 执行一次
    public function runOnce(Request $request)
    {
        $crontab_id = $request->input('id');
        if (empty($crontab_id)) {
            return $this->fail('缺少参数');
        }
        $crontabService = new \plugin\condoradmin\app\service\SystemCrontab();
        $status = $crontabService->run($crontab_id);
        if ($status) {
            return $this->success('执行成功');
        }
        return $this->fail('执行失败');
    }
}
