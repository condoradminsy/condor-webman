<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemMenuRule;
use plugin\condoradmin\app\library\Tree;

class MenuController extends Backend
{

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemMenuRule();
    }

    public function index(Request $request)
    {
        $menu_type = $request->input('menu_type');
        $status = $request->input('status');
        // 读取用户规则节点
        $ids = $this->auth->getRuleIds();
        if (empty($ids)) {
            return [];
        }
        //读取用户组所有权限规则
        $rules = $this->model
            ->where(function ($query) use ($menu_type, $ids, $status) {
                if ($status) {
                    $query->where('status', $status);
                }
                if (!in_array('*', $ids)) {
                    $query->whereIn('id', $ids);
                }
                if (is_array($menu_type) && !empty($menu_type)) {
                    $query->whereIn('menu_type', $menu_type);
                } else if (is_numeric($menu_type)) {
                    $query->where('menu_type', $menu_type);
                }
            })
            ->select('*')
            ->orderBy('weigh', 'ASC')
            ->get()
            ->toArray();
        $tree = new Tree();;
        return $this->success('success', $tree->makeTree($rules));
    }

    public function selectpage(Request $request)
    {
        $is_tree = $request->input('is_tree', 1);
        // 读取用户规则节点
        $ids = $this->auth->getRuleIds();
        if (empty($ids)) {
            return [];
        }
        $list = $this->model->where('status', 1)->where(function ($query) use ($ids) {
            if (!in_array('*', $ids)) {
                $query->whereIn('id', $ids);
            }
        })->get(['id', 'title', 'pid'])->toArray();
        if ($is_tree) {
            $tree = new Tree();
            $list = $tree->makeTree($list);
        }
        return $this->success(trans('ok'), $list);
    }
}
