# CondorAdmin-webman — Agent 指南

给 OpenCode 代理的紧凑事实参考。完整架构概览见 `CLAUDE.md` — 本文只覆盖容易遗漏或猜错的内容。

## 开发命令

```bash
# 开发环境启动（热重载生效）
php start.php start

# 生产环境（守护进程）/ 停止 / 重启 / 平滑重载 / 查看状态
php start.php start -d
php start.php {stop|restart|reload|status}

# Windows 用户
php windows.php

# 安装依赖
composer install
```

没有配置测试、代码检查或静态分析工具。没有 CI。

## 项目结构

```
plugin/
  condoradmin/       # 后台管理 — 控制器、CRUD 生成、RBAC、SSE、定时任务
  condorauth/        # 前端用户认证 — 策略模式（密码/短信/邮箱/小程序）
  condorbuyback/
  condorlawyer/
  condormental/
  condorshop/
  condorsms/
  condorsupport/
app/                 # 骨架 — IndexController、Http/Monitor 进程
config/              # 框架级配置
support/             # Request、Response、Model 基类
```

业务逻辑在插件中。每个插件拥有独立的 `config/`、`app/controller/`、`app/model/`、`app/middleware/`、`resource/translations/`。

## 插件注册

- `Route::disableDefaultRoute('plugin_name')` — 在每个插件的 `config/route.php` 中调用，防止 webman 自动解析控制器。
- 插件路由必须放在命名分组下（`/core` 后台，`/api` 前端）。
- `createRoutes($prefix, $controllerClass)` 自动生成：`index`、`add`、`edit`、`del`、`multi`、`selectpage` 的 POST 路由。

## 控制器模式

控制器继承以下基类之一：
- **`Backend`**（`plugin/condoradmin/app/library/Backend.php`）— 标准 CRUD。通过声明 `$searchable`、`$model`、`$noNeedLogin`、`$noNeedRight`、`$dataLimit`、`$multiFields`、`$with` 来定制行为。
- **`TranslatableBackend`** — 国际化实体。需要 `$multilingualFields` 和 `$translationModel`。

响应辅助方法：`$this->success($msg, $data)` 和 `$this->fail($msg)`。错误消息统一通过 `trans()`。

**验证**：使用 `Respect\Validation\Validator`（不是 Laravel 验证器）。模型通过 `rules()` 返回 `[field => v::rule()]` 数组。控制器调用 `Validator::input($params, $this->model->rules())`。

**请求**：`$request->input($key)` 同时读取 query 和 body。`$request->post($key)` 只读 post body。`$request->more([...])` 是 `support/Request.php` 中的自定义辅助方法，批量获取参数并带默认值。

## 模型（Eloquent ORM）

```php
class SystemAdmin extends Model {
    use SoftDeletes;
    protected $table = 'system_admin';
    protected $guarded = [];      // 全部字段可批量赋值
    public $timestamps = true;    // 但时间戳是 bigint Unix 格式
    protected $dateFormat = 'U';  // 使用 Unix 时间戳
    const CREATED_AT = 'createtime';
    const UPDATED_AT = 'updatetime';
    // deleted_at 也是 bigint 格式用于软删除
}
```

要点：
- Eloquent 来自 `illuminate/database`，通过 `webman/database` 接入。
- **所有时间戳字段都是 bigint Unix 时间戳**（`$dateFormat = 'U'`）。不要使用 Carbon 或 datetime 字符串。
- `$guarded = []` — 全部字段开放批量赋值。Backend 控制器中必须调用 `preExcludeFields()` 过滤请求字段。
- 连接池配置在 `config/database.php` 中（`min_connections`、`max_connections`、`wait_timeout`）。

## 数据库

- 前缀：`con_`（来自 .env `MYSQL_PREFIX`）。
- 软删除：`deleted_at bigint DEFAULT NULL`（null = 正常，数字 = 删除时间戳）。
- 国际化表模式：`system_config` ↔ `system_config_translations`，通过 `main_id` 和 `locale` 关联。

## 路由

所有后台路由都在 `/core` 分组下。CRUD 路由全部为 POST：
```
POST /core/menu/index
POST /core/menu/add
POST /core/menu/edit
POST /core/menu/del
POST /core/menu/multi
POST /core/menu/selectpage
```

前端路由在 `/api` 下：
```
POST /api/auth/login
POST /api/auth/register
...
```

## 认证

