<?php

namespace plugin\condoradmin\app\library;

use support\Log;

class Crud
{
    private $option;

    private $controllerName = '';
    private $modelName = '';
    private $module = '';
    private $tableName = '';
    private $menuPath = '';
    private $component = '';

    public function __construct($option)
    {
        $prefix = config('database.connections.mysql.prefix');
        $this->option = $option ?: [];
        $this->controllerName = trim(str_replace('.php', '', $this->option['controller']));
        $this->modelName = trim(str_replace('.php', '', $this->option['model']));
        $this->tableName = trim(str_replace($prefix, '', $this->option['table']));
        $this->menuPath = $this->option['menu_path'] ?? '';
        $this->component = trim(str_replace('/', '_', $this->menuPath), '_');
        $this->init();
    }

    // 初始化
    public function init()
    {
        // 校验模块目录
        $this->checkModuleDir();
        // 生成控制器
        $this->createController();
        // 生成模型
        $this->createModel();
        // 生成路由
        $this->createRoute();
        // 生成菜单
        $this->createMenu();
        // 生成前端页面 - 校验目录
        $this->createFrontend();
    }

    // 校验模块目录
    public function checkModuleDir()
    {
        $module_dir = $this->option['module'] ?? '';
        if (empty($module_dir)) {
            throw new \Exception('模块目录不能为空');
        }
        if (!is_dir($module_dir)) {
            throw new \Exception('模块目录不存在');
        }
        $this->module = str_replace('/', '\\', $module_dir);
        return true;
    }


    // 生成控制器
    public function createController()
    {
        $dir = base_path() . '/plugin/condoradmin/app/tpls/controller.tpl';
        $tpl = file_get_contents($dir);
        if (empty($tpl)) {
            throw new \Exception('控制器模板不存在');
        }
        $module_dir = $this->option['module'];
        $file = $module_dir . 'controller/' . $this->controllerName . '.php';
        if (file_exists($file) && !$this->option['is_force']) {
            return;
        }
        $tpl = str_replace(['{module}', '{controllerName}', '{modelName}'], [$this->module, $this->controllerName, $this->modelName], $tpl);
        $searchable = '[';
        foreach ($this->option['fields'] as $item) {
            if (isset($item['table']['operator']) && $item['table']['operator'] === -1) {
                continue;
            }
            $type = $item['type'] == 'number' ? 'int' : 'string';
            $searchable .= <<<EOT

        '{$item['field']}' => ['type' => '{$type}'],
EOT;
        }
        $searchable .= <<<EOT

    ]
EOT;
        $tpl = str_replace(['{searchable}'], [$searchable], $tpl);
        file_put_contents($file, $tpl);
    }

    // 生成模型
    public function createModel()
    {
        $dir = base_path() . '/plugin/condoradmin/app/tpls/model.tpl';
        $tpl = file_get_contents($dir);
        if (empty($tpl)) {
            throw new \Exception('模型模板不存在');
        }
        $module_dir = $this->option['module'];
        $file = $module_dir . 'model/' . $this->modelName . '.php';
        if (file_exists($file) && !$this->option['is_force']) {
            return;
        }
        // 是否软删除
        if ($this->option['is_soft_delete']) {
            $tpl = str_replace(['{useSoftDeletes}', '{softDeletes}'], ['use Illuminate\Database\Eloquent\SoftDeletes;', 'use SoftDeletes;'], $tpl);
        } else {
            $tpl = str_replace(['{useSoftDeletes}', '{softDeletes}'], ['', ''], $tpl);
        }
        // 是否创建时间/更新时间
        $tpl = str_replace(['{createtime}', '{updatetime}'], [$this->option['is_create_time'] ? "'createtime'" : 'null', $this->option['is_update_time'] ? "'updatetime'" : 'null'], $tpl);
        // 名称
        $tpl = str_replace(['{module}', '{modelName}', '{tableName}'], [$this->module, $this->modelName, $this->tableName], $tpl);
        // rules
        $rules = '[';
        foreach ($this->option['fields'] as $item) {
            if (isset($item['form']['is_form']) && $item['form']['is_form'] === false) {
                continue;
            }
            $rules .= <<<EOT

            '{$item['field']}' => v::optional(v::notEmpty())->setName('{$item['title']}'),
EOT;
        }
        $rules .= <<<EOT

        ]
