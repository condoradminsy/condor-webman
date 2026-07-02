# CondorAdmin 插件开发规范

给 OpenCode 代理的插件开发参考。本文覆盖创建新插件时需要遵循的目录结构、数据库规范、模型/控制器/路由模式。

## 占位符说明

本文使用 `{plugin_name}` 作为占位符，创建新插件时替换为实际插件名称（如 `condorsupport`、`condorshop`），表名列名同理。

## 插件目录结构

```
plugin/{plugin_name}/
  AGENTS.md                    # 本规范文件
  install.sql                  # 数据库结构
  config/
    route.php                  # 路由（后台管理 + 前端 API）
    menu.php                   # 后台菜单配置
    translation.php            # 翻译配置
    middleware.php             # 中间件
    process.php                # 自定义进程
  app/
    admin/controller/          # 后台管理控制器
    api/controller/            # 前端 API 控制器
    library/                   # 基类
    model/                     # 模型
    middleware/                 # 中间件
    service/                   # 业务服务
    queue/                     # Redis 队列消费者
  resource/translations/
    zh-cn/messages.php         # 中文翻译
    en-us/messages.php         # 英文翻译
```

## 数据库规范

### 表名前缀

所有插件表使用 `con_{plugin_name}_` 前缀：

```
con_support_user               # condorsupport 插件
con_support_agent_group        # 关联表
con_support_group_translations # 翻译表
```

### 字段规范

- **ID 字段**：`int unsigned NOT NULL AUTO_INCREMENT`（小表）、`bigint unsigned`（大表如 message）
- **名称字段**：`varchar(100)` + `utf8mb4_unicode_ci`
- **状态字段**：`tinyint NOT NULL DEFAULT 1`
- **排序字段**：`weigh int NOT NULL DEFAULT 0`
- **权重/优先级**：`int NOT NULL DEFAULT 0`
- **JSON 字段**：`json DEFAULT NULL`
- **文本字段**：`text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`
- **时间戳**：使用 `bigint DEFAULT NULL`（Unix 时间戳，非 datetime 字符串）
  - 字段名：`createtime`、`updatetime`、`deleted_at`
  - `deleted_at` 为 null 表示正常，非 null 表示软删除时间
- **字符集**：`utf8mb4 COLLATE utf8mb4_unicode_ci`
- **引擎**：InnoDB

### 翻译表模式

主表 + 翻译表通过 `main_id` + `locale` 关联：

```sql
CREATE TABLE `con_{plugin_name}_xxx` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  -- 业务字段...
  `createtime` bigint DEFAULT NULL,
  `updatetime` bigint DEFAULT NULL,
  `deleted_at` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `con_{plugin_name}_xxx_translations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `main_id` int unsigned NOT NULL COMMENT '主表ID',
  `locale` varchar(10) NOT NULL COMMENT '语言:zh-cn,en-us',
  -- 多语言字段（name, description, content...）
  PRIMARY KEY (`id`),
  UNIQUE KEY `main_locale` (`main_id`,`locale`)
);
```

### 关联表模式

多对多关系使用关联表：

```sql
CREATE TABLE `con_{plugin_name}_a_b` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `a_id` int unsigned NOT NULL,
  `b_id` int unsigned NOT NULL,
  `createtime` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `a_b` (`a_id`,`b_id`),
  KEY `a_id` (`a_id`),
  KEY `b_id` (`b_id`)
);
```

## 模型规范

### 标准模板

- 模型类名：`Xxx`（首字母大写）
- 模型 rules() 方法：`v::NotEmpty()->setName(trans('fields.aaa', [], 'xxx'))->setTemplate(trans('common.validation.required'))`，规则对应的翻译文件也要添加上
- 若是多语言的话,只需要在多语言模型的 rules() 方法中添加多语言字段规则即可,主模型不需要添加
- 主模型需要添加关联方法

```php
    public function translations(){
        return $this->hasMany(模型类名::class, 'main_id', 'id');
    }
