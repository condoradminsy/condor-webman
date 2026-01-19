<?php

namespace plugin\condoradmin\app\library;

use PhpParser\ParserFactory;
use PhpParser\Node;
use PhpParser\NodeFinder;
use PhpParser\PrettyPrinter;
use PhpParser\Node\Stmt\Expression;
use PhpParser\Node\Expr\StaticCall;
use support\Log;

class RouteAppender
{

    private $parser;
    private $printer;
    private $nodeFinder;
    private $routePath;
    private $routeGroupPrefix;

    public function __construct($path, $groupPrefix)
    {
        $this->parser = (new ParserFactory())->createForNewestSupportedVersion();
        $this->printer = new PrettyPrinter\Standard;
        $this->nodeFinder = new NodeFinder;
        $this->routePath = $path;
        $this->routeGroupPrefix = $groupPrefix;
    }

    /**
     * 在 Route::options 前添加 createRoutes 调用
     */
    public function addCreateRoutesBeforeOptions($routePath, $controllerClass): bool
    {
        // 读取文件内容
        $code = file_get_contents($this->routePath);
        // 解析为 AST
        try {
            $ast = $this->parser->parse($code);
        } catch (\Exception $e) {
            Log::error('路由文件解析失败', [
                'file' => $this->routePath,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            return false;
        }
        // 检查是否已存在相同的 createRoutes 调用
        if ($this->createRoutesExists($ast, $routePath, $controllerClass)) {
            return false; // 已存在，不添加
        }
        // 查找指定的路由分组
        $targetGroup = $this->findRouteGroup($ast);
        // 创建 createRoutes 函数调用节点
        $createRoutesNode = $this->createCreateRoutesNode($routePath, $controllerClass);
        if ($targetGroup) {
            $closure = $targetGroup->args[1]->value;
            // 查找 Route::options 语句的位置
            $optionsPosition = $this->findOptionsRoutePosition($closure->stmts);
            if ($optionsPosition === null) {
                // 如果没有找到 options 路由，添加到分组闭包末尾
                $closure->stmts[] = new Expression($createRoutesNode);
            } else {
                //在 options 路由前插入
                array_splice($closure->stmts, $optionsPosition, 0, [new Expression($createRoutesNode)]);
            }
        } else {
            // 如果没有找到分组，创建新的分组
            $newGroup = $this->createRouteGroup([new Expression($createRoutesNode)]);
            $ast[] = new Expression($newGroup);
        }
        // 重新生成代码
        $newCode = $this->printer->prettyPrintFile($ast);
        // 写回文件
        file_put_contents($this->routePath, $newCode);
        return true;
    }

    /**
     * 添加路由到分组
     * @param [type] $newRoute
     * @return void
     */
    public function addRouteToGroup($newRoute)
    {
        // 读取文件内容
        $code = file_get_contents($this->routePath);
        try {
            // 解析为 AST
            $ast = $this->parser->parse($code);
        } catch (\Exception $e) {
            Log::error('路由文件解析失败', [
                'file' => $this->routePath,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            return false;
        }
        // 1. 首先检查是否已存在相同路由
        if ($this->routeExists($ast, $newRoute)) {
            return false; // 路由已存在，不添加
        }
        // 查找指定的路由分组
        $targetGroup = $this->findRouteGroup($ast);
        if ($targetGroup) {
            // 创建新路由节点
            $newRouteNode = $this->createRouteNode($newRoute);
            // 添加到分组闭包中
            $closure = $targetGroup->args[1]->value;
            if ($closure instanceof Node\Expr\Closure) {
                $closure->stmts[] = new Expression($newRouteNode);
            }
        } else {
            // 如果没有找到分组，创建新的分组
            $newGroup = $this->createRouteGroup([
                new Expression($this->createRouteNode($newRoute))
            ]);
            $ast[] = new Expression($newGroup);
        }
        // 重新生成代码
        $newCode = $this->printer->prettyPrintFile($ast);
        // 写回文件
        file_put_contents($this->routePath, $newCode);
    }

    // 找到指定的路由分组
    private function findRouteGroup($ast)
    {
        // 查找指定的路由分组
        return $this->nodeFinder->findFirst($ast, function (Node $node) {
            if (!$node instanceof StaticCall) {
                return false;
            }
            // 检查是否为 Route::group
            if (
                !($node->class instanceof Node\Name) ||
                $node->class->toString() !== 'Route' ||
                $node->name->name !== 'group'
            ) {
                return false;
            }
            // 检查分组前缀
            $firstArg = $node->args[0] ?? null;
            if ($firstArg && $firstArg->value instanceof Node\Scalar\String_) {
                return $firstArg->value->value === $this->routeGroupPrefix;
            }
            return false;
        });
    }

    /**
     * 创建单个路由
     * @param array $routeConfig
     * @return StaticCall
     */
    private function createRouteNode(array $routeConfig): StaticCall
    {
        return new StaticCall(
            new Node\Name('Route'),
            $routeConfig['method'], // 'post', 'get' 等
            [
                new Node\Arg(new Node\Scalar\String_($routeConfig['uri'])),
                new Node\Arg(new Node\Expr\Array_([
                    new Node\Expr\ClassConstFetch(
                        new Node\Name($routeConfig['controller']),
                        'class'
                    ),
                    new Node\Scalar\String_($routeConfig['action'])
                ]))
            ]
        );
    }

    /**
     * 创建路由分组
     * @param array $routes
     * @return StaticCall
     */
    private function createRouteGroup(array $routes): StaticCall
    {
        $closure = new Node\Expr\Closure([
            'stmts' => $routes
        ]);
        return new StaticCall(
            new Node\Name('Route'),
            'group',
            [
                new Node\Arg(new Node\Scalar\String_($this->routeGroupPrefix)),
                new Node\Arg($closure)
            ]
        );
    }

    /**
     * 检查路由是否已存在
     */
    private function routeExists(array $ast, array $newRoute): bool
    {
        // 1. 先找到对应的分组
        $targetGroup = $this->nodeFinder->findFirst($ast, function (Node $node) {
            return $this->isRouteGroup($node);
        });
        if (!$targetGroup) {
            return false; // 分组都不存在，路由肯定不存在
        }
        // 2. 获取分组内的所有路由
        $closure = $targetGroup->args[1]->value;
        if (!($closure instanceof Node\Expr\Closure)) {
            return false;
        }
        // 3. 检查分组内是否已存在相同路由
        foreach ($closure->stmts as $stmt) {
            if ($stmt instanceof Expression && $stmt->expr instanceof StaticCall && $this->isSameRoute($stmt->expr, $newRoute)) {
                // 找到相同路由
                return true;
            }
        }
        // 未找到相同路由
        return false;
    }

    /**
     * 检查是否为指定前缀的路由分组
     */
    private function isRouteGroup(Node $node): bool
    {
        if (!$node instanceof StaticCall) {
            return false;
        }
        // 检查是否为 Route::group
        if (
            !($node->class instanceof Node\Name) ||
            $node->class->toString() !== 'Route' ||
            $node->name->name !== 'group'
        ) {
            return false;
        }
        // 检查分组前缀
        $firstArg = $node->args[0] ?? null;
        if ($firstArg && $firstArg->value instanceof Node\Scalar\String_) {
            return trim($firstArg->value->value, '/') === trim($this->routeGroupPrefix, '/');
        }
        return false;
    }

    /**
     * 检查两个路由是否相同
     */
    private function isSameRoute(StaticCall $routeNode, array $newRoute): bool
    {
        // 检查 HTTP 方法
        if ($routeNode->name->name !== strtolower($newRoute['method'])) {
            return false;
        }
        // 检查 URI
        $uriArg = $routeNode->args[0] ?? null;
        if (!$uriArg || !($uriArg->value instanceof Node\Scalar\String_)) {
            return false;
        }
        $existingUri = trim($uriArg->value->value, '/');
        $newUri = trim($newRoute['uri'], '/');

        if ($existingUri !== $newUri) {
            return false;
        }
        // 检查控制器和动作
        $handlerArg = $routeNode->args[1] ?? null;
        if (!$handlerArg || !($handlerArg->value instanceof Node\Expr\Array_)) {
            return false;
        }
        $items = $handlerArg->value->items;
        if (count($items) < 2) {
            return false;
        }
        // 检查控制器类
        $controllerItem = $items[0];
        if ($controllerItem->value instanceof Node\Expr\ClassConstFetch) {
            $existingController = $controllerItem->value->class->toString();
        } elseif ($controllerItem->value instanceof Node\Scalar\String_) {
            $existingController = $controllerItem->value->value;
        } else {
            return false;
        }
        // 检查动作名
        $actionItem = $items[1];
        if (!($actionItem->value instanceof Node\Scalar\String_)) {
            return false;
        }
        $existingAction = $actionItem->value->value;
        // 标准化控制器类名（去除开头的反斜杠）
        $existingController = ltrim($existingController, '\\');
        $newController = ltrim($newRoute['controller'], '\\');

        return $existingController === $newController && $existingAction === $newRoute['action'];
    }

    /**
     * 检查 createRoutes 调用是否已存在
     */
    private function createRoutesExists(array $ast, string $routePath, string $controllerClass): bool
    {
        $existingCalls = $this->nodeFinder->find($ast, function (Node $node) {
            if (!$node instanceof Expression) {
                return false;
            }
            $expr = $node->expr;
            return $expr instanceof Node\Expr\FuncCall && $expr->name instanceof Node\Name && $expr->name->toString() === 'createRoutes';
        });

        foreach ($existingCalls as $call) {
            $funcCall = $call->expr;
            // 检查参数
            $args = $funcCall->args;
            if (count($args) < 2) {
                continue;
            }
            // 检查第一个参数（路由路径）
            $arg1 = $args[0]->value ?? null;
            if (!$arg1 instanceof Node\Scalar\String_) {
                continue;
            }
            $existingPath = $arg1->value;
            // 检查第二个参数（控制器类）
            $arg2 = $args[1]->value ?? null;
            $existingController = '';

            if ($arg2 instanceof Node\Expr\ClassConstFetch) {
                $existingController = $arg2->class->toString();
            }
            // 标准化比较
            $normalizedPath = trim($existingPath, '/');
            $normalizedController = ltrim($existingController, '\\');

            if ($normalizedPath === trim($routePath, '/') &&  $normalizedController === ltrim($controllerClass, '\\')) {
                return true;
            }
        }
        return false;
    }

    /**
     * 查找 Route::options 的位置
     */
    private function findOptionsRoutePosition(array $ast): ?int
    {
        foreach ($ast as $index => $stmt) {
            if ($stmt instanceof Expression && $stmt->expr instanceof StaticCall) {
                $staticCall = $stmt->expr;
                // 检查是否为 Route::options
                if ($staticCall->class instanceof Node\Name && $staticCall->class->toString() === 'Route' && $staticCall->name->name === 'options') {
                    // 检查 URI 是否为 '[{path:.+}]'
                    $uriArg = $staticCall->args[0] ?? null;
                    if ($uriArg && $uriArg->value instanceof Node\Scalar\String_) {
                        $uri = $uriArg->value->value;
                        if ($uri === '[{path:.+}]') {
                            return $index;
                        }
                    }
                }
            }
        }
        return null;
    }

    /**
     * 创建 createRoutes 函数调用节点
     */
    private function createCreateRoutesNode(string $routePath, string $controllerClass): Node\Expr\FuncCall
    {
        // 标准化控制器类名
        $normalizedController = ltrim($controllerClass, '\\');
        return new Node\Expr\FuncCall(
            new Node\Name('createRoutes'),
            [
                new Node\Arg(new Node\Scalar\String_($routePath)),
                new Node\Arg(new Node\Expr\ClassConstFetch(
                    new Node\Name\FullyQualified($normalizedController),
                    'class'
                ))
            ]
        );
    }
}