EOT;
        $tpl = str_replace(['{rules}'], [$rules], $tpl);
        file_put_contents($file, $tpl);
    }

    // 生成路由
    public function createRoute()
    {
        if (!$this->option['is_route']) {
            return;
        }
        $module_dir = $this->option['module'];
        $routePath = base_path() . '/' . $module_dir . '../config/route.php';
        // 校验路由文件是否存在
        $routeAppender = new RouteAppender($routePath, $this->option['route_group']);
        $route_name = $this->option['route_name'] ?: $this->modelName;
        // route_name 是否 / 开头，没有则加上
        if (substr($route_name, 0, 1) != '/') {
            $route_name = '/' . $route_name;
        }
        $path = $module_dir . 'controller/' . $this->controllerName;
        // path 是否 / 开头，没有则加上
        if (substr($path, 0, 1) != '/') {
            $path = '/' . $path;
        }
        // $path / 替换 \
        $path = str_replace('/', '\\', $path);
        $routeAppender->addCreateRoutesBeforeOptions($route_name, $path);
    }

    // 生成菜单
    public function createMenu()
    {
        if (!$this->option['is_menu']) {
            return;
        }
        try {
            $menuModel = new \plugin\condoradmin\app\model\SystemMenuRule();
            $menuModel->is_keep = 1;
            if ($this->option['menu_id']) {
                $row = \plugin\condoradmin\app\model\SystemMenuRule::find($this->option['menu_id']);
                if ($row) {
                    $menuModel->pid = $row->id;
                }
            }
            $menuModel->name = $this->option['menu_name'] ?: camelToUnderline($this->modelName);
            $menuModel->title = $this->option['menu_title'] ?: $this->modelName;
            $menuModel->icon = 'mdi:checkbox-multiple-blank-circle-outline';
            $menuModel->path = $this->menuPath;
            $menuModel->component = 'view.' . $this->component;
            $menuModel->hidden = 0;
            $menuModel->menu_type = 1;
            $menuModel->weigh = 0;
            $menuModel->status = 1;
            $menuModel->save();
            $apiMenus = [
                [
                    'name' => 'index',
                    'title' => '查看',
                ],
                [
                    'name' => 'add',
                    'title' => '添加',
                ],
                [
                    'name' => 'edit',
                    'title' => '编辑',
                ],
                [
                    'name' => 'del',
                    'title' => '删除',
                ],
                [
                    'name' => 'multi',
                    'title' => '批量操作',
                ],
                [
                    'name' => 'selectpage',
                    'title' => '选择列表',
                ]
            ];
            $route_name = $this->option['route_name'] ?: $this->modelName;
            if (substr($route_name, 0, 1) != '/') {
                $route_name = '/' . $route_name;
            }
            if ($this->option['route_group']) {
                $route_name = $this->option['route_group'] . $route_name;
            }
            // 生成接口菜单
            foreach ($apiMenus as $item) {
                $menuModel = new \plugin\condoradmin\app\model\SystemMenuRule();
                $menuModel->is_keep = 1;
                $menuModel->pid = $menuModel->id;
                $menuModel->name = trim(str_replace('/', '_', $route_name . '/' . $item['name']), '_');
                $menuModel->title = $item['title'];
                $menuModel->path = $route_name . '/' . $item['name'];
                $menuModel->hidden = 0;
                $menuModel->menu_type = 0;
                $menuModel->weigh = 0;
                $menuModel->status = 1;
                $menuModel->save();
            }
        } catch (\Exception $e) {
            Log::error('生成菜单失败：', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
        }
    }

    // 生成前端页面
    public function createFrontend()
    {
        if (empty($this->option['frontend'])) {
            return;
        }
        if (!is_dir($this->option['frontend'])) {
            throw new \Exception('前端页面目录不存在');
        }
        $dir = base_path() . '/plugin/condoradmin/app/tpls/frontend.tpl';
        $tpl = file_get_contents($dir);
        if (empty($tpl)) {
            throw new \Exception('前端页面模板不存在');
        }
        $fields = $this->option['fields'] ?? [];
        if (empty($fields)) {
            throw new \Exception('字段不能为空');
        }
        $file = $this->option['frontend'] . $this->menuPath;
        // 如果最后一个不是 /
        if (substr($file, -1) != '/') {
            $file .= '/';
        }
        // 判断目录是否存在，不存在则创建
        if (!is_dir($file)) {
            mkdir($file, 0777, true);
        }
        $file .= 'index.vue';
        if (file_exists($file) && !$this->option['is_force']) {
            return;
        }
        $route_name = $this->option['route_name'] ?: $this->modelName;
        if (substr($route_name, 0, 1) != '/') {
            $route_name = '/' . $route_name;
        }
        if ($this->option['route_group']) {
            $route_name = $this->option['route_group'] . $route_name;
        }
        $urls = <<<EOF
{
    index: '{$route_name}/index',
    add: '{$route_name}/add',
    edit: '{$route_name}/edit',
    del: '{$route_name}/del'
  }
EOF;
        $columns = '[';
        foreach ($fields as $item) {
            $more = '';
            $isForm = true;
            // 表单
            if (isset($item['form']['is_form']) && $item['form']['is_form'] === false) {
                $isForm = false;
                $more .= <<<EOF

      form: false,
EOF;
            }
            // 搜索
            if (isset($item['table']['operator'])) {
                if ($item['table']['operator'] === -1) {
                    $more .= <<<EOF

      operator: false,
EOF;
                } else if ($item['table']['operator'] !== '=') {
                    $more .= <<<EOF

      operator: '{$item['table']['operator']}',
EOF;
                }
            }
            // 可见
            if (isset($item['table']['visible']) && $item['table']['visible'] === false) {
                $more .= <<<EOF

      visible: false,
EOF;
            }
            // 默认值
            if (isset($item['form']['value'])) {
                $value = $item['type'] === 'switch' ? ($item['form']['value'] === 'true' ? 'true' : 'false') : ($item['type'] === 'number' ? (int)$item['form']['value'] : (string)$item['form']['value']);
                $more .= <<<EOF

      value: {$value},
EOF;
            }
            // 文本域
            if ($isForm && $item['type'] === 'text' && isset($item['form']['is_textarea']) && $item['form']['is_textarea'] === true) {
                $more .= <<<EOF

      component: {
        props: {
          type: 'textarea',
          rows: 4
        }
      },
EOF;
            }
            // 数字
            if ($isForm && $item['type'] === 'number') {
                $showButton = isset($item['form']['showButton']) && $item['form']['showButton'] ? 'true' : 'false';
                $more .= <<<EOF

      component: {
        name: 'n-input-number',
        props: {
          showButton: {$showButton}
        }
      },
EOF;
            }
            // 开关
            if ($isForm && $item['type'] === 'switch') {
                $checkedValue = isset($item['form']['checked_value']) ? $item['form']['checked_value'] : 1;
                $uncheckedValue = isset($item['form']['unchecked_value']) ? $item['form']['unchecked_value'] : 0;
                $more .= <<<EOF

      component: {
        name: 'n-switch',
        props: {
          checkedValue: {$checkedValue},
          uncheckedValue: {$uncheckedValue}
        }
      },
EOF;
            }
            // 上传
            if ($isForm && $item['type'] === 'upload') {
                $maxUpload = isset($item['form']['max_upload']) ? $item['form']['max_upload'] : 1;
                $multiple = $maxUpload > 1 ? 'true' : 'false';
                $more .= <<<EOF

      component: {
        name: 'condor-upload',
        props: {
          max: {$maxUpload},
          multiple: {$multiple}
        }
      },
EOF;
            }
            // 日期
            if ($isForm && $item['type'] === 'date') {
                $more .= <<<EOF

      component: {
        name: 'n-date-picker',
        props: {
          type: 'date'
        }
      },
EOF;
            }
            // 日期
            if ($isForm && $item['type'] === 'datetime') {
                $more .= <<<EOF

      component: {
        name: 'n-date-picker',
        props: {
          type: 'datetime'
        }
      },
EOF;
            }
            // 日期范围
            if ($isForm && $item['type'] === 'daterange') {
                $more .= <<<EOF

      component: {
        name: 'n-date-picker',
        props: {
          type: 'daterange'
        }
      },
EOF;
            }
            // 富文本
            if ($isForm && $item['type'] === 'editor') {
                $more .= <<<EOF

      component: {
        name: 'condor-editor'
      },
EOF;
            }
            // 字典
            if ($isForm && $item['type'] === 'dict') {
                $dictType = isset($item['form']['dict_type']) ? $item['form']['dict_type'] : 'condor-dict-radio';
                $more .= <<<EOF

      component: {
        name: '{$dictType}',
        props: {
          code: '{$item['form']['dict_code']}'
        }
      },
EOF;
            }
            // 去掉最后一个逗号
            $more = substr($more, 0, -1);
            $columns .= <<<EOF

    {
      title: '{$item['title']}',
      key: '{$item['field']}',{$more}
    },
EOF;
        }
        // 去掉最后一个逗号
        $columns = substr($columns, 0, -1);
        $columns .= "\r\n  ]";
        $tpl = str_replace(['{urls}', '{columns}'], [$urls, $columns], $tpl);
        // 
        file_put_contents($file, $tpl);
    }
}