```

- 注意,若是只需要查看的，则不需要添加rules()方法

```php
<?php

declare(strict_types=1);

namespace plugin\{plugin_name}\app\model;

use support\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Respect\Validation\Validator as v;

class Xxx extends Model
{
    use SoftDeletes;

    protected $table = '{plugin_name}_xxx';

    public $timestamps = true;

    protected $dateFormat = 'U';

    const CREATED_AT = 'createtime';
    const UPDATED_AT = 'updatetime';

    protected $guarded = [];

    protected function serializeDate(\DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    public function rules()
    {
      return [
          'aaa' => v::NotEmpty()->setName(trans('fields.aaa', [], 'xxx'))->setTemplate(trans('common.validation.required')),
      ];
    }
}
```

### 含密码字段

```php
protected array $hidden = ['password'];
```

### 引用规则

- 所有模型继承 `support\Model`（`vendor/webman/database/src/support/Model.php`）
- 而非直接继承 Eloquent 原生 Model
- 必须加 `declare(strict_types=1);`
- 必须使用 `SoftDeletes` trait（若表没有 `deleted_at`，则不用添加）

## 控制器规范

### 选择决策树

```
该表是否有 _translations 翻译表？
├── 是 → 使用 TranslatableBackend
│   ├── 设置 $translationModel
│   └── 设置 $multilingualFields
└── 否 → 使用 Backend
```

### 两种基类

#### Backend（标准 CRUD）

用于无多语言翻译的表。模型、可搜索字段、排序字段是必填项。

```php
<?php

declare(strict_types=1);

namespace plugin\{plugin_name}\app\admin\controller;

use plugin\condoradmin\app\library\Backend;
use plugin\{plugin_name}\app\model\Xxx;

class XxxController extends Backend
{
    protected $model;

    protected array $searchable = [
        'name'   => ['type' => 'string'],
        'status' => ['type' => 'int'],
    ];

    public function __construct()
    {
        $this->model = new Xxx();
        parent::__construct();
    }
}
```

#### TranslatableBackend（多语言 CRUD）

用于有 `_translations` 翻译表的实体。自动处理多语言字段的增删改，无需手写 `add()`/`edit()`。

```php
<?php

declare(strict_types=1);

namespace plugin\{plugin_name}\app\admin\controller;

use plugin\condoradmin\app\library\TranslatableBackend;
use plugin\{plugin_name}\app\model\Xxx;
use plugin\{plugin_name}\app\model\XxxTranslations;

class XxxController extends TranslatableBackend
{
    protected $model;

    protected array $searchable = [
        'name' => ['type' => 'string'],
    ];

    protected array $multilingualFields = ['name', 'description'];

    protected $translationModel = null;

