<?php

namespace plugin\condoradmin\app\library;

use support\Request;
use support\Log;
use support\Db;
use Respect\Validation\Validator;
use Respect\Validation\Exceptions\ValidationException;

class TranslatableBackend extends Backend
{

    /**
     * 翻译关联方法
     * @var string
     */
    protected $translationForeignMethod = 'translations';

    /**
     * 翻译表外键字段
     * @var string
     */
    protected $translationForeignKey = 'main_id';

    /**
     * 翻译表主键字段
     * @var string
     */
    protected $translationLocaleKey = 'locale';

    /**
     * 支持的语言列表
     * @var array
     */
    protected $supportedLocales = ['zh-cn', 'en-us'];


    /**
     * 多语言字段映射
     * @var array
     */
    protected array $multilingualFields = [];

    /**
     * 翻译模型
     */
    protected $translationModel = null;


    public function __construct()
    {
        parent::__construct();
        // 设置多语言
        $this->supportedLocales = array_column(config('plugin.condoradmin.translation.languages'), 'key');
        // 设置多语言字段
        if (empty($this->translationLocaleKey)) {
            return $this->fail(trans('condoradmin.system.translation_locale_key_empty'));
        }
        // 设置翻译关联主键字段
        if (empty($this->translationForeignKey)) {
            return $this->fail(trans('condoradmin.system.translation_foreign_key_empty'));
        }
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
            // 语言字段
            if (in_array($field, $this->multilingualFields)) {
                $query->whereHas($this->translationForeignMethod, function ($q) use ($field, $sym, $v) {
                    $this->buildWhere($q, $field, $sym, $v);
                });
                continue;
            }
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
     * 提取多语言数据
     * @param array $data
     * @return array [masterData, translations]
     */
    protected function extractMultilingualData(array $data): array
    {
        $masterData = [];
        $translations = [];
        foreach ($data as $key => $value) {
            if (in_array($key, $this->multilingualFields)) {
                // 如果是多语言字段，则提取翻译数据
                foreach ($this->supportedLocales as $locale) {
                    // 是否移除空的翻译，暂不处理
                    $translations[$locale][$key] = $value[$locale] ?? '';
                }
            } else {
                // 如果不是多语言字段，则为主表字段
                $masterData[$key] = $value;
            }
        }
        return [$masterData, $translations];
    }

    /**
     * 渲染多语言数据
     * @param array $list
     * @return array
     */
    protected function renderTranslations($list)
    {
        if (empty($list)) {
            return $list;
        }
        if (!is_array($list)) {
            $list = $list->toArray();
        }
        // 多语言字段处理
        foreach ($list as &$item) {
            foreach ($this->multilingualFields as $field) {
                $rows = $item[$this->translationForeignMethod];
                $item[$field] =  [];
                foreach ($rows as $row) {
                    $item[$field][$row[$this->translationLocaleKey]] = $row[$field] ?? '';
                }
                if (empty($item[$field])) {
                    $item[$field] =  null;
                }
            }
            // 隐藏字段
            if (!empty($this->hidden)) {
                foreach ($this->hidden as $field) {
                    unset($item[$field]);
                }
            }
            unset($item[$this->translationForeignMethod]);
        }
        unset($item);
        return $list;
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
            $translateWithStr = '';
            if (!empty($this->translationForeignMethod)) {
                $translateWithStr = $this->translationForeignMethod . ':' . $this->translationLocaleKey . ',' . $this->translationForeignKey;
                if (!empty($this->multilingualFields)) {
                    $translateWithStr .= ',' . implode(',', $this->multilingualFields);
                }
            }
            // 关联查询
            if (!empty($this->with)) {
                if (!empty($translateWithStr)) {
                    $query = $query->with(array_merge($this->with, [$translateWithStr]));
                } else {
                    $query = $query->with($this->with);
                }
            } else {
                if (!empty($translateWithStr)) {
                    $query = $query->with($translateWithStr);
                }
            }
            // 如果有id参数，使用UNION ALL
            if (!empty($idArray)) {
                // 查询id对应的数据
                $idQuery = $this->model->clone()
                    ->select($selectpageFields)
                    ->addSelect(DB::raw('1 as condor_is_special'))
                    ->whereIn($this->alias ? "{$this->alias}.{$selectpageKey}" : $selectpageKey, $idArray);
                // 查询其他数据
                $otherQuery = $this->model->clone()
                    ->select($selectpageFields)
                    ->addSelect(DB::raw('2 as condor_is_special'))
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
                $list = $subQuery->orderBy('condor_is_special', 'asc')
                    ->orderBy($order, $sort)
                    ->offset($offset)
                    ->limit($limit)
                    ->get()
                    ->toArray();
            } else {
                // 没有id参数，普通查询
                $this->applyWhere($query, $params);
                $total = $query->count();
                $list = $query->orderBy($order, $sort)
                    ->offset($offset)
                    ->limit($limit)
                    ->get()
                    ->toArray();
            }
            // 多语言字段处理
            foreach ($list as &$item) {
                foreach ($this->multilingualFields as $field) {
                    $rows = $item[$this->translationForeignMethod];
                    $item[$field] = [];
                    foreach ($rows as $row) {
                        $item[$field][$row[$this->translationLocaleKey]] = $row[$field] ?? '';
                    }
                }
                if (isset($item['condor_is_special'])) {
                    unset($item['condor_is_special']);
                }
                unset($item[$this->translationForeignMethod]);
            }
            return $this->success(trans('condoradmin.ok'), [
                'total' => $total,
                'list' => $list
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

            $translateWithStr = '';
            if (!empty($this->translationForeignMethod)) {
                $translateWithStr = $this->translationForeignMethod . ':' . $this->translationLocaleKey . ',' . $this->translationForeignKey;
                if (!empty($this->multilingualFields)) {
                    $translateWithStr .= ',' . implode(',', $this->multilingualFields);
                }
            }
            // 关联查询
            if (!empty($this->with)) {
                if (!empty($translateWithStr)) {
                    $query = $query->with(array_merge($this->with, [$translateWithStr]));
                } else {
                    $query = $query->with($this->with);
                }
            } else {
                if (!empty($translateWithStr)) {
                    $query = $query->with($translateWithStr);
                }
            }
            $this->applyWhere($query, $params);

            $total = (clone $query)->count();

            $list = $query
                ->orderBy($order, $sort)
                ->offset($offset)
                ->limit($limit)
                ->get()
                ->toArray();

            return $this->success(trans('condoradmin.ok'), [
                'total' => $total,
                'list' => $this->renderTranslations($list)
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
            // 提取多语言数据
            [$masterData, $translations] = $this->extractMultilingualData($params);
            $fields = array_keys($masterData);
            //是否采用模型验证
            if ($this->modelValidate) {
                // 主表模型验证
                $error_lang = '';
                try {
                    if (method_exists($this->model, 'rules')) {
                        $masterData = Validator::input($masterData, $this->model->rules());
                        $masterData = array_intersect_key($masterData, array_flip($fields));
                    }
                    // 翻译模型验证
                    if (method_exists($this->translationModel, 'rules')) {
                        foreach ($translations as $locale => $translation) {
                            $error_lang = "【{$locale}】";
                            $translations[$locale] = Validator::input($translation, $this->translationModel->rules());
                        }
                    }
                } catch (ValidationException $e) {
                    return $this->fail($error_lang . $e->getMessage());
                } catch (\Exception $e) {
                    return $this->fail($error_lang . $e->getMessage());
                }
            }
            // 保存数据
            Db::beginTransaction();
            if ($this->dataLimit) {
                $masterData[$this->dataLimitField] = $this->auth->id;
            }
            if ($this->createdByField) {
                $masterData[$this->createdByField] = $this->auth->id;
            }
            $masterData = $this->preExcludeFields($masterData);
            $row = $this->model->create($masterData);
            // 多语言字段处理
            foreach ($translations as $locale => $translation) {
                $translation[$this->translationLocaleKey] = $locale;
                $row->translations()->create($translation);
            }
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
            // 提取多语言数据
            [$masterData, $translations] = $this->extractMultilingualData($params);
            $fields = array_keys($masterData);
            //是否采用模型验证
            if ($this->modelValidate) {
                // 主表模型验证
                $error_lang = '';
                try {
                    if (method_exists($this->model, 'rules')) {
                        $masterData = Validator::input($masterData, $this->model->rules());
                        $masterData = array_intersect_key($masterData, array_flip($fields));
                    }
                    // 翻译模型验证
                    if (method_exists($this->translationModel, 'rules')) {
                        foreach ($translations as $locale => $translation) {
                            $error_lang = "【{$locale}】";
                            $translations[$locale] = Validator::input($translation, $this->translationModel->rules());
                        }
                    }
                } catch (ValidationException $e) {
                    return $this->fail($error_lang . $e->getMessage());
                } catch (\Exception $e) {
                    return $this->fail($error_lang . $e->getMessage());
                }
            }
            Db::beginTransaction();
            $masterData = $this->preExcludeFields($masterData);
            if ($this->updatedByField) {
                $masterData[$this->updatedByField] = $this->auth->id;
            }
            $result = $row->forceFill($masterData)->save();
            // 多语言字段处理
            foreach ($translations as $locale => $translation) {
                $row->translations()->updateOrCreate(['locale' => $locale], $translation);
            }
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
                // 多语言处理
                $item->translations()->delete();
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
                // 多语言处理
                $item->translations()->forceDelete();
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
                // 多语言处理
                $item->translations()->restore();
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
