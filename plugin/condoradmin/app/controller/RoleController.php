<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\condoradmin\app\model\SystemRole;
use plugin\condoradmin\app\library\Tree;
use plugin\condoradmin\app\model\SystemRoleTranslations;

class RoleController extends TranslatableBackend
{

    protected $dataLimit = true;

    // 多语言字段
    protected array $multilingualFields = ['name'];


    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemRole();
        // 多语言表模型
        $this->translationModel = new SystemRoleTranslations();
    }

    public function index(Request $request)
    {
        $name = $request->input('name');
        $code = $request->input('code');
        $status = $request->input('status');
        // 非超级管理员只能看到自己管理的角色
        $adminIds = $this->getDataLimitAdminIds();
        $list = $this->model->with(['translations'])->where(function ($query) use ($adminIds, $name, $code, $status) {
            if ($name) {
                $query->where('name', 'like', '%' . $name . '%');
            }
            if ($code) {
                $query->where('code', 'like', '%' . $code . '%');
            }
            if ($status) {
                $query->where('status', $status);
            }
            if (!empty($adminIds)) {
                $query->whereIn('admin_id', $adminIds);
            }
        })->get()->toArray();
        $tree = new Tree();
        $list = $this->renderTranslations($list);
        $list = $tree->makeTree($list);
        return $this->success(trans('condoradmin.ok'), $list);
    }

    public function selectpage(Request $request)
    {
        $is_tree = $request->input('is_tree', 1);
        // 非超级管理员只能看到自己管理的角色
        $adminIds = $this->getDataLimitAdminIds();
        $list = $this->model->with(['translations'])->where('status', 1)
            ->where(function ($query) use ($adminIds) {
                if (!empty($adminIds)) {
                    $query->whereIn('admin_id', $adminIds);
                }
            })->get(['id', 'pid'])->toArray();
        $list = $this->renderTranslations($list);
        if ($is_tree) {
            $tree = new Tree();
            $list = $tree->makeTree($list);
        }
        return $this->success(trans('condoradmin.ok'), $list);
    }

    public function add(Request $request)
    {
        // rules 判断在自己权限范围内
        $rules = $request->input('rules');
        if ($rules != null) {
            $rules = $this->auth->filterRule($rules);
            $request->setPost('rules', is_array($rules) ? implode(',', $rules) : $rules);
        }
        return parent::add($request);
    }

    public function edit(Request $request)
    {
        // rules 判断在自己权限范围内
        $rules = $request->input('rules');
        if ($rules != null) {
            $rules = $this->auth->filterRule($rules);
            $request->setPost('rules', is_array($rules) ? implode(',', $rules) : $rules);
        }
        return parent::edit($request);
    }
}
