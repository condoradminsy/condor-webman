<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemAdmin;
use support\Log;
use support\Exception;
use support\Db;
use Respect\Validation\Validator;

class AdminController extends Backend
{

    // 搜索白名单
    protected array $searchable = [
        'username' => ['type' => 'string'],
        'nickname' => ['type' => 'string'],
        'email' => ['type' => 'string'],
        'mobile' => ['type' => 'string'],
        'createtime' => ['type' => 'array'],
        'status' => ['type' => 'int'],
    ];

    // 模型关联
    protected array $with = ['RoleGroup:id,uid,role_id'];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemAdmin();
    }

    /**
     * 查看
     *
     * @return string|Json
     * @throws Exception
     * @throws DbException
     */
    public function index(Request $request)
    {
        try {
            //设置过滤方法
            [$where, $sort, $order, $offset, $limit] = $this->buildparams($request);
            $query = null;
            if ($this->alias) {
                $tableName = $this->model->getTable();
                $this->model->setTable("{$tableName} as {$this->alias}");
            }
            //字段处理
            $selectFields = $this->selectFields;
            if ($this->alias && $selectFields === '*') {
                $selectFields = $this->alias . '.' . $selectFields;
            }
            $query = $this->model->select($selectFields);
            // 关联查询
            if (!empty($this->with)) {
                $query = $query->with($this->with);
            }
            $query->where($where);

            $total = (clone $query)->count();

            $list = $query
                ->orderBy($order, $sort)
                ->offset($offset)
                ->limit($limit)
                ->get()
                ->toArray();

            foreach ($list as &$item) {
                if (!empty($item['role_group'])) {
                    $item['role_ids'] = array_column($item['role_group'], 'role_id');
                } else {
                    $item['role_ids'] = [];
                }
                $item['password'] = '';
                unset($item['role_group']);
            }

            return $this->success(trans('ok'), [
                'total' => $total,
                'list' => $list
            ]);
        } catch (\Exception $e) {
            Log::error('index', ['error' => $e->getMessage()]);
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('Server error'));
        }
    }

    /**
     * 添加
     *
     * @return string
     * @throws Exception
     */
    public function add(Request $request)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans('Request method incorrect'));
        }
        $params = $request->post();
        if (empty($params)) {
            return $this->fail('Parameter can not be empty');
        }
        $role_ids = $params['role_ids'] ?? [];
        $role_ids = is_array($role_ids) ? $role_ids : explode(',', $role_ids);
        try {
            Db::beginTransaction();
            //是否采用模型验证
            if ($this->modelValidate && method_exists($this->model, 'rules')) {
                $data = Validator::input($params, $this->model->rules());
            } else {
                $data = $params;
            }
            if ($this->dataLimit) {
                $data[$this->dataLimitField] = $this->auth->id;
            }
            if ($this->createdByField) {
                $data[$this->createdByField] = $this->auth->id;
            }
            $data = $this->preExcludeFields($data);
            if (!empty($data['password'])) {
                $data['password'] = getEnctyptPassword(trim($data['password']));
            } else {
                unset($data['password']);
            }
            $row = $this->model->create($data);
            Db::commit();
            if (!$row) {
                return $this->fail(trans('No rows were inserted'));
            }
        } catch (\Throwable $e) {
            Db::rollBack();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('Add error'));
        }
        //  成功
        if (!$this->auth->isSuperAdmin()) {
            $roleGroupIds = $this->auth->getChildrenGroupIds();
            $role_ids = array_intersect($role_ids, $roleGroupIds);
        }
        $roleService = new \plugin\condoradmin\app\service\SystemRole();
        $roleService->addRole($row->getKey(), $role_ids);
        return $this->success(trans('ok'), ['id' => $row->getKey()]);
    }

    /**
     * 编辑
     *
     * @param $ids
     * @return string
     * @throws Exception
     */
    public function edit(Request $request)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans('Request method incorrect'));
        }
        $id = $request->post('id');
        if (empty($id)) {
            return $this->fail('参数不能为空');
        }
        $row = $this->model->find($id);
        if (empty($row)) {
            return $this->fail(trans('No Results were found'));
        }
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && !in_array($row[$this->dataLimitField], $adminIds)) {
                return $this->fail(trans('You have no permission'));
            }
        }
        $params = $request->post();
        if (empty($params)) {
            return $this->fail(trans('Parameter can not be empty'));
        }
        $role_ids = $params['role_ids'] ?? [];
        $role_ids = is_array($role_ids) ? $role_ids : explode(',', $role_ids);
        try {
            Db::beginTransaction();
            //是否采用模型验证
            if ($this->modelValidate && method_exists($this->model, 'rules')) {
                $data = Validator::input($params, $this->model->rules());
            } else {
                $data = $params;
            }
            $data = $this->preExcludeFields($data);
            if ($this->updatedByField) {
                $data[$this->updatedByField] = $this->auth->id;
            }
            if (!empty($data['password'])) {
                $data['password'] = getEnctyptPassword(trim($data['password']));
            } else {
                unset($data['password']);
            }
            $result = $row->forceFill($data)->save();
            Db::commit();
            if (false === $result) {
                return $this->fail(trans('No rows were updated'));
            }
        } catch (\Throwable $e) {
            Db::rollback();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('Edit error'));
        }
        //  成功
        if (!$this->auth->isSuperAdmin()) {
            $roleGroupIds = $this->auth->getChildrenGroupIds();
            $role_ids = array_intersect($role_ids, $roleGroupIds);
        }
        $roleService = new \plugin\condoradmin\app\service\SystemRole();
        $roleService->addRole($id, $role_ids);
        return $this->success(trans('ok'), ['id' => $id]);
    }
}
