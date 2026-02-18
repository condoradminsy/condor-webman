<?php

namespace plugin\condoradmin\app\library;

use support\Response;
use support\Context;
use support\Request;
use support\Log;
use support\Db;
use Respect\Validation\Validator;
use Respect\Validation\Exceptions\ValidationException;

class Backend
{

    public function __construct()
    {
        $this->auth = Context::get('auth');
    }

    /**
     * 无需登录的方法,同时也就不需要鉴权了
     * @var array
     */
    protected $noNeedLogin = [];

    /**
     * 无需鉴权的方法,但需要登录
     * @var array
     */
    protected $noNeedRight = [];

    /**
     * @var Model
     */
    protected $model = null;


    /**
     * 获取当前登录用户信息
     */
    protected $auth = null;


    /**
     * 是否开启数据权限限制
     * 支持 auth/personal
     */
    protected $dataLimit = false;


    /**
     * 数据权限字段
     */
    protected $dataLimitField = 'admin_id';


    /**
     * 创建数据时自动填充字段
     */
    protected $createdByField = '';

    /**
     * 更新数据时自动填充字段
     */
    protected $updatedByField = '';

    /**
     * 批量操作字段
     */
    protected array|string $multiFields = ['status'];

    /**
     * 别名
     */
    protected $alias = '';


    /**
     * 排除搜索字段
     */
    protected $excludeSearchFields = [];


    /**
     * 排除搜索值
     */
    protected $excludeSearchValues = [];


    /**
     * 是否自动填充数据限制字段
     */
    protected $modelValidate = true;

    /**
     * 关联模型
     */
    protected array $with = [];

    /**
     * Selectpage的字段
     */
    protected $selectpageFields = '*';

    /** 
     * Selectpage的字段
     */
    protected $selectpageKey = 'id';

    /**
     * 查询字段
     */
    protected $selectFields = '*';

    /**
     * 搜索白名单
     */
    protected array $searchable = [];

    /**
     * 添加/编辑时排除字段
     */
    protected $excludeFields = [];

    /**
     * join关联key
     */
    protected array $joined = [];

    /**
     * 返回格式化json数据
     *
     * @param int $code
     * @param string $msg
     * @param array $data
     * @return Response
     */
    protected function json(string | int $code, string $msg = 'ok', $data = []): Response
    {
        return json(['code' => $code, 'data' => $data, 'msg' => $msg]);
    }

    /**
     * 返回成功数据
     */
    protected function success(string $msg = 'Success', $data = []): Response
    {
        return $this->json('0000', $msg, $data);
    }

    /**
     * 返回失败数据
     */
    protected function fail(string $msg = 'Fail', $data = []): Response
    {
        return $this->json(4000, $msg, $data);
    }

    /**
     * 验证字段名是否安全
     */
    protected function isValidFieldName(string $field): bool
    {
        // 允许字母、数字、下划线、连字符和点（用于表别名）
        return preg_match('/^[a-zA-Z0-9_\-\.]+$/', $field) === 1;
    }

    /**
     * 判断操作符是否合法
     */
    protected function isOperator(string $operator): bool
    {
        return in_array(strtoupper($operator), ['=', '!=', '<>', '>', '<', '>=', '<=', 'IN', 'NOT IN', 'LIKE', 'NOT LIKE', 'BETWEEN', 'NOT BETWEEN', 'NULL', 'NOT NULL', 'IS NULL', 'IS NOT NULL', 'FIND_IN_SET', 'FINDINSET', 'FINDIN']);
    }

    /**
     * 添加/编辑时排除不需要的字段
     */
    protected function preExcludeFields(array $data): array
    {
        if (is_array($this->excludeFields) && !empty($this->excludeFields)) {
            $data = array_diff_key($data, array_flip($this->excludeFields));
        } else if (is_string($this->excludeFields) && !empty($this->excludeFields)) {
            $data = array_diff_key($data, array_flip(explode(',', $this->excludeFields)));
        }
        return $data;
    }