    public function __construct()
    {
        $this->model = new Xxx();
        $this->translationModel = new XxxTranslations();
        parent::__construct();
    }
}
```

### 强制要求

所有控制器必须满足：

- `$model` 在构造函数中实例化
- `$searchable` 使用 `protected array` 类型声明
- `$sortable` 使用 `protected array` 类型声明，若有特殊的字段，则才需要声明
- `$noNeedRight = ['selectpage']`（下拉选择不需要 RBAC 权限，默认已经是了，没有特殊要求，可不添加，继承即可）
- 命名空间 `plugin\{plugin_name}\app\admin\controller`
- 文件命名：`XxxController.php`（首字母大写）

### searchable 类型对照

| type 值 | 适用场景 |
|----------|---------|
| `'string'` | 名称、描述、文本字段 |
| `'int'` | ID、状态、分类、外键 |
| `'date'` | 日期范围查询 |

### 响应方法

前端/客服 API 控制器继承 `Frontend` 基类：

```php
$this->success(string $msg, array $data)  // → {code: '0000', data, msg}
$this->fail(string $msg)                   // → {code: 4000, msg}
```

后台 API 控制器继承 `Backend`，直接使用：

```php
$this->success(string $msg, array $data)  // → {code: 0, data, msg}
$this->fail(string $msg)                   // → {code: 1, msg}
```

## 路由规范

### 后台管理路由

放在 `/core/{plugin_name}` 分组下：

```php
Route::group('/core/{plugin_name}', function () {
    // 完整 CRUD：自动生成 index/add/edit/del/multi/selectpage
    createRoutes('/xxx', \plugin\{plugin_name}\app\admin\controller\XxxController::class);

    // 仅查看：日志/记录类表只需 index
    Route::post('/xxx/index', [\plugin\{plugin_name}\app\admin\controller\XxxController::class, 'index']);
});
```

### 路由类型选择

| 路由类型 | 方法 | 适用场景 |
|----------|------|---------|
| `createRoutes()` | 自动注册 6 个 POST | 需要管理增删改的业务表 |
| 手动 `Route::post('/xxx/index')` | 仅 index | 日志、审计、记录等只读表 |

### 创建路由的控制器方法

`createRoutes()` 自动检测控制器是否包含以下方法，有则注册：

```php
createRoutes('/xxx', Controller::class);
// 相当于注册：
// POST /xxx/index      → Controller::index()
// POST /xxx/add        → Controller::add()
// POST /xxx/edit       → Controller::edit()
// POST /xxx/del        → Controller::del()
// POST /xxx/multi      → Controller::multi()
// POST /xxx/selectpage → Controller::selectpage()
```

## 翻译规范

### 键名格式

优先判断是否可使用全局的翻译文件，独有的翻译才需要添加，翻译键必须包含 `{plugin_name}.` 前缀：

```php
// {plugin_name}/resource/translations/zh-cn/messages.php
return [
    '{plugin_name}.ok'                       => '操作成功',
    '{plugin_name}.system.error'             => '系统错误',
    '{plugin_name}.login.failed'             => '用户名或密码错误',
];
```

### trans() 调用

```php
trans('{plugin_name}.key.name')
```

## 基于 condoradmin 基类的特殊说明

### Backend 基类

来自 `plugin\condoradmin\app\library\Backend`：

- 自动注入 condoradmin 的 RBAC 认证上下文
- 自动处理分页、搜索、排序
- 默认搜索方法：`index()` 使用 `$searchable` + `$sortable`
- `$dataLimit` 属性控制数据权限范围
- `$hidden` 属性自动过滤敏感字段输出

### TranslatableBackend 基类

来自 `plugin\condoradmin\app\library\TranslatableBackend`：

- 继承自 Backend
- 自动处理多语言字段的创建和更新
- 需要设置 `$multilingualFields` 和 `$translationModel`
- 增删改时自动同步翻译表

### 自动过滤

```php
protected $hidden = ['password'];  // 序列化时自动隐藏
protected $dataLimit = 'personal'; // 数据权限：仅看自己
```

## 新建插件操作清单

创建新插件时按此顺序操作：

1. **创建目录结构**
   - `plugin/{plugin_name}/` 及其子目录
   - `config/route.php`、`config/translation.php`、`config/menu.php`

2. **根据 `install.sql`，生成对应的模型文件**
   - 定义所有表（主表、翻译表、关联表）
   - 遵循命名规范（`con_{plugin_name}_xxx`）
   - 字段规范（bigint 时间戳、utf8mb4、InnoDB）

3. **生成所有模型**
   - 每个表一个文件，遵循标准模板
   - 含 password 字段的加 `$hidden`

4. **创建后台控制器**
   - 按决策树选择 Backend / TranslatableBackend
   - 配置 `$searchable`

5. **配置路由**
   - 后台路由 `/core/{plugin_name}` 分组
   - CRUD 用 `createRoutes()`，只读用 `Route::post('/xxx/index')`

6. **配置菜单**
   - `config/menu.php` 注册菜单层级

7. **完善翻译文件**
   - `zh-cn/messages.php` + `en-us/messages.php`
   - 所有键加 `{plugin_name}.` 前缀

8. **配置 `translation.php`**
   - 添加翻译路径指向 `plugin/{plugin_name}/resource/translations`
