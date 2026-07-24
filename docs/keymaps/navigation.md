# 文件、搜索与代码导航

[返回快捷键索引](../KEYMAPS.md)

## 文件树

`<leader>e` 打开 snacks explorer（picker 侧栏）。`<leader>fe` 在树中定位当前
文件。折叠全部节点在 explorer 内用 `Z`（不再单独映射 `<leader>fc`）。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>e` | normal | 切换 snacks explorer |
| `<leader>fe` | normal | 在树中定位当前文件 |

explorer 内常用键位（完整见 snacks explorer 文档）：

| 快捷键 | 说明 |
| --- | --- |
| `<CR>` / `l` | 打开文件或展开目录 |
| `h` | 折叠目录 |
| `a` | 新建文件或目录（目录以 `/` 结尾） |
| `d` | 删除 |
| `r` | 重命名 |
| `m` / `c` | 移动 / 复制选中项到当前目录 |
| `y` / `p` | yank 路径 / 粘贴 |
| `H` / `I` | 切换隐藏 / ignore 文件 |
| `Z` | 折叠所有目录 |
| `<C-/>` | 在当前目录 grep |

## snacks picker

文件查找与 live grep 依赖系统 `ripgrep`（及可选 `fd`）。snacks picker 同时
接管 `vim.ui.select()`，因此 code action 等选择列表也使用相同界面。

### 文件与内容

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>ff` | normal | 查找 cwd 下的文件 |
| `<leader>fg` | normal | cwd live grep |
| `<leader>fG` | normal | 已打开 buffer grep |
| `<leader>fw` | normal / visual | grep 光标下 word 或选区 |
| `<leader>fW` | normal | grep 光标下 WORD |
| `<leader>fb` | normal | 已打开 buffer |
| `<leader>fr` | normal | 最近文件 |
| `<leader>fl` | normal | 当前 buffer 行 |
| `<leader>fL` | normal | 所有已打开 buffer 的行 / grep |
| `<leader>fh` | normal | Help tags |
| `<leader>fk` | normal | 已注册 keymap |
| `<leader>f:` | normal | 命令历史 |
| `<leader>f/` | normal | 搜索历史 |
| `<leader>f.` | normal | 恢复上一次 picker |

`<leader>fg` 是 live grep，不要注册 which-key 的 `fg` 分组（会把它显示成
Find: git 并挡住 grep）。Git picker 键以 `fg` 为前缀（见下），需在
`timeoutlen` 内继续输入第四键，否则触发 grep。

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

## 代码大纲

aerial 优先使用 LSP，随后回退到 Treesitter、Markdown 或 man。

| 快捷键 | 位置 | 说明 |
| --- | --- | --- |
| `<leader>O` | 普通 buffer | 切换大纲侧栏 |
| `<leader>fo` | 普通 buffer | Aerial Nav 查找当前文件符号 |
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

这些文本对象跟在 visual 或 operator 后使用，例如 `vif`、`dac`。

### snacks.indent / snacks.scope

缩进线由 snacks.indent 绘制；scope 文本对象与跳转由 snacks.scope 提供
（替代 mini.indentscope）。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `[i` / `]i` | normal | 当前缩进 scope 顶 / 底 |
| `ii` / `ai` | visual / operator-pending | 内 / 外缩进 scope |

### snacks.words

LSP 引用高亮与跳转：

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `]]` / `[[` | normal / terminal | 下 / 上一个 LSP 引用 |

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