    /**
     * 构建排序参数
     */
    protected function buildOrder(Request $request): array
    {
        $defaultOrder = 'id';
        if (!empty($this->model) && method_exists($this->model, 'getKeyName')) {
            $defaultOrder = $this->model->getKeyName() ?: 'id';
        }
        if ($this->alias) {
            $defaultOrder = $this->alias . '.' . $defaultOrder;
        }
        return [
            'orderBy' => $request->post("orderBy", $defaultOrder),
            'order' => in_array(strtolower($request->post("order", 'desc')), ['asc', 'desc'])
                ? strtolower($request->post("order", 'desc'))
                : 'desc'
        ];
    }

    /**
     * 处理查询参数，排除不需要的字段
     */
    protected function processParams(Request $request): array
    {
        $params = $request->except(['page', 'limit', 'order', 'orderBy']);

        // 排除与 excludeSearchValues 值相同的字段
        if (is_array($this->excludeSearchValues) && !empty($this->excludeSearchValues)) {
            $params = array_filter($params, function ($value, $key) {
                return !isset($this->excludeSearchValues[$key]) ||
                    $this->excludeSearchValues[$key] !== $value;
            }, ARRAY_FILTER_USE_BOTH);
        }
        // 排除指定的字段
        if (is_array($this->excludeSearchFields) && !empty($this->excludeSearchFields)) {
            $params = array_diff_key($params, array_flip($this->excludeSearchFields));
        }
        return $params;
    }


    /**
     * 格式化查询值
     */
    protected function formatValue($value, $type, &$operator = null)
    {
        if (is_string($value)) {
            $value = trim($value);
            if (in_array(strtoupper($value), ['NULL', 'NOT NULL'])) {
                $operator = strtoupper($value);
                $value = '';
            } else if (in_array($value, ['""', "''"])) {
                $value = '';
            }
            if ($type === 'int') {
                $value = (int)$value;
            }
        } else {
            $value = (int)$value;
        }
        return $value;
    }

    /**
     * 构建查询条件
     */
    protected function buildCondition($value, $config): ?array
    {
        $operator = '=';
        $type = $config['type'] ?? 'string';
        if (!is_array($value)) {
            $value = $this->formatValue($value, $type, $operator);
            return [$operator, $value];
        }
        $len = count($value);
        if ($len === 1) {
            $operator = '=';
            $value = $this->formatValue($value[0], $type);
            return [$operator, $value];
        }
        // 第一个参数是操作符
        if ($this->isOperator($value[0])) {
            $operator = $value[0];
            if (is_array($value[1])) {
                if (count($value[1]) === 2 && strtoupper($operator) === 'BETWEEN' && $type === 'timestamp') {
                    $value = [
                        strtotime($value[1][0] . ' 00:00:00'),
                        strtotime($value[1][1] . ' 23:59:59'),
                    ];
                } else {
                    $value = array_map(function ($v) use ($type) {
                        return $this->formatValue($v, $type);
                    }, $value[1]);
                }
            } else {
                $value = $this->formatValue($value[1], $type);
            }
        } else {
            $operator = 'BETWEEN';
            // 时间戳
            if ($type === 'timestamp') {
                $value = [
                    strtotime($value[0] . ' 00:00:00'),
                    strtotime($value[1] . ' 23:59:59'),
                ];
            } else {
                $value = array_map(function ($v) use ($type) {
                    return $this->formatValue($v, $type);
                }, $value);
            }
        }
        return [strtoupper($operator), $value];
    }

    /**
     * 获取数据限制的管理员ID
     * 禁用数据限制时返回的是null
     * @return mixed
     */
    protected function getDataLimitAdminIds()
    {
        $dataLimit = $this->dataLimit;
        if ($dataLimit === false) {
            return [];
        }
        if ($this->auth->isSuperAdmin()) {
            return [];
        }
        $adminIds = [];
        if (in_array($dataLimit, ['auth', 'personal'])) {
            $adminIds = $dataLimit == 'auth' ? $this->auth->getChildrenAdminIds(true) : [$this->auth->id];
        }
        return $adminIds;
    }

