# 快捷键速查

`<leader>` = `Space`。所有快捷键都在源文件中以 `desc =` 标注，导航弹窗（`which-key.nvim`）会自动展示。

> **提示**：按下 `<leader>` 后停顿约 200ms 即弹出按键导航（LazyVim 风格）。也可用于其他前缀（如 `g`、`[`、`]`）。
>
> 配置概览见 [README.md](README.md)；项目长期上下文（架构决策、扩展计划）见 [AGENTS.md](AGENTS.md)。

## 目录

- [Leader 分组速查](#leader-分组速查)
- [通用 / 窗口](#通用--窗口)
- [分屏导航（smart-splits）](#分屏导航smart-splits)
- [诊断（全局）](#诊断全局)
- [文件树（nvim-tree）](#文件树nvim-tree)
- [LSP（buffer 级）](#lspbuffer-级)
- [代码格式化（conform.nvim）](#代码格式化conformnvim)
- [调试（nvim-dap）](#调试nvim-dap)
- [Git（gitsigns.nvim）](#gitgitsignsnvim)
- [Lazygit（kdheepak/lazygit.nvim）](#lazygitkdheepaklazygitnvim)
- [模糊查找（fzf-lua）](#模糊查找fzf-lua)
- [Trouble（trouble.nvim）](#troubletroublenvim)
- [TODO 注释（todo-comments.nvim）](#todo-注释todo-commentsnvim)
- [终端（toggleterm.nvim）](#终端toggletermnvim)
- [会话（resession.nvim）](#会话resessionnvim)
- [Bufferline（akinsho/bufferline.nvim）](#bufferlineakinshobufferlinenvim)
- [状态栏（lualine.nvim）](#状态栏lualinenvim)
- [代码大纲（aerial.nvim）](#代码大纲aerialnvim)
- [Treesitter 文本对象 + 上下文](#treesitter-文本对象--上下文)
- [编辑增强（mini.pairs / mini.surround / mini.ai / mini.indentscope / guess-indent）](#编辑增强minipairs--minisurround--miniai--miniindentscope--guess-indent)
- [跳转动作（flash.nvim）](#跳转动作flashnvim)

## Leader 分组速查

| 前缀 | 含义 | 关键键 |
| --- | --- | --- |
| `<leader>b` | Buffer | `bd/bo/br/bl/bp/bP` 关闭/管理；`<leader>1..9` 跳第 N 个 buffer |
| `<leader>c` | Code / Diagnostics | `ca` code action、`cs/cw` 符号、`ci/co` 调用链、`ch` inlay hint、`cd/cl` 诊断 |
| `<leader>d` | Debug | `db/dB/dl` 断点、`dc` 跑到光标、`dr` REPL、`dt` 终止、`du` UI、`de` 求值 |
| `<leader>f` | File / Find / Format | `ff/fg/fb/fr/fh` fzf-lua、`fs/fS/fd/fR` LSP picker、`fgs/fgc/fgb` 嵌套 git picker、`ft` TODO 搜索、`fm` 格式化、`fe` 树中定位、`fc` 折叠树 |
| `<leader>g` | Git | `gg` lazygit、`gp` 预览、`gs/gr` stage/reset、`gb/gB` blame、`gd/gD` diff |
| `<leader>r` | Refactor | `rn` 重命名 |
| `<leader>x` | Trouble | `xx/xX` 工作区/buffer 诊断、`xs` 符号、`xl` LSP 引用、`xq` quickfix、`xt` TODO |
| `<leader>S` | Session | `Ss` 命名保存、`Sl/SL` 加载、`Sd` 删除 |
| `<leader>t` | Terminal | `tf/th/tv/tt/tn` 浮窗/水平/垂直/默认/选择终端 |
| `<leader>O` | Outline (单键 toggle) | aerial 代码大纲侧栏 |
| `<leader><leader>h/j/k/l` | Swap window | smart-splits 交换窗口位置 |
| `<leader>w` / `q` / `Q` | Save / Quit / Force quit all | — |
| `<leader>y` / `Y` / `p` | 系统剪贴板 yank / paste | — |

## 通用 / 窗口

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>w` | n | 保存当前文件 |
| `<leader>q` | n | 关闭当前窗口 |
| `<leader>Q` | n | 强制退出全部 |
| `<esc>` | n | 清除搜索高亮 |
| `<C-h/j/k/l>` | n | 在窗口间切换（被 smart-splits 接管，可跨 tmux/wezterm/kitty 边界） |
| `<C-Up/Down/Left/Right>` | n | 调整窗口大小（原生） |
| `<S-l>` / `<S-h>` | n | 下一个 / 上一个 buffer |
| `<leader>bd` | n | 删除当前 buffer |
| `<` / `>` | v | 缩进并保持选中 |
| `J` / `K` | v | 上下移动选中行 |
| `<C-f>` / `<C-b>` | n/x | 平滑整页向下 / 向上翻页 |
| `<C-d>` / `<C-u>` | n/x | 平滑半页向下 / 向上翻页 |
| `n` / `N` | n | 搜索下一/上一并居中 |
| `<leader>y` / `<leader>Y` / `<leader>p` | n/v | 与系统剪贴板 yank / paste |

## 分屏导航（smart-splits）

`<C-h/j/k/l>` 由 `smart-splits.nvim` 接管：在 nvim 分屏边缘碰到 tmux / wezterm / kitty 的 pane 时，可以无缝跳过去；不在复用器里则等价于原生 `<C-w>h/j/k/l`。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-h/j/k/l>` | n | 跨 nvim 分屏 + 终端复用器 pane 移动光标 |
| `<M-h/j/k/l>` | n | 调整分屏大小（默认 3 列/3 行；按住 alt 反复按） |
| `<leader><leader>h/j/k/l` | n | 与目标方向的分屏交换 buffer |

## 诊断（全局）

| 快捷键 | 说明 |
| --- | --- |
| `[d` / `]d` | 上 / 下一条诊断 |
| `<leader>cd` | 当前行诊断浮窗 |
| `<leader>cl` | 把诊断送到 location list |

## 文件树（nvim-tree）

| 快捷键 | 说明 |
| --- | --- |
| `<leader>e` | 切换文件树 |
| `<leader>fe` | 在树中定位当前文件 |
| `<leader>fc` | 折叠所有节点 |

文件树内部使用 nvim-tree 默认按键（按 `g?` 查看），常用：`a` 新建、`d` 删除、`r` 改名、`x` 剪切、`c` 复制、`p` 粘贴、`R` 刷新。

## LSP（buffer 级）

仅在 LSP 附着时生效（需求 2）。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `gd` | n | 跳转到定义 |
| `gD` | n | 跳转到声明 |
| `gr` | n | 引用列表 |
| `gi` | n | 跳转到实现 |
| `gy` | n | 跳转到类型定义 |
| `K` | n | Hover 文档 |
| `<C-k>` | i / n | 函数签名 |
| `<leader>rn` | n | 重命名符号 |
| `<leader>ca` | n / v | Code action |
| `<leader>cs` | n | 文档符号 |
| `<leader>cw` | n | 工作区符号 |
| `<leader>ci` / `<leader>co` | n | 调用层级（incoming / outgoing） |
| `<leader>ch` | n | 切换 inlay hints |

## 代码格式化（conform.nvim）

需求 4。**默认不在保存时自动格式化**（需求 10）。

| 快捷键 / 命令 | 说明 |
| --- | --- |
| `<leader>fm` | 手动格式化当前 buffer / 选区 |
| `:FormatEnable` | 当前会话开启保存自动格式化 |
| `:FormatDisable` | 关闭保存自动格式化 |

格式化器映射：C/C++ → `clang-format`、Rust → `rustfmt`、Lua → `stylua`（可选）。

## 调试（nvim-dap）

需求 3。

| 快捷键 | 说明 |
| --- | --- |
| `<F5>` | 继续 / 启动会话 |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | 切换断点 |
| `<leader>dB` | 条件断点（输入条件） |
| `<leader>dl` | Log point（输入日志） |
| `<leader>dc` | 运行到光标处 |
| `<leader>dr` | 切换 REPL |
| `<leader>dt` | 终止会话 |
| `<leader>du` | 切换 dap-ui |
| `<leader>de` | 求值表达式（visual / 当前光标） |

启动会话时会要求输入可执行文件路径；C++ / Rust 都基于 `codelldb`，请先确保 `codelldb` 在 `PATH` 上。

## Git（gitsigns.nvim）

需求 8。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `]g` / `[g` | n | 下 / 上一 hunk |
| `<leader>gp` | n | 预览 hunk |
| `<leader>gs` | n / v | Stage hunk |
| `<leader>gr` | n / v | Reset hunk |
| `<leader>gS` | n | Stage 当前 buffer |
| `<leader>gR` | n | Reset 当前 buffer |
| `<leader>gu` | n | 撤销 stage hunk |
| `<leader>gb` | n | 当前行完整 blame |
| `<leader>gB` | n | 切换内联 blame |
| `<leader>gd` | n | 与索引 diff |
| `<leader>gD` | n | 与最后一次提交 diff |
| `ih` | o / x | "一个 hunk" 文本对象 |

## Lazygit（kdheepak/lazygit.nvim）

在 Neovim 浮窗里直接调起系统 `lazygit`，覆盖 `gitsigns` 不管的所有「整仓库级 git 操作」（commit / 交互式 rebase / cherry-pick / 分支管理 / merge conflict / stash / push / pull）。**依赖**：系统 PATH 上要有 `lazygit` 二进制；如果没装，下面这些 keymap 会在启动时静默注销并打印一条警告，不会影响其它功能。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>gg` | Lazygit（仓库根） |
| `<leader>gG` | Lazygit（当前文件所在仓库） |
| `<leader>gl` | Lazygit log（仓库级） |
| `<leader>gL` | Lazygit log（当前文件） |

> Lazygit 自身的快捷键参见 [lazygit 官方 cheatsheet](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md)。常用：`c` commit、`a` stage all、`r` rebase、`b` branches、`P` push、`p` pull。

## 模糊查找（fzf-lua）

C 后端的模糊查找器，依赖系统 `fzf` 与 `ripgrep`（live grep）。已注册成 `vim.ui.select` 的实现，所以 `vim.lsp.buf.code_action` 等弹窗也走 fzf 风格。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>ff` | 项目内文件（cwd 递归） |
| `<leader>fg` | Live grep（cwd） |
| `<leader>fG` | Live grep（当前 buffer） |
| `<leader>fw` / `<leader>fW` | grep 光标下 word / WORD |
| `<leader>fw` (visual) | grep 当前选区 |
| `<leader>fb` | 已打开 buffer 列表 |
| `<leader>fr` | 最近文件（oldfiles） |
| `<leader>fl` / `<leader>fL` | 当前 buffer 行 / 全部 buffer 行 |
| `<leader>fh` / `<leader>fk` | 帮助 tags / keymaps |
| `<leader>f:` / `<leader>f/` | 命令历史 / 搜索历史 |
| `<leader>fs` / `<leader>fS` | LSP 文档 / 工作区符号 |
| `<leader>fd` / `<leader>fR` / `<leader>fi` / `<leader>fy` | LSP 定义 / 引用 / 实现 / 类型定义 |
| `<leader>fa` | LSP code actions（fzf 风格） |
| `<leader>fD` | 工作区诊断列表 |
| `<leader>fgs` / `<leader>fgc` / `<leader>fgC` / `<leader>fgb` | git status / commits / buffer commits / branches |
| `<leader>fo` | 当前文件大纲（aerial nav） |
| `<leader>f.` | 恢复上一次 picker（误关后救命） |

> picker 内部按键：`<C-q>` 把所有结果送 quickfix；`<Tab>` 多选；`<C-d>/<C-u>` 半页滚动预览。

## Trouble（trouble.nvim）

v3 API 的诊断 / LSP 引用 / quickfix 列表统一 UI。所有 `<leader>x*` 都是 toggle，按一次打开按一次关。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>xx` | 工作区诊断 |
| `<leader>xX` | 当前 buffer 诊断 |
| `<leader>xs` | 文档符号（LSP） |
| `<leader>xl` | LSP 定义 / 引用 / 实现 |
| `<leader>xL` | location list |
| `<leader>xq` | quickfix list |
| `<leader>xt` | TODO 注释（todo-comments 集成） |
| `]x` / `[x` | 在 Trouble 列表内或当前 buffer 诊断间下/上跳 |

> Trouble 窗口内：`<CR>` 跳到位置；`o` / `<C-x>` / `<C-v>` / `<C-t>` 打开/水平/垂直/新 tab；`q` 关闭；`?` 看完整帮助。

## TODO 注释（todo-comments.nvim）

自动高亮 `TODO` / `FIXME` / `HACK` / `WARN` / `PERF` / `NOTE` / `TEST` 等关键词。

| 快捷键 | 说明 |
| --- | --- |
| `]t` / `[t` | 下 / 上一个 TODO 注释 |
| `<leader>ft` | fzf-lua live grep 全工作区的 TODO/FIXME/... |
| `<leader>xt` | 用 Trouble UI 列出所有 TODO（来自 trouble.nvim） |

## 终端（toggleterm.nvim）

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-\>` | n / t | 切换默认终端（上次使用的方向） |
| `<leader>tf` | n / t | 浮窗终端（持久实例） |
| `<leader>th` | n / t | 水平分屏终端（持久实例） |
| `<leader>tv` | n / t | 垂直分屏终端（持久实例） |
| `<leader>tt` | n / t | toggle 默认终端 |
| `<leader>tn` | n | 多实例选择器 |
| `<esc>` / `jk` | t | 从 terminal 模式退到 normal 模式 |
| `<C-h/j/k/l>` | t | 在终端 buffer 内跨窗口移动 |

> Windows 上若有 pwsh，已在 `lua/core/options.lua` 配好 UTF-8，toggleterm 自动继承。

## 会话（resession.nvim）

会话名按 `cwd@branch` 自动生成（git 分支隔离）；`VimLeavePre` 自动保存，`VimEnter`（无文件参数时）自动恢复。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>Ss` | 命名保存当前会话（默认 = `cwd@branch`） |
| `<leader>Sl` | 模糊选择已保存的会话来加载 |
| `<leader>SL` | 加载当前 cwd@branch 的自动会话 |
| `<leader>Sa` | 加载自动会话但不绑定（之后改动不会写回） |
| `<leader>Sd` | 删除会话 |

## Bufferline（akinsho/bufferline.nvim）

可视化 `<S-h>` / `<S-l>` 切换；与 nvim-tree、aerial 自动留出 offset。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>1` ... `<leader>9` | 跳到第 N 个 buffer |
| `<leader>bp` | 切换 pin（pin 后位置固定，不被自动排序打乱） |
| `<leader>bP` | 关闭所有未 pin 的 buffer |
| `<leader>bo` | 关闭其它 buffer |
| `<leader>br` / `<leader>bl` | 关闭右侧 / 左侧的 buffer |

## 状态栏（lualine.nvim）

底部状态栏，无 keymap。展示：mode / git 分支 / git diff 计数 / 文件名 + 修改标记 / 诊断计数 / DAP 状态（调试时） / LSP client 名 / 编码 / 文件类型 / 进度 / 行列。`globalstatus = true`，所有窗口共用一条；nvim-tree、aerial、dap-ui 等侧栏会被排除。

## 代码大纲（aerial.nvim）

右侧符号侧栏，按 LSP → Treesitter → markdown → man 顺序选择 backend，clangd / rust-analyzer 一挂载就有内容。

| 快捷键 | 说明 |
| --- | --- |
| `<leader>O` | 切换大纲侧栏 |
| `<leader>fo` | fzf-lua 风格在大纲里模糊跳（aerial nav） |
| `{` / `}`（侧栏内） | 上 / 下一个符号 |
| `<CR>`（侧栏内）| 跳到光标处的符号 |

## Treesitter 文本对象 + 上下文

`nvim-treesitter-textobjects` 提供精准到 TS 语法节点的 motion / textobject。在 visual / operator-pending 模式下用：

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `af` / `if` | x / o | 一个函数 / 函数体 |
| `ac` / `ic` | x / o | 一个 class / class 体 |
| `aa` / `ia` | x / o | 一个参数 / 参数内（含/不含逗号空格） |
| `]m` / `]M` | n / x / o | 下一个函数开始 / 结束 |
| `[m` / `[M` | n / x / o | 上一个函数开始 / 结束 |

`treesitter-context` 在长函数 / 循环里滚动时，会在窗口顶部粘性显示当前所在的函数签名 / 类名 / 条件分支头：

| 快捷键 | 说明 |
| --- | --- |
| `[c` | 跳到外层 treesitter context（函数 / class / for / while 头） |

## 编辑增强（mini.pairs / mini.surround / mini.ai / mini.indentscope / guess-indent）

- **mini.pairs**：自动补全 `( { [ " ' \``` 闭合符；遇到下一个字符是字母数字时不会画蛇添足。
- **mini.surround**：使用 `gs*` 前缀（避开和 flash 的 `s/S` 冲突）。

  | 快捷键 | 说明 |
  | --- | --- |
  | `gsa{motion}{char}` | 在 motion 范围外加上 `char` 包裹符（visual 下：`gsa{char}`） |
  | `gsd{char}` | 删掉一层 `char` 包裹 |
  | `gsr{char_old}{char_new}` | 把外层 `char_old` 替换成 `char_new` |
  | `gsf{char}` / `gsF{char}` | 跳到右 / 左侧最近的 `char` 包裹 |
  | `gsh{char}` | 高亮当前层 `char` 包裹 |
  | `gsn` | 临时改变搜索行数上限 |

  例：`gsaiw"` 给当前 word 加双引号；`gsd"` 删一层双引号；`gsr"'` 把外层双引号换成单引号。

- **mini.ai**：扩展 `a` / `i` 文本对象，把 TS 节点也纳入；与上一节的 `treesitter-textobjects` 配合（mini.ai 给人体工学 key，TS objects 提供精准边界）。常用：

  | 快捷键 | 模式 | 说明 |
  | --- | --- | --- |
  | `vif` / `vaf` | x / o | 内 / 外函数（同时可用 TS 文本对象 `if` / `af`） |
  | `vic` / `vac` | x / o | 内 / 外 class |
  | `vio` / `vao` | x / o | 内 / 外 block / loop / conditional |
  | `via` / `vaa` | x / o | 内 / 外参数（mini.ai 风格的启发式） |
  | `vii` / `vai` | x / o | 内 / 外缩进 scope（来自 mini.indentscope） |

- **mini.indentscope**：用细线高亮当前光标的缩进 scope；并提供文本对象 / 跳转：

  | 快捷键 | 模式 | 说明 |
  | --- | --- | --- |
  | `[i` / `]i` | n | 跳到当前缩进 scope 顶 / 底 |
  | `ii` / `ai` | x / o | 内 / 外缩进 scope（同上）|

- **guess-indent**：每次 `BufReadPost` 自动检测缩进风格（tab / 2 空格 / 4 空格）并设置 buffer 局部 `expandtab` / `shiftwidth` / `tabstop`，**不修改全局 `vim.opt`**。多项目协作时不再被陌生缩进绊倒。

## 跳转动作（flash.nvim）

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `s{char}{char}` | n / x / o | 屏幕内任意位置精准跳转（输入两个字符 + 标签） |
| `S` | n / x / o | Treesitter 节点选择（按 j/k 扩缩，回车确认） |
| `r` | o | 远程操作（在另一处 motion 后回到原位） |
| `R` | o / x | Treesitter 风格搜索 |
| `<C-s>` | c | 在 `:s` / `:g` 等命令模式下切换 flash search |

> 原本的 `s` (substitute char) 改用 `cl` 替代；`S` (substitute line) 改用 `cc`。
