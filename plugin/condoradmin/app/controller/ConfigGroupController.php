<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemConfigGroup;
use support\Db;

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
}