    /**
     * 生成join条件key
     * @param $join
     * @return string
     */
    protected function joinKey(array $join): string
    {
        return md5(json_encode([
            'type' => $join['type'] ?? 'left',
            'table' => $join['table'] ?? '',
            'alias' => $join['alias'] ?? '',
            'on' => $join['on'] ?? [],
        ]));
    }

    /**
     * 添加join条件
     * @param $query
     * @param $join
     */
    protected function applyJoinOnce($query, $join)
    {
        $fields = $join['fields'] ?? [];
        $type = strtolower($join['type'] ?? 'left');
        $key = $this->joinKey($join);
        $table = $join['table'] ?? '';
        if (isset($this->joined[$key]) || !$table) {
            return;
        }
        $method = match ($type) {
            'right' => 'rightJoin',
            'inner' => 'join',
            default => 'leftJoin',
        };
        $alias = $join['alias'] ?? null;
        // 联表字段
        if (!empty($fields)) {
            $query->addSelect($fields);
        }
        // 如果别名存在，则使用别名，否则使用表名
        $joinedTables = $alias ? "{$table} as {$alias}" : $table;
        $query->{$method}($joinedTables, function ($joinQuery) use ($join) {
            foreach ($join['on'] as $cond) {
                [$left, $op, $right] = $cond;
                $joinQuery->on($left, $op, $right);
            }
        });
        $this->joined[$key] = true;
    }

    /**
     * 构建查询条件
     * @param $query
     * @param $params
     * @return mixed
     */
    protected function buildWhere($query, $field, $operator, $value)
    {
        switch ($operator) {
            case '=':
            case '<>':
            case '!=':
            case '>':
            case '>=':
            case '<':
            case '<=':
                $query->where($field, $operator, $value);
                break;
            case 'LIKE':
            case 'NOT LIKE':
                $query->where($field, $operator, "%{$value}%");
                break;
            case 'FINDIN':
            case 'FINDINSET':
            case 'FIND_IN_SET':
            case 'IN':
            case 'NOT IN':
                if ($operator == 'IN') {
                    $query->whereIn($field, $value);
                } else if ($operator == 'NOT IN') {
                    $query->whereNotIn($field, $value);
                } else if (isset($value[0]) && $value[0] != '') {
                    $query->whereRaw("FIND_IN_SET(?, `{$field}`)", $value);
                }
                break;
            case 'BETWEEN':
                $query->whereBetween($field, $value);
                break;
            case 'NOT BETWEEN':
                $query->whereNotBetween($field, $value);
                break;
            case 'NULL':
            case 'IS NULL':
                $query->whereNull($field);
                break;
            case 'NOT NULL':
            case 'IS NOT NULL':
                $query->whereNotNull($field);
                break;
            default:
                break;
        }
    }

    /**
     * 生成查询所需要的条件,排序方式
     * @return array
     */
    protected function buildparams(Request $request)
    {
        $page = (int)$request->post("page", 1);
        $limit = (int)$request->post("limit", 10);
        // 确保页码>=1
        $page = max(1, $page);
        // 限制每页数量在1-500之间
        $limit = max(1, min(500, $limit));
        // 构建排序参数
        $orderData = $this->buildOrder($request);
        $order = $orderData['orderBy'];
        $sort = $orderData['order'];
        // 处理查询参数
        $params = $this->processParams($request);
        return [$params, $sort, $order, ($page - 1) * $limit, $limit];
    }

