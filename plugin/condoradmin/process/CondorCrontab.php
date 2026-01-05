<?php

namespace plugin\condoradmin\process;


use Workerman\Crontab\Crontab;
use Webman\Channel\Client;
use plugin\condoradmin\app\model\SystemCrontab;
use plugin\condoradmin\app\service\SystemCrontab as SystemCrontabService;
use support\Log;

class CondorCrontab
{

    public $crontabIds = [];

    protected $crontabService;

    public function __construct()
    {
        $this->crontabService = new SystemCrontabService();
        Client::connect();
        // 订阅事件并注册回调
        Client::on('condor-crontab', function ($data) {
            $this->reload($data);
        });
    }

    public function onWorkerStart()
    {
        $this->initCrontab();
    }

    /**
     * 初始化任务
     * @return void
     */
    public function initCrontab()
    {
        $list = SystemCrontab::where('status', 1)->get(['id', 'name', 'cron']);
        foreach ($list as $item) {
            if (!empty($item->cron)) {
                $crontab = new Crontab($item->cron, function () use ($item) {
                    // 执行任务
                    $this->crontabService->run($item->id);
                });
                $this->crontabIds[$item->id] = $crontab->getId();
                Log::error(date('Y-m-d H:i:s') . " => 定时任务[" . $item->id . "]:执行启动，当前任务数[" . count(Crontab::getAll()) . "]");
            }
        }
    }

    /**
     * 重新加载任务
     * @param [type] $data
     * @return void
     */
    public function reload($data)
    {
        $id = $data['id'] ?? 0;
        $type = $data['type'] ?? '';
        if (isset($this->crontabIds[$id])) {
            Crontab::remove($this->crontabIds[$id]);
            unset($this->crontabIds[$id]);
            Log::error(date('Y-m-d H:i:s') . " => 定时任务[" . $id . "-" . $type . "]:执行移除，剩余[" . count(Crontab::getAll()) . "]个任务");
            if ($type == 'del') {
                return;
            }
        }
        $row = SystemCrontab::where('status', 1)->where('id', $id)->first();
        if (!empty($row) && !empty($row->cron)) {
            $crontab = new Crontab($row->cron, function () use ($row) {
                // 执行任务
                $this->crontabService->run($row->id);
            });
            $this->crontabIds[$id] = $crontab->getId();
            Log::error(date('Y-m-d H:i:s') . " => 定时任务[" . $row->id . "-" . $type . "]:重新执行启动，当前任务数[" . count(Crontab::getAll()) . "]");
        }
    }
}