- JWT 由 `tinywan/jwt` 管理。使用 `getCurrentInfo()`（位于 `plugin/condoradmin/app/functions.php`）从 token 中提取用户信息。
- Redis key `admin:token:<token>` 存储管理员用户 ID。如果 Redis 中此 key 不存在，则 token 无效（支持强制下线）。
- **Auth 实例**：`Context::get('auth')`（`plugin\condoradmin\app\library\Auth` 的实例），不是 `auth()`。
- **超级管理员**：角色 code 为 `superadmin` → `getRuleIds()` 返回 `['*']`。
- 权限缓存于 Redis：keys `role:group:uid:*`、`rulelist:key:uid:*`、`rulelist:uid:*`。通过 `Auth::clearRoleCacheByUid($uid)`、`Auth::clearCacheByRoleId($role_id)`、`Auth::clearCacheByRuleId($rule_id)` 清除。
- 控制器上的 `$noNeedLogin` 和 `$noNeedRight` 数组控制中间件跳过行为。

## 中间件（顺序）

配置在 `config/middleware.php`（全局 `@`）和各插件配置中：
1. **CrossDomain** — CORS 头
2. **Lang** — 语言检测（从请求头/参数读取）
3. **AuthToken** — JWT + Redis 有效性检查
4. **AuthPermission** — 基于 system_menu_rule 路径的 RBAC
5. **OperateLog** — 记录 CRUD 操作

## 国际化

- Symfony Translation 组件。
- 语言文件：`resource/translations/{locale}/*.php` 和 `plugin/*/resource/translations/{locale}/*.php`。
- 支持：`zh-cn`、`en-us`。默认：`zh-cn`。
- **函数**：`trans('domain.key', [], 'domain')` — 例如 `trans('condoradmin.ok')`。
- **数据库国际化**：`TranslatableBackend` 配合 `$multilingualFields` + `$translationModel`。调用 `$this->renderTranslations($collection)` 解析。

## 进程（config/process.php + 插件配置）

- **webman**：HTTP 服务，监听 `SERVER_HOST`（默认 `http://0.0.0.0:5566`）
- **monitor**：文件变更热重载（仅开发环境，通过 `-d` 参数自动判断）
- **condor-sse**：SSE 事件服务，监听 `CONDOR_SSE_LISTEN`（默认 `http://0.0.0.0:5567`），使用 `webman/channel`
- **condor-crontab**：定时任务调度器，使用 `workerman/crontab`

## SSE

```php
sendSseMessage($data, 'condor_sse_broadcast');
```
通过 `Webman\Channel\Client` 广播实时事件。用于通知、定时任务输出等。

## CRUD 代码生成器

内置功能，路由：`GET /core/crud/config`、`POST /core/crud/fields`、`POST /core/crud/create`。生成控制器、模型、路由、菜单和前端页面。排除表列表在 `plugin/condoradmin/config/condor.php` 的 `crud.exclude_tables` 中。

## 密码

- 前端使用 RSA 加密（公钥来自 `config/condor.php`）。
- 后端使用 bcrypt 存储：`password_hash()` / `getEnctyptPassword($password)`。
- 验证：`password_verify()` / `verifyPassword($password, $hash)`。

## Redis Key 模式

```
admin:token:<token>              # token → admin_id（认证会话）
role:group:uid:<uid>             # 用户的角色组
rulelist:key:uid:<uid>           # 规则列表缓存版本标记
rulelist:uid:<uid>:<md5>:<type>  # 已解析的权限路径
```

## 事件

按插件在 `config/event.php` 中配置：
```php
'admin.login'   => [[SystemLog::class, 'login']]
'admin.operate' => [[SystemLog::class, 'operate']]
```

## 注意事项

- **没有测试、没有静态分析、没有代码检查** — 靠自觉，手动验证。
- **`composer.lock` 在 `.gitignore` 中** — 有意为之，不要提交。
- **控制器后缀** `Controller` 是 webman 配置强制的（`controller_suffix => 'Controller'`）。
- **`controller_reuse => false`** — 每次请求新建控制器实例。基于常驻内存的非协程框架可以这样做。
- **批量赋值全开放**（所有模型 `$guarded = []`）。Backend 控制器调用 `preExcludeFields()` 过滤请求字段。
- **验证库**：`Respect\Validation`，不是 Laravel 验证器。模型通过 `rules()` 返回 `Validator::input()` 兼容的规则数组。
- **`Context::get('auth')`** 在构造函数中使用 — 不要类型提示或依赖注入；它在控制器初始化前由中间件设置。
