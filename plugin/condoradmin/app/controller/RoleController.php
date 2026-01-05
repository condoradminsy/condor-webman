<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemRole;
use plugin\condoradmin\app\library\Tree;

class RoleController extends Backend
{

    protected $dataLimit = true;

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemRole();
    }

    public function index(Request $request)
    {
        // 非超级管理员只能看到自己管理的角色
        $adminIds = $this->getDataLimitAdminIds();
        $list = $this->model->where(function ($query) use ($adminIds) {
            if (!empty($adminIds)) {
                $query->whereIn('admin_id', $adminIds);
            }
        })->get()->toArray();
        $tree = new Tree();
        $list = $tree->makeTree($list);
        return $this->success(trans('ok'), $list);
    }

    public function selectpage(Request $request)
    {
        $is_tree = $request->input('is_tree', 1);
        // 非超级管理员只能看到自己管理的角色
        $adminIds = $this->getDataLimitAdminIds();
        $list = $this->model->where('status', 1)->where(function ($query) use ($adminIds) {
            if (!empty($adminIds)) {
                $query->whereIn('admin_id', $adminIds);
            }
        })->get(['id', 'name', 'pid'])->toArray();
        if ($is_tree) {
            $tree = new Tree();
            $list = $tree->makeTree($list);
        }
        return $this->success(trans('ok'), $list);
    }

    public function add(Request $request)
    {
        // rules 判断在自己权限范围内
        $rules = $request->input('rules');
        $rules = $this->auth->filterRule($rules);
        $request->setPost('rules', is_array($rules) ? implode(',', $rules) : $rules);
        return parent::add($request);
    }

    public function edit(Request $request)
    {
        // rules 判断在自己权限范围内
        $rules = $request->input('rules');
        $rules = $this->auth->filterRule($rules);
        $request->setPost('rules', is_array($rules) ? implode(',', $rules) : $rules);
        return parent::edit($request);
    }
}
