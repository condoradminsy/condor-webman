<?php

namespace plugin\condoradmin\app\controller;

use support\Request;
use plugin\condoradmin\app\library\Backend;
use plugin\condoradmin\app\model\SystemCrudLog;
use Respect\Validation\Validator;
use plugin\condoradmin\app\library\Crud;
use support\Db;

class CrudController extends Backend
{

    protected array $searchable = [];

    public function __construct()
    {
        parent::__construct();
        $this->model = new SystemCrudLog();
    }

    /**
     * 获取数据库表
     * @return void
     */
    public function config()
    {
        $exclude_tables = config('plugin.condoradmin.condor.crud.exclude_tables');
        // 兼容字符串或数组配置
        if (is_string($exclude_tables)) {
            $exclude_tables = array_filter(array_map('trim', explode(',', $exclude_tables)));
        }
        if (!is_array($exclude_tables)) {
            $exclude_tables = [];
        }
        $rows = Db::select('SHOW TABLES');
        $tables = [];
        foreach ($rows as $row) {
            $vals = array_values((array)$row);
            if (isset($vals[0])) {
                $tables[] = $vals[0];
            }
        }
        // 过滤排除表
        $tables = array_values(array_filter($tables, function ($t) use ($exclude_tables) {
            return !in_array($t, $exclude_tables, true);
        }));
        //
        $base_path = base_path();
        $dirArr = ['app', 'plugin'];
        $modules = [];
        // 递归扫描目录，查找名为 controller 的目录并记录相对路径
        $scan = function (string $dirPath) use (&$scan, $base_path, &$modules) {
            $entries = @scandir($dirPath);
            if ($entries === false) return;
            foreach ($entries as $entry) {
                if ($entry === '.' || $entry === '..') continue;
                $full = rtrim($dirPath, '/') . '/' . $entry;
                if (!is_dir($full)) continue;
                if (strtolower($entry) === 'controller') {
                    $rel = ltrim(str_replace($base_path, '', $full), '/\\');
                    $modules[] = str_replace('controller', '', $rel);
                    continue;
                }
                // 继续递归扫描子目录
                $scan($full);
            }
        };
        foreach ($dirArr as $dir) {
            $start = $base_path . '/' . $dir;
            if (!is_dir($start)) continue;
            $scan($start);
        }
        return $this->success('获取成功', [
            'tables' => $tables,
            'prefix' => config('database.connections.mysql.prefix'),
            'modules' => $modules,
        ]);
    }

    // 获取表字段
    public function fields(Request $request)
    {
        $table = $request->input('table');
        if (!$table) {
            return $this->fail('参数错误');
        }
        $sql = "SELECT * FROM `information_schema`.`columns` "
            . "WHERE TABLE_SCHEMA = ? AND table_name = ? "
            . "ORDER BY ORDINAL_POSITION";
        $dbname = config('database.connections.mysql.database');
        $rows = Db::select($sql, [$dbname, $table]);
        $fieldlist = [];
        foreach ($rows as $key => $item) {
            $item = (array)$item;
            if ('deleted_at' == $item['COLUMN_NAME']) {
                continue;
            }
            $fieldlist[] = [
                'title' => $item['COLUMN_COMMENT'] ?: $item['COLUMN_NAME'],
                'field' => $item['COLUMN_NAME'],
                'type' => $item['DATA_TYPE'],
                'id' => $key,
            ];
        }
        return $this->success('获取成功', $fieldlist);
    }

    /**
     * 创建
     * @param Request $request
     * @return void
     */
    public function create(Request $request)
    {
        $post = $request->post();
        try {
            Validator::input($post, $this->model->rules());
            $crud = new Crud($post);
            $crud->init();
            // 记录日志
            $log = new SystemCrudLog();
            $log->content = json_encode($post, JSON_UNESCAPED_UNICODE);
            $log->created_by = $this->auth->id;
            $log->save();
        } catch (\Exception $e) {
            return $this->fail($e->getMessage());
        }
        return $this->fail('创建成功');
    }
}
