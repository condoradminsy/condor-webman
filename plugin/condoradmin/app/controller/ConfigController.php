<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemConfig;
use plugin\condoradmin\app\service\SystemConfig as ConfigService;
use support\Db;

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

    /**
     * 删除
     *
     * @param $ids
     * @return void
     */
    public function del(Request $request)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans('condoradmin.request.method.incorrect'));
        }
        $ids = $request->post("ids") ?: $request->post("id");
        if (empty($ids)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        $pk = $this->model->getKeyName();
        if (!is_array($ids)) {
            // 是否有,号
            if (strpos($ids, ',') !== false) {
                $ids = explode(',', $ids);
            } else {
                $ids = [$ids];
            }
        }
        $query = $this->model->where('is_sys', 0)->whereIn($pk, $ids);
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && is_array($adminIds)) {
                $query->whereIn($this->dataLimitField, $adminIds);
            }
        }
        $list = $query->get();
        $count = 0;
        Db::beginTransaction();
        try {
            foreach ($list as $item) {
                $count += $item->delete();
            }
            Db::commit();
        } catch (\Throwable $e) {
            Db::rollback();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.delete.failed'));
        }
        if ($count) {
            return $this->success();
        }
        return $this->fail(trans('condoradmin.no.rows.were.deleted'));
    }

    // 发送测试邮件
    public function sendTestEmail(Request $request){
        $email = $request->input('email', '');
        if(empty($email)){
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
       $emailer = new \plugin\condoradmin\app\library\Email();
       if($emailer->send($email, '测试主题', '测试内容')){
           return $this->success(trans('condoradmin.operation.successful'));
       }
       return $this->fail(trans('condoradmin.send.failed'));
    }
}