    /**
     * @ 查询参数处理
     * @param [type] $query
     * @param [type] $request
     * @return void
     */
    protected function applyWhere($query, $params)
    {
        // 构建查询条件闭包
        foreach ($params as $key => $value) {
            // 字段名安全校验
            if (!isset($this->searchable[$key]) || !$this->isValidFieldName($key) || $value === '') {
                continue;
            }
            $config = $this->searchable[$key];
            [$sym, $v] = $this->buildCondition($value, $config);
            // 释放内存
            unset($value);
            $field = $config['as'] ?? $key;
            // 关联表
            if (isset($config['relation']) && $config['relation'] != '') {
                $query->whereHas($config['relation'], function ($q) use ($field, $sym, $v) {
                    $this->buildWhere($q, $field, $sym, $v);
                });
                continue;
            }
            // join字段
            if (isset($config['join']) && $config['join'] != '') {
                $this->applyJoinOnce($query, $config['join']);
                $this->buildWhere($query, $field, $sym, $v);
                continue;
            }
            // 主表字段
            $this->buildWhere($query, $field, $sym, $v);
        }
        // 处理数据权限
        $childrenAdminIds = $this->getDataLimitAdminIds();
        $dataLimitField = $this->dataLimitField;
        if (!empty($childrenAdminIds) && !empty($dataLimitField)) {
            $query->whereIn($dataLimitField, $childrenAdminIds);
        }
    }


