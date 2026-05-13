# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 常用命令

```bash
# 开发环境启动（带热重载）
php start.php start

# 生产环境启动（守护进程模式）
php start.php start -d

# 停止 / 重启 / 平滑重载 / 查看状态
php start.php stop
php start.php restart
php start.php reload
php start.php status

# Windows 用户
php windows.php

# 安装依赖
composer install
```

本项目未配置测试套件或代码检查工具。

## 架构概览

CondorAdmin 是基于 **webman**（Workerman 驱动的高性能 PHP 框架，常驻内存、事件驱动、无需 Nginx/Apache）开发的后台管理系统。技术栈：PHP >= 8.1、MySQL、Redis、JWT。

### 插件系统

业务逻辑位于 `plugin/` 目录下。每个插件自包含，拥有独立的 `config/`、`app/controller/`、`app/model/`、`app/middleware/` 等目录。两个核心插件：

- **`condoradmin`** — 后台管理面板。包含菜单管理、角色管理、管理员管理、配置管理、附件管理、字典管理、定时任务、操作日志以及 CRUD 代码生成器等控制器。
- **`condorauth`** — 前端用户认证。用户注册和登录（密码登录、小程序登录，通过 `LoginStrategyFactory` 策略模式实现）。

### 请求处理流程

```
HTTP 请求
  → CrossDomain 中间件（跨域处理）
  → Lang 中间件（语言检测）
  → AuthToken 中间件（JWT 校验 + Redis token 有效性检查）
  → AuthPermission 中间件（基于 system_menu_rule 的 RBAC 权限校验）
  → OperateLog 中间件（操作日志记录）
  → Controller
```

中间件在 `plugin/<插件名>/config/middleware.php` 中按插件配置，全局中间件在 `config/middleware.php` 中配置。

### 控制器层级

控制器继承以下基类之一：

- **`Backend`**（`plugin/condoradmin/app/library/Backend.php`）— 标准 CRUD 基类，提供 `index`、`add`、`edit`、`del`、`destroy`、`restore`、`multi`、`selectpage` 方法。子类通过声明 `$searchable`（可搜索字段）、`$model`、`$noNeedLogin`、`$noNeedRight`、`$dataLimit` 等属性来定制行为。
- **`TranslatableBackend`**（`plugin/condoradmin/app/library/TranslatableBackend.php`）— 继承 `Backend`，用于将国际化数据存储在单独翻译表中的实体。子类需声明 `$multilingualFields` 和 `$translationModel`。

### 路由

路由定义在 `plugin/<插件名>/config/route.php` 中。`createRoutes()` 辅助函数（位于 `plugin/condoradmin/app/functions.php`）自动生成标准 CRUD 路由（`/prefix/index`、`/prefix/add`、`/prefix/edit`、`/prefix/del`、`/prefix/multi`、`/prefix/selectpage`）。所有后台路由统一归属于 `/core` 分组。

### 认证与权限

- JWT token 由 `tinywan/jwt` 管理，`getCurrentInfo()` 辅助函数从 JWT 中提取当前用户信息。
- 有效 token 同时存储在 Redis 中（key 格式：`admin:token:<token>`）。若 Redis 中 key 不存在，则 token 视为无效（支持强制下线）。
- RBAC：用户属于角色组（`system_role_group`），角色组关联角色（`system_role`），角色中的 `rules` 字段以逗号分隔存储菜单规则 ID。权限检查时将这些 ID 解析为 `system_menu_rule` 中的路由路径。
- 超级管理员角色 code 为 `superadmin`，拥有 `*`（全部权限）。
- 权限结果缓存在 Redis 中，角色/规则变更时清除缓存。

### 数据模型

模型使用 Eloquent ORM（`illuminate/database`），数据库连接池配置在 `config/database.php` 中。支持国际化的实体遵循以下模式：主表模型（如 `SystemConfig`）通过 `translations()` 关联到翻译表模型（如 `SystemConfigTranslations`），以 `main_id` 和 `locale` 作为关联键。

### 配置

- `.env` 位于项目根目录，存放环境相关配置（数据库、Redis、JWT 密钥等）。
- `config/` 存放框架级配置。
- `plugin/<插件名>/config/` 存放插件级配置。重要文件：`plugin/condoradmin/config/condor.php` 包含 RSA 密钥（用于前端密码加密）、SSE 配置、CRUD 生成器排除表列表。

### 进程

在 `config/process.php` 和 `plugin/condoradmin/config/process.php` 中定义：

- **webman** — 主 HTTP 服务（端口来自 `SERVER_HOST` 环境变量）
- **monitor** — 文件变更热重载（仅开发环境）
- **condor-sse** — Server-Sent Events 服务（端口来自 `CONDOR_SSE_LISTEN` 环境变量），使用 `webman/channel`
- **condor-crontab** — 定时任务调度器，使用 `workerman/crontab`

### 国际化

使用 Symfony Translation，语言文件位于 `resource/translations/` 和 `plugin/*/resource/translations/`。支持 `zh-cn` 和 `en-us`。用户可见消息统一使用 `trans()` 辅助函数。数据库级别的国际化由 `TranslatableBackend` 通过独立的翻译表处理。
