# 文件、搜索与代码导航

[返回快捷键索引](../KEYMAPS.md)

## 文件树

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>e` | normal | 切换 nvim-tree |
| `<leader>fe` | normal | 在树中定位当前文件 |
| `<leader>fc` | normal | 折叠所有树节点 |

nvim-tree 内使用其默认键位。常用：

| 快捷键 | 说明 |
| --- | --- |
| `g?` | 查看完整帮助 |
| `<CR>` | 打开文件或目录 |
| `a` | 新建文件或目录 |
| `d` | 删除 |
| `r` | 重命名 |
| `x` / `c` / `p` | 剪切 / 复制 / 粘贴 |
| `R` | 刷新 |

## fzf-lua

文件查找依赖系统 `fzf`，live grep 还依赖 `ripgrep`。fzf-lua 同时接管
`vim.ui.select()`，因此 code action 等选择列表也使用相同界面。

### 文件与内容

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>ff` | normal | 查找 cwd 下的文件 |
| `<leader>fg` | normal | cwd live grep |
| `<leader>fG` | normal | 当前 buffer live grep |
| `<leader>fw` | normal | grep 光标下 word |
| `<leader>fW` | normal | grep 光标下 WORD |
| `<leader>fw` | visual | grep 当前选区 |
| `<leader>fb` | normal | 已打开 buffer |
| `<leader>fr` | normal | 最近文件 |
| `<leader>fl` | normal | 当前 buffer 行 |
| `<leader>fL` | normal | 所有已打开 buffer 的行 |
| `<leader>fh` | normal | Help tags |
| `<leader>fk` | normal | 已注册 keymap |
| `<leader>f:` | normal | 命令历史 |
| `<leader>f/` | normal | 搜索历史 |
| `<leader>f.` | normal | 恢复上一次 picker |

### LSP

| 快捷键 | 说明 |
| --- | --- |
| `<leader>fs` / `<leader>fS` | 文档 / 工作区符号 |
| `<leader>fd` | 定义 |
| `<leader>fR` | 引用 |
| `<leader>fi` | 实现 |
| `<leader>fy` | 类型定义 |
| `<leader>fa` | Code action |
| `<leader>fD` | 工作区诊断 |

### Git picker

| 快捷键 | 说明 |
| --- | --- |
| `<leader>fgs` | Git status |
| `<leader>fgc` | 仓库 commits |
| `<leader>fgC` | 当前 buffer commits |
| `<leader>fgb` | Git branches |

picker 内常用 `<Tab>` 多选、`<C-q>` 把结果送入 quickfix、
`<C-d>/<C-u>` 滚动预览。

## 代码大纲

aerial 优先使用 LSP，随后回退到 Treesitter、Markdown 或 man。

| 快捷键 | 位置 | 说明 |
| --- | --- | --- |
| `<leader>O` | 普通 buffer | 切换大纲侧栏 |
| `<leader>fo` | 普通 buffer | 使用 Aerial Nav 查找当前文件符号 |
| `{` / `}` | aerial 侧栏 | 上 / 下一个符号 |
| `<CR>` | aerial 侧栏 | 跳转到符号 |

## Treesitter 文本对象

`nvim-treesitter-textobjects` 提供基于语法节点的选择和移动。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `af` / `if` | visual / operator-pending | 外 / 内函数 |
| `ac` / `ic` | visual / operator-pending | 外 / 内 class |
| `aa` / `ia` | visual / operator-pending | 外 / 内参数 |
| `]m` / `]M` | normal / visual / operator-pending | 下一个函数开始 / 结束 |
| `[m` / `[M` | normal / visual / operator-pending | 上一个函数开始 / 结束 |

例如 `vif` 选择函数体，`daf` 删除整个函数。

## Treesitter Context

treesitter-context 在窗口顶部显示当前函数、class 或控制流上下文。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `[c` | normal | 跳到外层 Treesitter context |

## 编辑增强

### mini.pairs

插入括号和引号时自动补齐闭合符，没有独立快捷键。

### mini.surround

使用 `gs*` 前缀，避免占用 Flash 的 `s` / `S`。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `gsa{motion}{char}` | normal | 给 motion 范围添加包裹符 |
| `gsa{char}` | visual | 给选区添加包裹符 |
| `gsd{char}` | normal | 删除一层包裹符 |
| `gsr{old}{new}` | normal | 替换包裹符 |
| `gsf{char}` / `gsF{char}` | normal | 查找右 / 左侧包裹符 |
| `gsh{char}` | normal | 高亮当前包裹范围 |
| `gsn` | normal | 临时修改搜索行数上限 |

示例：`gsaiw"` 给当前 word 加双引号，`gsd"` 删除双引号，
`gsr"'` 把双引号替换为单引号。

### mini.ai

mini.ai 扩展 `a` / `i` 文本对象，并与 Treesitter 文本对象共存。

| 文本对象 | 说明 |
| --- | --- |
| `if` / `af` | 内 / 外函数 |
| `ic` / `ac` | 内 / 外 class |
| `io` / `ao` | 内 / 外 block、loop 或 conditional |
| `ia` / `aa` | 内 / 外参数 |
| `ii` / `ai` | 内 / 外缩进 scope |

这些文本对象跟在 visual 或 operator 后使用，例如 `vif`、`dac`、`cii`。

### mini.indentscope

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `[i` / `]i` | normal | 当前缩进 scope 顶 / 底 |
| `ii` / `ai` | visual / operator-pending | 内 / 外缩进 scope |

guess-indent 没有快捷键；它在读取文件后自动检测 buffer 的缩进风格。

## Flash

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `s{char}{char}` | normal / visual / operator-pending | 跳到屏幕内匹配目标 |
| `S` | normal / visual / operator-pending | Treesitter 节点选择 |
| `r` | operator-pending | 远程操作 |
| `R` | operator-pending / visual | Treesitter 搜索 |
| `<C-s>` | command | 切换命令行 Flash 搜索 |

原生 `s`（substitute char）改用 `cl`，原生 `S`（substitute line）改用
`cc`。