    /**
     * Selectpage的实现方法
     */
    public function selectpage(Request $request)
    {
        try {
            //设置过滤方法
            [$params, $sort, $order, $offset, $limit] = $this->buildparams($request);
            // 获取传入的id参数
            $selectpageKey = $this->selectpageKey ?: 'id';
            $ids = $request->input($selectpageKey, '');
            $idArray = [];
            if ($ids) {
                $idArray = is_array($ids) ? $ids : explode(',', $ids);
            }
            if ($this->alias) {
                $tableName = $this->model->getTable();
                $this->model->setTable("{$tableName} as {$this->alias}");
            }
            // 字段处理
            $selectpageFields = $this->selectpageFields;
            if ($this->alias && $selectpageFields === '*') {
                $selectpageFields = $this->alias . '.' . $selectpageFields;
            }
            // 构建主查询
            $query = $this->model->select($selectpageFields);

            // 如果有id参数，使用UNION ALL
            if (!empty($idArray)) {
                // 查询id对应的数据
                $idQuery = $this->model->clone()
                    ->select($selectpageFields)
                    ->addSelect(DB::raw('1 as is_special'))
                    ->whereIn($this->alias ? "{$this->alias}.{$selectpageKey}" : $selectpageKey, $idArray);
                // 查询其他数据
                $otherQuery = $this->model->clone()
                    ->select($selectpageFields)
                    ->addSelect(DB::raw('2 as is_special'))
                    ->whereNotIn($this->alias ? "{$this->alias}.{$selectpageKey}" : $selectpageKey, $idArray);
                // 构建查询条件
                $this->applyWhere($otherQuery, $params);
                // 使用UNION ALL合并
                $query = $idQuery->unionAll($otherQuery);
                // 使用子查询进行分页
                $subQuery = DB::table(DB::raw("({$query->toSql()}) as sub"))
                    ->mergeBindings($query->getQuery());
                // 获取总数
                $countQuery = DB::table(DB::raw("({$query->toSql()}) as count_table"))
                    ->mergeBindings($query->getQuery());
                $total = $countQuery->count();
                // 获取分页数据
                $list = $subQuery->orderBy('is_special', 'asc')
                    ->orderBy($order, $sort)
                    ->offset($offset)
                    ->limit($limit)
                    ->get();
                // 处理数据
                $list = $list->map(function ($item) {
                    unset($item->is_special);
                    return $item;
                });
            } else {
                // 没有id参数，普通查询
                $this->applyWhere($query, $params);
                $total = $query->count();
                $list = $query->orderBy($order, $sort)
                    ->offset($offset)
                    ->limit($limit)
                    ->get();
            }
            return $this->success(trans('condoradmin.ok'), [
                'total' => $total,
                'list' => $list->toArray()
            ]);
        } catch (\Exception $e) {
            Log::error('selectpage', ['error' => $e->getMessage()]);
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.system.error'));
        }
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
            [$params, $sort, $order, $offset, $limit] = $this->buildparams($request);
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
            $this->applyWhere($query, $params);

            $total = (clone $query)->count();

            $list = $query
                ->orderBy($order, $sort)
                ->offset($offset)
                ->limit($limit)
                ->get();

            return $this->success(trans('condoradmin.ok'), [
                'total' => $total,
                'list' => $list->toArray()
            ]);
        } catch (\Exception $e) {
            Log::error('index', ['error' => $e->getMessage()]);
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.system.error'));
        }
    }

    /**
     * 回收站
     *
     * @return string|Json
     * @throws Exception
     */
    public function recyclebin(Request $request)
    {
        //设置过滤方法
        if (false === $request->isAjax()) {
            return $this->fail(trans('condoradmin.request.method.incorrect'));
        }
        try {
            [$params, $sort, $order, $offset, $limit] = $this->buildparams($request);
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
            $this->applyWhere($query, $params);
            $total = $query->count();
            $list = $this->model
                ->orderBy($sort, $order)
                ->offset($offset)
                ->limit($limit)
                ->get();

            return $this->success(trans('condoradmin.ok'), ['total' => $total, 'rows' => $list]);
        } catch (\Exception $e) {
            Log::error('recyclebin', ['error' => $e->getMessage()]);
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.system.error'));
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
            return $this->fail(trans('condoradmin.request.method.incorrect'));
        }
        $params = $request->post();
        if (empty($params)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        try {
            //是否采用模型验证
            if ($this->modelValidate && method_exists($this->model, 'rules')) {
                try {
                    $data = Validator::input($params, $this->model->rules());
                } catch (ValidationException $e) {
                    return $this->fail($e->getMessage());
                } catch (\Exception $e) {
                    return $this->fail($e->getMessage());
                }
            } else {
                $data = $params;
            }
            Db::beginTransaction();
            if ($this->dataLimit) {
                $data[$this->dataLimitField] = $this->auth->id;
            }
            if ($this->createdByField) {
                $data[$this->createdByField] = $this->auth->id;
            }
            $data = $this->preExcludeFields($data);
            $row = $this->model->create($data);
            Db::commit();
            if (!$row) {
                return $this->fail(trans('condoradmin.no.rows.were.inserted'));
            }
        } catch (\Throwable $e) {
            Db::rollBack();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.system.error'));
        }
        return $this->success(trans('condoradmin.ok'), ['id' => $row->getKey()]);
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
            return $this->fail(trans('condoradmin.request.method.incorrect'));
        }
        $id = $request->post('id');
        if (empty($id)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        $row = $this->model->find($id);
        if (empty($row)) {
            return $this->fail(trans('condoradmin.no.results.were.found'));
        }
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && !in_array($row[$this->dataLimitField], $adminIds)) {
                return $this->fail(trans('condoradmin.you.have.no.permission'));
            }
        }
        $params = $request->post();
        if (empty($params)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        try {
            //是否采用模型验证
            if ($this->modelValidate && method_exists($this->model, 'rules')) {
                try {
                    $data = Validator::input($params, $this->model->rules());
                } catch (ValidationException $e) {
                    return $this->fail($e->getMessage());
                } catch (\Exception $e) {
                    return $this->fail($e->getMessage());
                }
            } else {
                $data = $params;
            }
            Db::beginTransaction();
            $data = $this->preExcludeFields($data);
            if ($this->updatedByField) {
                $data[$this->updatedByField] = $this->auth->id;
            }
            $result = $row->forceFill($data)->save();
            Db::commit();
            if (false === $result) {
                return $this->fail(trans('condoradmin.no.rows.were.updated'));
            }
        } catch (\Throwable $e) {
            Db::rollback();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.system.error'));
        }
        return $this->success(trans('condoradmin.ok'), ['id' => $id]);
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
        $query = $this->model->whereIn($pk, $ids);
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

    /**
     * 真实删除
     *
     * @param $ids
     * @return void
     */
    public function destroy(Request $request)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans("condoradmin.invalid.parameters"));
        }
        $ids = $request->post('ids') ?: $request->post('id');
        if (empty($ids)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        if (!is_array($ids)) {
            // 是否有,号
            if (strpos($ids, ',') !== false) {
                $ids = explode(',', $ids);
            } else {
                $ids = [$ids];
            }
        }
        $pk = $this->model->getKeyName();
        $query = $this->model->whereIn($pk, $ids);
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && is_array($adminIds)) {
                $query->whereIn($this->dataLimitField, $adminIds);
            }
        }
        $count = 0;
        Db::beginTransaction();
        try {
            $list = $query->get();
            foreach ($list as $item) {
                $count += $item->forceDelete();
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

    /**
     * 还原
     *
     * @param $ids
     * @return void
     */
    public function restore(Request $request, $ids = null)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans('condoradmin.invalid.parameters'));
        }
        $ids = $request->post('ids') ?: $request->post('id');
        if (empty($ids)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        if (!is_array($ids)) {
            // 是否有,号
            if (strpos($ids, ',') !== false) {
                $ids = explode(',', $ids);
            } else {
                $ids = [$ids];
            }
        }
        $pk = $this->model->getKeyName();
        $query = $this->model->whereIn($pk, $ids);
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && is_array($adminIds)) {
                $query->whereIn($this->dataLimitField, $adminIds);
            }
        }
        $count = 0;
        Db::beginTransaction();
        try {
            $list = $query->onlyTrashed()->get();
            foreach ($list as $item) {
                $count += $item->restore();
            }
            Db::commit();
        } catch (\Throwable $e) {
            Db::rollback();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.restore.failed'));
        }
        if ($count) {
            return $this->success();
        }
        return $this->fail(trans('condoradmin.no.rows.were.updated'));
    }

    /**
     * 批量更新
     *
     * @param $ids
     * @return void
     */
    public function multi(Request $request)
    {
        if (false === $request->isPost()) {
            return $this->fail(trans('condoradmin.invalid.parameters'));
        }
        $ids = $request->post('ids') ?: $request->post('id');
        if (empty($ids)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        if (!is_array($ids)) {
            // 是否有,号
            if (strpos($ids, ',') !== false) {
                $ids = explode(',', $ids);
            } else {
                $ids = [$ids];
            }
        }
        $value = $request->post('value');
        $field = $request->post('field');
        $values = $request->post('values');
        if (!empty($field)) {
            $values = [$field => $value];
        } elseif (empty($values)) {
            return $this->fail(trans('condoradmin.parameter.can.not.be.empty'));
        }
        if (!is_array($values)) {
            return $this->fail(trans('condoradmin.parameter.type.error'));
        }
        $values = $this->auth->isSuperAdmin() ? $values : array_intersect_key($values, array_flip(is_array($this->multiFields) ? $this->multiFields : explode(',', $this->multiFields)));
        if (empty($values)) {
            return $this->fail(trans('condoradmin.you.have.no.permission'));
        }
        $query = $this->model->whereIn($this->model->getKeyName(), $ids);
        if ($this->dataLimit && $this->dataLimitField !== '') {
            $adminIds = $this->getDataLimitAdminIds();
            if (!empty($adminIds) && is_array($adminIds)) {
                $query->whereIn($this->dataLimitField, $adminIds);
            }
        }
        $count = 0;
        try {
            Db::beginTransaction();
            $list = $query->get();
            foreach ($list as $item) {
                foreach ($values as $k => $v) {
                    $item->$k = is_array($v) ? json_encode($v, JSON_UNESCAPED_UNICODE) : $v;
                }
                $count += $item->save();
            }
            Db::commit();
        } catch (\Throwable $e) {
            Db::rollback();
            return $this->fail(config('app.debug') ? $e->getMessage() : trans('condoradmin.update.failed'));
        }
        if ($count) {
            return $this->success(trans('condoradmin.ok'));
        }
        return $this->fail(trans('condoradmin.no.rows.were.updated'));
    }
}
