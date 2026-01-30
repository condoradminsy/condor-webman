<?php

namespace plugin\condoradmin\app\service;

use plugin\condoradmin\app\model\SystemCrontab as CrontabModel;
use plugin\condoradmin\app\model\SystemCrontabLog;
use Webman\Channel\Client;

class SystemCrontab extends BaseService
{
    /**
     * 构造函数
     */
    public function __construct()
    {
        $this->model = new CrontabModel();
    }

    public static function reloadCrontab($type, $id)
    {
        Client::connect();
        Client::publish('condor-crontab', ['id' => $id, 'type' => $type]);
    }

    /**
     * 执行任务
     * @param [type] $id
     * @return void
     */
    public function run($id)
    {
        $info = $this->model->find($id);
        if (empty($info) || $info->status != 1) {
            return false;
        }
        $data['crontab_id'] = $id;
        $data['name'] = $info->name;
        $data['target'] = $info->target;
        $data['params'] = $info->params;
        try {
            switch ($info->type) {
                case 1:
                    $class = $info->target;
                    $method = 'run';
                    $class = new $class;
                    if (method_exists($class, $method)) {
                        $return = $class->$method($info->params);
                        $data['status'] = 1;
                        $data['exception_info'] = $return;
                    } else {
                        $data['status'] = 2;
                        $data['exception_info'] = '类:' . $class . ',方法:run,未找到';
                    }
                    break;
                default:
                    break;
            }
        } catch (\Throwable $e) {
            $data['status'] = 2;
            $data['exception_info'] = $e->getMessage();
        }
        SystemCrontabLog::create($data);
        return $data['status'] === 1;
    }
}
