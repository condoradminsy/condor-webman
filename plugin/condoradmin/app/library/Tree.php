<?php

namespace plugin\condoradmin\app\library;


class Tree
{

    /**
     * 生成树型结构所需要的2维数组
     * @var array
     */
    public $arr = [];
    public $pidname = 'pid';

    /**
     * 初始化方法
     * @param string $pidname 父字段名称
     * @return Tree
     */
    public function init($arr = [])
    {
        $this->arr = $arr;
        return $this;
    }

    /**
     * 得到子级数组
     * @param int
     * @return array
     */
    public function getChild($myid)
    {
        $newarr = [];
        foreach ($this->arr as $value) {
            if (!isset($value['id'])) {
                continue;
            }
            if ($value[$this->pidname] == $myid) {
                $newarr[$value['id']] = $value;
            }
        }
        return $newarr;
    }

    /**
     * 读取指定节点的所有孩子节点
     * @param int     $myid     节点ID
     * @param boolean $withself 是否包含自身
     * @return array
     */
    public function getChildren($myid, $withself = false)
    {
        $newarr = [];
        foreach ($this->arr as $value) {
            if (!isset($value['id'])) {
                continue;
            }
            if ((string)$value[$this->pidname] == (string)$myid) {
                $newarr[] = $value;
                $newarr = array_merge($newarr, $this->getChildren($value['id']));
            } elseif ($withself && (string)$value['id'] == (string)$myid) {
                $newarr[] = $value;
            }
        }
        return $newarr;
    }

    /**
     * 读取指定节点的所有孩子节点ID
     * @param int     $myid     节点ID
     * @param boolean $withself 是否包含自身
     * @return array
     */
    public function getChildrenIds($myid, $withself = false)
    {
        $childrenlist = $this->getChildren($myid, $withself);
        $childrenids = [];
        foreach ($childrenlist as $v) {
            $childrenids[] = $v['id'];
        }
        return $childrenids;
    }

    /**
     * 得到当前位置父辈数组
     * @param int
     * @return array
     */
    public function getParent($myid)
    {
        $pid = 0;
        $newarr = [];
        foreach ($this->arr as $value) {
            if (!isset($value['id'])) {
                continue;
            }
            if ($value['id'] == $myid) {
                $pid = $value[$this->pidname];
                break;
            }
        }
        if ($pid) {
            foreach ($this->arr as $value) {
                if ($value['id'] == $pid) {
                    $newarr[] = $value;
                    break;
                }
            }
        }
        return $newarr;
    }

    /**
     * 得到当前位置所有父辈数组
     * @param int
     * @param bool $withself 是否包含自己
     * @return array
     */
    public function getParents($myid, $withself = false)
    {
        $pid = 0;
        $newarr = [];
        foreach ($this->arr as $value) {
            if (!isset($value['id'])) {
                continue;
            }
            if ($value['id'] == $myid) {
                if ($withself) {
                    $newarr[] = $value;
                }
                $pid = $value[$this->pidname];
                break;
            }
        }
        if ($pid) {
            $arr = $this->getParents($pid, true);
            $newarr = array_merge($arr, $newarr);
        }
        return $newarr;
    }

    /**
     * 读取指定节点所有父类节点ID
     * @param int     $myid
     * @param boolean $withself
     * @return array
     */
    public function getParentsIds($myid, $withself = false)
    {
        $parentlist = $this->getParents($myid, $withself);
        $parentsids = [];
        foreach ($parentlist as $v) {
            $parentsids[] = $v['id'];
        }
        return $parentsids;
    }

    /**
     *
     * 获取树状数组
     * @param string $myid  要查询的ID
     * @param string $itemprefix 前缀
     * @return array
     */
    public function getTreeArray($myid)
    {
        $childs = $this->getChild($myid);
        $n = 0;
        $data = [];
        $number = 1;
        if ($childs) {
            foreach ($childs as $id => $value) {
                $data[$n] = $value;
                $data[$n]['childlist'] = $this->getTreeArray($id);
                $n++;
                $number++;
            }
        }
        return $data;
    }

    /**
     * 将getTreeArray的结果返回为二维数组
     * @param array  $data
     * @param string $field
     * @return array
     */
    public function getTreeList($data = [], $field = 'name')
    {
        $arr = [];
        foreach ($data as $v) {
            $childlist = $v['childlist'] ?? [];
            unset($v['childlist']);
            $v['haschild'] = $childlist ? 1 : 0;
            if ($v['id']) {
                $arr[] = $v;
            }
            if ($childlist) {
                $arr = array_merge($arr, $this->getTreeList($childlist, $field));
            }
        }
        return $arr;
    }

    /**
     * 数据树形化
     * @param array $data 数据
     * @param string $childrenname 子数据名
     * @param string $keyName 数据key名
     * @param string $pidName 数据上级key名
     * @return array
     */
    public static function makeTree(array $data, string $childrenname = 'children', string $keyName = 'id', string $pidName = 'pid')
    {
        $list = [];
        foreach ($data as $value) {
            $list[$value[$keyName]] = $value;
        }
        $tree = []; //格式化好的树
        foreach ($list as $item) {
            if (isset($list[$item[$pidName]])) {
                $list[$item[$pidName]][$childrenname][] = &$list[$item[$keyName]];
            } else {
                $tree[] = &$list[$item[$keyName]];
            }
        }
        return $tree;
    }

    /**
     * 生成Arco菜单
     * @param array $data 数据
     * @param string $childrenname 子数据名
     * @param string $keyName 数据key名
     * @param string $pidName 数据上级key名
     * @return array
     */
    public static function makeArcoMenus(array $data, string $childrenname = 'children', string $keyName = 'id', string $pidName = 'pid')
    {
        //  "name": "System1",
        // "path": "/system",
        // "hidden": false,
        // "redirect": "noRedirect",
        // "component": "Layout",
        // "alwaysShow": true,
        // "meta": {
        //     "title": "route.system",
        //     "icon": "carbon:cloud-service-management",
        //     "noCache": false,
        //     "link": null,
        //     "activeMenu": null
        // },

        $list = [];
        foreach ($data as $value) {
            $temp = [
                $keyName => $value[$keyName],
                $pidName => $value[$pidName],
                'name' => $value['name'],
                'path' => $value['path'],
                'component' => $value['component'],
                'redirect' => $value['redirect'],
                'meta' => [
                    'hideInMenu' => $value['hidden'] === 1,
                    'title' => $value['title'],
                    'icon' => $value['icon'],
                    'keepAlive' => $value['is_keep'] === 1,
                    'activeMenu' => $value['active_menu'] === 1,
                    'i18nKey' => $value['i18nKey'],
                    'multiTab' => $value['multi_tab'] === 1,
                    'href' => $value['href'],
                    'fixedIndexInTab' => $value['fixed_tab_index'],
                    'order' => $value['weigh']
                ],
            ];
            $list[$value[$keyName]] = $temp;
        }
        $tree = []; //格式化好的树
        foreach ($list as $item) {
            if (isset($list[$item[$pidName]])) {
                $list[$item[$pidName]][$childrenname][] = &$list[$item[$keyName]];
            } else {
                $tree[] = &$list[$item[$keyName]];
            }
        }
        return $tree;
    }
}
