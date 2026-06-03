# AGENTS.md

> 这份文档是给 AI 编码助手（Cursor / Codex / Claude Code 等）阅读的项目长期上下文。
> 用户向人类讲解的内容请放在 [README.md](README.md)。

## 项目背景

这是个人 Neovim 配置仓库，目标 Neovim 版本 **≥ 0.12**。

- **主要使用平台**：Linux / macOS（生产）
- **次要使用平台**：Windows（当前开发机，配置必须能在三平台都启动且功能可用）
- **仓库路径约定**：
  - Linux / macOS：`~/.config/nvim`
  - Windows：`%LOCALAPPDATA%\nvim`（即 `C:\Users\<user>\AppData\Local\nvim`）
- 配置当前在 Windows 上 clone 到 `D:\nvim\config\nvim` 进行编辑，但实际运行环境以 Linux/Mac 为主。

## 原始需求清单（不可改动，务必逐项满足）

来自用户最初对话，按编号保留：

0. 主要支持 Linux / macOS，同时兼容 Windows
1. 默认代码缩进、空格缩进等基础配置项
2. LSP 支持：C++（clangd）、Rust（rust-analyzer）；要有补全、跳转、悬停、重构
3. 上述语言的调试器
4. 上述语言的格式化：C++ → `clang-format`，Rust → `rustfmt`
5. 上述语言的静态分析：C++ → `clang-tidy`，Rust → `clippy`
6. 语法高亮（Treesitter；用户曾担心 0.12 支持不好——已在架构中澄清）
7. 默认主题 `AlexvZyl/nordic.nvim`
8. Git 支持
9. 文件目录支持（文件树）
10. **保存文件时自动格式化必须默认关闭**
11. 目录结构清晰，各功能独立成文件，不要堆在 init.lua
12. 必要快捷键写入 [README.md](README.md)（实际落地时为可读性已抽到独立的 [KEYMAPS.md](KEYMAPS.md)，README 里保留 Leader 分组总览 + 链接，需求语义不变）

## 关键架构决策

| 维度 | 选型 | 理由 |
| --- | --- | --- |
| 插件管理器 | Neovim 0.12 内置 `vim.pack` | 用户明确选择；与 0.12 风格统一；不需要 lazy loading |
| 补全 | `saghen/blink.cmp`（^1.0.0） | 用户明确选择；自动下载预编译 Rust fuzzy matcher，无需 cargo |
| LSP 配置层 | 原生 `vim.lsp.config()` + `vim.lsp.enable()`；server 配置放 `lsp/<name>.lua` | 仅两个 server，原生 API 已足够；**不引入 `nvim-lspconfig`** |
| 语法高亮 | `nvim-treesitter` **main 分支**（master 已冻结） | main 才适配 0.12；高亮通过 `FileType` autocmd → `vim.treesitter.start()` 启用 |
| 格式化 | `stevearc/conform.nvim` | 默认**不**启用 `format_on_save`（需求 10）；提供 `:FormatEnable/Disable` 切换 |
| 静态分析 | **不另装 linter 插件** | clangd 内置 `--clang-tidy`；rust-analyzer `check.command = 'clippy'` 即可 |
| 调试 | `nvim-dap` + `nvim-dap-ui` + `nvim-dap-virtual-text` + `codelldb`（C/C++/Rust 共用） | codelldb 是 LLDB 桥，覆盖 C/C++/Rust |
| Git | `lewis6991/gitsigns.nvim` | hunk 导航 / stage / blame 一体化 |
| 文件树 | `nvim-tree/nvim-tree.lua` | 经典侧栏，跨平台稳定；同时禁用 netrw |
| 主题 | `AlexvZyl/nordic.nvim` | 用户指定 |
| 平滑滚动 | `karb94/neoscroll.nvim` | 单功能插件；实现 `<C-f>/<C-b>/<C-d>/<C-u>` 翻页动画，避免引入 `snacks.nvim` |
| 快捷键导航 | `folke/which-key.nvim`（^3.0.0） | 用户要求 LazyVim 风格 leader 弹窗；所有 keymap 已带 `desc=`，分组只需在 `whichkey.lua` 顶层声明 |
| Leader | `<Space>` |  |

### 重要的"隐式知识"，agent 后续修改时要记住

1. **`vim.pack` 限制**：不支持 lazy loading；不会自动调 `setup()`；锁文件路径在 `stdpath('config')/nvim-pack-lock.json`，应纳入 git。所有插件加载都在启动时同步进行。
2. **nvim-treesitter main 分支的破坏性变更**：
   - `nvim-treesitter.configs` 模块**不存在**，不要写 `require('nvim-treesitter.configs').setup(...)`
   - 没有 `ensure_installed` 选项，要用 `require('nvim-treesitter').install({...})`
   - 不会自动启用 highlight / fold / indent，必须用 `FileType` autocmd 手动启用
   - 系统需要 `tree-sitter-cli ≥ 0.26` 与 C 编译器（Linux: gcc / Windows: MSVC 或 zig）
   - **不要在启动时调用 `ts.install(...)`**：每次调用都会 `git clone` 到 `%TEMP%\nvim\<lang>-tmp\` 再 rename，Windows 上与 AV / Defender / Explorer 索引器竞争频繁触发 EPERM。统一通过 `:TsEnsure`（只装缺的）和 `:TsUpdate`（升级）由用户手动触发。`ensure_installed` 列表写在 `lua/plugins/treesitter.lua` 顶部，新增语言后让用户跑一次 `:TsEnsure` 即可。
3. **Neovim 0.11+ LSP 约定**：`lsp/<server>.lua` 返回的 table 会被 `vim.lsp.enable({server})` 自动加载并合并到 `vim.lsp.config(server, ...)`。这是约定路径，**不要改名**。
4. **跨平台路径**：尽量用 `vim.fs.joinpath(vim.fn.stdpath('data'), ...)`，不要硬编码 `/` 或 `\`。
5. **Windows 注意事项**：
   - codelldb 在 Windows 上是 `codelldb.cmd` / `codelldb.exe`，需要把 `extension/adapter/` 加进 `PATH`
   - `dap.adapters.codelldb.executable.detached` 在 Windows 必须设为 `false`，否则会留下游离 cmd 窗口（已处理）
   - PowerShell 7+（pwsh）作为 shell 时已在 `lua/core/options.lua` 配好 UTF-8
6. **blink.cmp 与 LSP 集成**：在 `lua/plugins/lsp.lua` 已通过 `blink.get_lsp_capabilities()` 注入 capabilities，agent 修改时不要忘记保留这步。
7. **格式化"默认关闭"的实现方式**：通过 `vim.g.user_format_on_save = false` 与 `BufWritePre` autocmd 实现可运行时切换；**不要**改为 `conform.setup({ format_on_save = ... })`，因为那会丢掉运行时切换能力。
8. **which-key 的分组声明**：所有 keymap 用 `{ desc = '...' }` 写描述就够了，which-key 自动读取。**新增一个 `<leader>X` 前缀**（X 是字母）时，去 `lua/plugins/whichkey.lua` 的 `wk.add({...})` 里加一行 `{ '<leader>X', group = 'XxxName' }`，否则弹窗里那个分组没标题。
9. **平滑滚动**：`<C-f>/<C-b>/<C-d>/<C-u>` 由 `lua/plugins/scroll.lua` 的 neoscroll 接管；不要在 `lua/core/keymaps.lua` 里重复绑定这些键。

## 目录结构（实现完成）

```
nvim/
├── init.lua                         # 入口；只 set leader + require
├── AGENTS.md                        # 本文件
├── README.md                        # 给人类看：依赖安装 + 排错入口
├── KEYMAPS.md                       # 完整快捷键速查表（独立维护，避免 README 过长）
├── lua/
│   ├── core/
│   │   ├── options.lua              # vim.opt 选项（缩进/UI/折叠/Win pwsh 适配）
│   │   ├── keymaps.lua              # 通用 keymap（与插件无关）
│   │   └── autocmds.lua             # 通用 autocmd（yank 高亮、自动建目录、记忆光标）
│   └── plugins/
│       ├── init.lua                 # vim.pack.add(...) 注册中心
│       ├── colorscheme.lua          # AlexvZyl/nordic.nvim
│       ├── treesitter.lua           # nvim-treesitter (main) + textobjects + treesitter-context + FileType autocmd
│       ├── completion.lua           # blink.cmp（friendly-snippets 默认自动识别）
│       ├── lsp.lua                  # 诊断 UI / capabilities / LspAttach keymap / vim.lsp.enable
│       ├── format.lua               # conform.nvim（默认关闭保存自动格式化）
│       ├── dap.lua                  # nvim-dap + dap-ui + virtual-text + codelldb
│       ├── git.lua                  # gitsigns
│       ├── lazygit.lua              # lazygit.nvim（依赖系统 lazygit 二进制）
│       ├── filetree.lua             # nvim-tree + nvim-web-devicons
│       ├── picker.lua               # fzf-lua（依赖系统 fzf 二进制）
│       ├── statusline.lua           # lualine.nvim
│       ├── editing.lua              # mini.pairs + mini.surround + mini.ai + mini.indentscope + guess-indent
│       ├── scroll.lua               # neoscroll.nvim（<C-f>/<C-b>/<C-d>/<C-u> 平滑滚动）
│       ├── motion.lua               # flash.nvim（s/S 跳转）
│       ├── outline.lua              # aerial.nvim（<leader>O 切换）
│       ├── trouble.lua              # trouble.nvim v3（<leader>x* 系列）
│       ├── splits.lua               # smart-splits.nvim（接管 <C-h/j/k/l>，复用器穿越）
│       ├── todo.lua                 # todo-comments.nvim
│       ├── session.lua              # resession.nvim（branch-scoped 会话）
│       ├── bufferline.lua           # bufferline.nvim
│       ├── terminal.lua             # toggleterm.nvim（<leader>t* + <C-\>）
│       └── whichkey.lua             # which-key.nvim（leader 弹窗 + prefix 分组声明）
└── lsp/
    ├── clangd.lua                   # clangd（含 --clang-tidy）
    └── rust_analyzer.lua            # rust-analyzer（check.command = clippy）
```

加载顺序（在 `init.lua` 与 `lua/plugins/init.lua` 中固定）：

```
init.lua
  └─ core.options
  └─ core.keymaps
  └─ core.autocmds
  └─ plugins         (lua/plugins/init.lua)
       ├─ vim.pack.add({...})
       ├─ plugins.colorscheme       ← 必须最先 require，避免主题来不及生效
       ├─ plugins.treesitter
       ├─ plugins.completion
       ├─ plugins.lsp
       ├─ plugins.format
       ├─ plugins.dap
       ├─ plugins.git
       ├─ plugins.lazygit
       ├─ plugins.filetree
       ├─ plugins.picker
       ├─ plugins.statusline
       ├─ plugins.editing
       ├─ plugins.scroll
       ├─ plugins.motion
       ├─ plugins.outline
       ├─ plugins.trouble
       ├─ plugins.splits
       ├─ plugins.todo
       ├─ plugins.session
       ├─ plugins.bufferline
       ├─ plugins.terminal
       └─ plugins.whichkey         ← 最后 require，确保所有 keymap 的 desc 已注册
```

## 当前实现状态

- 全部 12 项需求已落地。
- **第 1 / 2 / 3 / 4 批扩展已大部分落地**，另已加入 neoscroll 平滑滚动；仅剩第 4 批的 harpoon、render-markdown 待选。系统级新依赖：`fzf`、`ripgrep`、`lazygit`（README 已记录）。
- 主要快捷键已在 `lua/plugins/*.lua` 与 `lua/core/keymaps.lua` 内 set，完整速查表见 [KEYMAPS.md](KEYMAPS.md)（README 只保留 Leader 分组总览 + 链接）。
- 尚未在真实 Linux/Mac 机上跑过；Windows 上结构已就位，但需要装齐系统级依赖（见 README）才能完整启动。

### 第 1 批落地时的关键决策（后续 agent 不要回滚）

1. **`<leader>O` 单键 toggle aerial**——AGENTS.md 早期版本写"加 group 标题"是笔误，已修正：单键不算前缀，不在 whichkey 注册 group。
2. **flash 占用 `s`/`S`**：`s` 原本是 substitute char，用 `cl` 替代。因此 mini.surround 改用 LazyVim 风格的 `gs*` 前缀（`gsa/gsd/gsr/...`），不会和 flash 冲突。在 whichkey 已注册 `gs` 作为 `+surround` 分组。
3. **friendly-snippets 不需要 LuaSnip**：blink.cmp 1.x 内置的 `snippets` source 默认 `friendly_snippets = true`，会自动扫 runtimepath 里 friendly-snippets 的目录。`completion.lua` 不需要改，仅在 `vim.pack.add` 注册即可。
4. **fzf-lua 接管 `vim.ui.select()`**：在 `picker.lua` 调了 `fzf.register_ui_select()`，这样 `vim.lsp.buf.code_action` 等会走 fzf 弹窗。如果新增插件依赖 `vim.ui.select`，无需额外配置。
5. **lazygit 在系统二进制不存在时静默跳过**：`lazygit.lua` 顶部 `vim.fn.executable('lazygit') == 0` 时只 `vim.notify` 一条警告并 `return`，不会报错。

### 第 2 / 3 / 4 批落地时的关键决策

6. **smart-splits 接管 `<C-h/j/k/l>`**：`lua/core/keymaps.lua` 里原来的 4 行 `<C-w>h/j/k/l` 已**删除**，改由 `lua/plugins/splits.lua` 重新绑到 `smart-splits.move_cursor_*`。在没有 tmux/wezterm/kitty 等复用器时它会平滑退化为原生 `<C-w>` 行为，所以删旧映射是安全的。**不要恢复那 4 行**，否则会双绑定。
7. **trouble.nvim 用 v3 API**：`:Trouble {mode} {action}` 风格，不是 v2 的 `:TroubleToggle`。引入新 mode 时记得用 v3 的 `modes = { ... }` 表（而不是顶层 options）。
8. **treesitter-textobjects 装 `version = 'main'`**：与 nvim-treesitter `main` 分支配套；不要装默认（master）分支，会报 `nvim-treesitter.configs` 不存在。
9. **treesitter-context 不依赖 nvim-treesitter**：它直接用 `vim.treesitter`，所以与 main 分支天然兼容；setup 后的 `[c` keymap 是它自己提供的 `go_to_context()`。
10. **resession 自动会话名 = `cwd@branch`**：通过 `git branch --show-current` 获取分支名拼接 cwd 短名，每个 git 分支独立 session。`VimEnter` 仅在 `argc() == 0` 时恢复（用户带文件参数启动时不打扰）。
11. **bufferline 给 nvim-tree / aerial 留 offset**：`offsets = { ... }` 配置项保证 tabline 不覆盖文件树和大纲侧栏。新增其它侧栏时记得也加进来。
12. **toggleterm 与 smart-splits 协作**：`TermOpen` autocmd 里用原生 `<C-\><C-n><C-w>h` 等映射跳出终端 buffer；smart-splits 在 normal mode 时接管，自动 fall-through。
13. **mini.indentscope 在侧栏 / 浮窗禁用**：通过 `FileType` autocmd 给 NvimTree、aerial、trouble、toggleterm、fzf 等 buffer 设 `vim.b.miniindentscope_disable = true`。新增大型侧栏 plugin 时把 filetype 加进来。
14. **mini.ai 与 treesitter-textobjects 共存**：mini.ai 用启发式 + TS spec 提供 `vif/vac/vio/via/vii` 等"日常文本对象"，treesitter-textobjects 提供 `]m`/`[m` motion 与精准 `af/ic/aa`。两者不冲突，因为 mini.ai 设置在 editing.lua、TS textobjects 在 treesitter.lua，注册的是不同 capture 路径。

## 编辑约定（agent 修改时要遵守）

1. **不要把多个功能塞回 init.lua**（违反需求 11）。新功能应作为 `lua/plugins/<feature>.lua` 单独文件，并在 `lua/plugins/init.lua` 注册。
2. **新增 LSP server 时**：在 `lsp/<server_name>.lua` 写配置，并在 `lua/plugins/lsp.lua` 的 `vim.lsp.enable({...})` 列表里加上名字。文件名要与 server 名一致（下划线、非连字符）。
3. **新增插件时**：
   - 在 `lua/plugins/init.lua` 的 `vim.pack.add({...})` 加入 `{ src = 'https://github.com/...' }`
   - 在 `lua/plugins/<feature>.lua` 中 `require` 并 `setup`，所有 require 用 `pcall` 保护（首次安装尚未拉取完成时不报错）
   - 在文件中保留模式：先 `pcall(require, '...')`，失败 `vim.notify` 后 `return`
4. **快捷键改动**：必须同步更新 [KEYMAPS.md](KEYMAPS.md) 的速查表（README.md 只是入口，详细 keymap 不在那里维护）；写 keymap 时坚持给 `desc =`（which-key 弹窗会自动展示）；如果引入了**新的 `<leader>X` 前缀**，去 `lua/plugins/whichkey.lua` 的 `wk.add({...})` 里加分组标题，并在 [README.md](README.md) 的 Leader 分组总览里补一行链接。
5. **保存自动格式化**：除非用户明确要求，**保持默认关闭**。任何动作如果让保存时自动跑格式化，都违反需求 10。
6. **路径处理**：跨平台用 `vim.fs.joinpath` / `vim.fn.stdpath`，不要拼字符串。
7. **注释风格**：核心配置文件（`lua/core/options.lua`）使用按段分组的中文注释；插件文件用简短英文注释说明 *为什么* 这样配置，而不是字面描述。
8. **不引入新依赖时优先用 0.12 原生 API**：例如折叠用 `vim.treesitter.foldexpr`、补全菜单接收 `completeopt` 中的 `fuzzy`、诊断跳转用 `vim.diagnostic.jump`。

## 历史决策（被否定的方案，避免反复推翻）

- ❌ **lazy.nvim**：用户明确选择 `vim.pack`，不要替换。
- ❌ **nvim-cmp / 内置 vim.lsp.completion**：用户明确选择 `blink.cmp`。
- ❌ **nvim-lspconfig**：仅两个 server，原生 API 已足够；引入会违反"最小依赖"原则。
- ❌ **mason.nvim**：跨平台尤其 Windows 上易出问题；改为 README 文档化系统级安装。（AstroNvim 默认内置，但本仓库明确拒绝）
- ❌ **save-on-format**：违反需求 10。
- ❌ **rustaceanvim**：引入会让 Rust 走与 C++ 不同的代码路径，破坏一致性；坚持 `vim.lsp.enable` 的统一方式。
- ❌ **noice.nvim**：替换 cmdline / messages / popup UI，重型；与 0.12 原生 cmdline 改动可能打架。
- ❌ **snacks.nvim**：folke 全家桶（picker / dashboard / terminal / lazygit / notifier ...），违反"单功能单文件"约定。（AstroNvim 默认内置，但本仓库明确拒绝）
- ❌ **alpha-nvim / dashboard-nvim**：启动页纯装饰，与最小依赖原则冲突。
- ❌ **edgy.nvim**：边栏布局管理器；本仓库只有一个 nvim-tree，不需要。
- ❌ **nvim-notify**：0.12 原生 `vim.notify` 已够用。
- ❌ **markdown-preview.nvim**：需要 npm + 浏览器；如需渲染改用 `render-markdown.nvim`（buffer 内渲染）。
- ❌ **telescope.nvim**：纯 Lua sorter 慢；选 `fzf-lua`（以系统 `fzf` 二进制做后端，与"系统级工具链"思路一致）。
- ❌ **heirline.nvim**：AstroNvim 的状态栏/tabline 方案，功能极强但配置极复杂；`lualine.nvim` 已满足需求且配置简洁。
- ❌ **none-ls.nvim（null-ls）**：AstroNvim 用于格式化和 linting 的中间层；本仓库已用 `conform.nvim` 做格式化，clangd/rust-analyzer 原生承担 linting，引入 none-ls 只会增加复杂度。
- ❌ **windwp/nvim-autopairs**：AstroNvim 默认内置；但 `echasnovski/mini.pairs` 更轻量，其对 Treesitter 的深度集成对 C++/Rust 意义不大。
- ❌ **windwp/nvim-ts-autotag**：AstroNvim 默认内置，用于自动关闭/重命名 HTML/JSX 标签；本仓库主要语言为 C++/Rust，完全无关。
- ❌ **max397574/better-escape.nvim**：AstroNvim 内置的 `jk` 逃离键插件；可用原生 `vim.keymap.set('i', 'jk', '<esc>')` 一行代替，不值得引入依赖。
- ❌ **folke/persistence.nvim**：原计划的会话管理方案，已改用功能更强的 `stevearc/resession.nvim`（支持命名会话 + branch-scoped 会话）。

## 未来扩展项（参考 LazyVim + AstroNvim，未实现）

以下清单综合参考 LazyVim（精简/速度优先）与 AstroNvim（功能完备/模块化）两个发行版的默认配置，已按"是否符合本仓库精神（最小依赖 / 跨平台 / `vim.pack` 友好 / 单功能单文件）"过筛。每个插件都注明了**功能作用**、**推荐来源**与**推荐理由**。落地时严格遵守上文"编辑约定"。原 [README.md](README.md) `## 后续可扩展项` 小节仅作给人类的入门提示，详细规划以本节为准。

### 两个发行版的核心差异（选型参考）

| 维度 | LazyVim 选择 | AstroNvim 选择 | 本仓库采用 |
| --- | --- | --- | --- |
| Picker | fzf-lua | snacks.nvim picker | **fzf-lua**（snacks 已否定） |
| 状态栏 | lualine | heirline | **lualine**（heirline 配置极复杂） |
| 自动配对 | mini.pairs | windwp/nvim-autopairs | **mini.pairs**（更轻量） |
| 文本对象 | mini.ai | treesitter-textobjects | **两者并用**（mini.ai 作前端，TS textobjects 作后端） |
| 会话管理 | persistence.nvim | resession.nvim | **resession**（支持命名会话 + branch-scoped） |
| 代码大纲 | 可选 extra | **默认内置** aerial.nvim | **aerial**（AstroNvim 标志性功能，C++/Rust 尤其有价值） |
| 缩进检测 | 无 | **默认内置** guess-indent | **guess-indent**（零配置，自动适配他人代码风格） |
| Snippet 库 | LuaSnip + friendly-snippets | LuaSnip + friendly-snippets | **friendly-snippets**（两方共识） |
| 分屏导航 | 原生 `<C-w>` | smart-splits（复用器感知） | **smart-splits**（tmux/wezterm 用户必备） |
| 终端 | toggleterm（可选）| **默认内置** toggleterm | **toggleterm**（两方共识） |

### P0：缺了影响日常使用

| 插件 | 功能作用 | 推荐来源 | 推荐理由 / 接入要点 |
| --- | --- | --- | --- |
| `ibhagwan/fzf-lua` | 文件 / live grep / buffer / symbol / git 模糊查找，以系统 `fzf` 二进制为后端 | LazyVim（v12 起默认 picker） | 比 telescope 快得多（C 后端而非纯 Lua）；需系统 `fzf` 在 PATH；新建 `lua/plugins/picker.lua`；keymap 落到已有 `<leader>f` 分组（`ff/fg/fb/fr/fh` 等） |
| `nvim-lualine/lualine.nvim` | 底部状态栏，显示 mode / 文件名 / git 分支 / LSP 诊断计数 / 编码 | LazyVim（默认） | 零信息密度的原生状态栏严重影响上下文感知；接 `nordic` 主题；放 `lua/plugins/statusline.lua` |
| `echasnovski/mini.pairs` | 输入 `(` / `{` / `"` 时自动补全闭合符，跳出时智能跳过 | LazyVim（默认） | 轻量无侵入；windwp/nvim-autopairs 的 TS 集成优势对 C++/Rust 意义不大；多个 mini.* 共用 `lua/plugins/editing.lua` |
| `echasnovski/mini.surround` | `ysiw"` 加引号、`cs"'` 替换、`ds"` 删除包裹符 | LazyVim（默认） | 高频操作，手工修改括号极低效；同 editing.lua |
| `folke/flash.nvim` | `s{两字符}` 精准跳转到屏幕任意位置；`S` 进入 treesitter node 选择模式 | LazyVim（默认） | 替代 `f/F/t/T` 的有限跳转范围；在大 C++ 文件里尤其高效；新建 `lua/plugins/motion.lua` |
| `stevearc/aerial.nvim` | 右侧代码大纲侧栏：列出 struct / impl / function / class 层级；支持 LSP 和 Treesitter 双后端 | **AstroNvim（默认内置）** | AstroNvim 的标志性功能；对大型 C++ 头文件（多类多方法）和 Rust trait impl 文件极为实用；与 fzf-lua 集成可 fuzzy 搜索符号（`<leader>fo`）；新建 `lua/plugins/outline.lua`；`<leader>O` 单键 toggle（单键无需在 whichkey 注册 group） |
| `NMAC427/guess-indent.nvim` | 打开文件时自动检测其缩进风格（2 空格 / 4 空格 / tab）并临时应用，不影响全局 `vim.opt` | **AstroNvim（默认内置）** | 参与开源项目或公司代码库时，不同仓库有不同缩进惯例；零配置，只需注册；追加到 `editing.lua` |
| `rafamadriz/friendly-snippets` | 社区维护的多语言 snippet 集合，覆盖 C/C++（`for`、`class`、`switch` 等）和 Rust（`fn`、`struct`、`impl`、`match` 等） | **LazyVim + AstroNvim（两方共识）** | 当前 `completion.lua` 已配 `snippets` source，但 Neovim 内置 snippet 库几乎为空；blink.cmp 1.x 内置 LuaSnip 桥，注册插件后自动识别，无需额外配置；追加到 `lua/plugins/init.lua` 注册即可 |
| `kdheepak/lazygit.nvim` | 在 Neovim 浮窗内调起 lazygit TUI，完成 commit / amend / 交互式 rebase / cherry-pick / 分支切换 / merge conflict / stash / push / pull 等完整 git 操作 | **LazyVim + AstroNvim（均推荐）** | 与已有 `gitsigns` 互补——gitsigns 管"当前 buffer 的 git 信息（行标记 / hunk / blame）"，lazygit 管"整个仓库的 git 操作"；插件本体极薄，依赖系统 `lazygit` 二进制（`winget install JesseDuffield.lazygit` / `brew install lazygit` / 各 Linux 包管）；keymap 落到已有 `<leader>g` 分组，用 `<leader>gg` 打开；新建 `lua/plugins/lazygit.lua` |

### P1：质量提升明显

| 插件 | 功能作用 | 推荐来源 | 推荐理由 / 接入要点 |
| --- | --- | --- | --- |
| `folke/trouble.nvim` | 可浮动的诊断列表 / LSP 引用列表 / quickfix 增强 UI，支持按严重级别过滤 | LazyVim（默认） | 原生 quickfix 和 loclist 的交互体验极差；新建 `lua/plugins/trouble.lua`；新前缀 `<leader>x`，记得在 `whichkey.lua` 加分组标题 |
| `echasnovski/mini.ai` | 扩展文本对象：`vaf`（函数）、`vac`（类/struct）、`vai`（缩进块）、`va"`（引号内外）等 | LazyVim（默认） | 原生文本对象只有 `iw/aw/i"/a"` 等少数几个，写 C++/Rust 时高频需要选函数体 / 参数；追加到 `editing.lua`；配合下面的 treesitter-textobjects 作为后端 |
| `nvim-treesitter/nvim-treesitter-textobjects` | 精确的 TS 语法树文本对象：`@function.inner`、`@parameter.inner`、`@return.inner`、`@class.outer` 等 | **AstroNvim（默认内置）** | 与 mini.ai 协同：mini.ai 作为前端提供人体工学按键，treesitter-textobjects 作为后端提供 C++/Rust 语法精准边界（比 mini.ai 内置的启发式更准确）；追加到 `treesitter.lua` |
| `mrjones2014/smart-splits.nvim` | 感知终端复用器（tmux / wezterm / kitty）边界的分屏导航，可在 nvim 和复用器 pane 之间无缝 `<C-h/j/k/l>` 切换；`<M-h/j/k/l>` 调整分屏大小 | **AstroNvim（默认内置）** | 当前 `core/keymaps.lua` 的原生 `<C-w>h` 映射碰到 tmux 边界就停住了；替换后 4 个窗口导航 keymap 即可透明穿越；新建 `lua/plugins/splits.lua`，并从 `core/keymaps.lua` 移除被替代的 4 行原生映射 |
| `folke/todo-comments.nvim` | 高亮 + 搜索代码中的 `TODO / FIXME / HACK / NOTE / WARN` 注释，支持跳转和 quickfix 列表 | LazyVim（默认） | 大型项目里 TODO 散落各处，没有高亮极易遗忘；配合 fzf-lua 提供 `<leader>st` 全局搜索；新建 `lua/plugins/todo.lua` |
| `nvim-treesitter/nvim-treesitter-context` | 长函数 / 循环滚动时，在顶部粘性显示当前所在的函数签名 / 类名 / 条件分支头 | LazyVim（默认） | 阅读超过一屏的 C++ 函数时，忘记自己在哪个 if/for/class 里是常见问题；追加到 `treesitter.lua`；**必须在安装前确认与 nvim-treesitter `main` 分支兼容** |
| `echasnovski/mini.indentscope` | 用动态线高亮当前光标所在的缩进 scope | LazyVim（默认） | 配合 treesitter-context 双重辅助定位；比 indent-blankline 更轻量；追加到 `editing.lua` |
| `stevearc/resession.nvim` | 会话管理：保存 / 恢复 buffer 列表和窗口布局；支持**命名会话**和 **branch-scoped 会话**（每个 git 分支独立 session） | **AstroNvim（默认内置）** | AstroNvim 选此而非 persistence.nvim，原因是 resession 支持命名会话，配合 fzf-lua 可以模糊选择；对多项目多分支开发流更友好；`<leader>S` 前缀（`<leader>q` 已占用）；新建 `lua/plugins/session.lua` |

### P2：看口味

| 插件 | 功能作用 | 推荐来源 | 推荐理由 / 备注 |
| --- | --- | --- | --- |
| `akinsho/bufferline.nvim` | 顶部可视化 buffer tab 栏，显示文件名 / 修改标记 / 诊断图标 | LazyVim（可选） | 已有 `<S-h/l>` 切换 keymap，bufferline 只是可视化补充；AstroNvim 用 heirline 内置此功能，我们单独引入更简洁 |
| `MeanderingProgrammer/render-markdown.nvim` | 在 buffer 内直接渲染 markdown（标题 / 列表 / 代码块 / 表格），不需要浏览器 | LazyVim（可选） | 不要选 `markdown-preview.nvim`（依赖 npm + 浏览器）；对写文档 / AGENTS.md 编辑体验有帮助 |
| `ThePrimeagen/harpoon` v2 | 在 4–5 个项目内高频文件之间直跳（`<leader>1..5`），比 mark 更直观 | LazyVim（可选） | 跟 fzf-lua 互补：fzf 全量搜索，harpoon 固定书签；Windows pwsh 兼容 |
| `akinsho/toggleterm.nvim` | 浮窗 / 水平 / 垂直分屏终端；支持多实例；lazygit 可托管其中 | LazyVim + AstroNvim（均内置） | Windows pwsh 已在 `lua/core/options.lua` 配好 UTF-8；新建 `lua/plugins/terminal.lua`；新前缀 `<leader>t`，记得在 `whichkey.lua` 加分组标题 |

### 落地批次建议（每批 = 一个 commit / PR）

1. ~~**第 1 批（核心生产力）**：fzf-lua + lualine + mini.pairs + mini.surround + flash + **aerial** + **guess-indent** + **friendly-snippets** + lazygit~~ **✅ 已完成**
2. ~~**第 2 批（编辑增强）**：trouble + mini.ai + **treesitter-textobjects** + todo-comments + treesitter-context + **smart-splits**~~ **✅ 已完成**
3. ~~**第 3 批（视觉 / 会话）**：mini.indentscope + **resession**（替代 persistence）+ bufferline~~ **✅ 已完成**（bufferline 已纳入而不是"可选"）
4. **第 4 批（按需工具）**：~~toggleterm~~ ✅ + harpoon + render-markdown

粗体为相较原 LazyVim 计划新增的 AstroNvim 来源插件。

每批落地必做：

- 在 `lua/plugins/init.lua` 的 `vim.pack.add({...})` 注册
- 新建或合并到对应 `lua/plugins/<feature>.lua`，全部 `require` 用 `pcall` 保护
- 涉及新 `<leader>X` 前缀时，去 `lua/plugins/whichkey.lua` 加分组标题
- 同步更新 [KEYMAPS.md](KEYMAPS.md) 的快捷键速查表，必要时在 [README.md](README.md) 的 Leader 分组总览补链接 / 在系统级工具表里加新二进制

## 验证清单（agent 完成大改后建议跑一遍）

- `:checkhealth`
- `:checkhealth vim.pack`
- `:checkhealth nvim-treesitter`
- 首次拉完插件后跑一次 `:TsEnsure`，再 `:checkhealth nvim-treesitter` 确认解析器都已编译
- 打开 `.cpp` / `.rs` 文件，确认：
  - LSP 已附着（`:checkhealth vim.lsp` 或 `:lua =vim.lsp.get_clients({ bufnr = 0 })`；**不要用 `:LspInfo`，那是 nvim-lspconfig 的命令，本配置故意不引入**）
  - 高亮生效（`:Inspect`）
  - `<leader>fm` 能格式化
  - `<F5>` 能进入调试（前提 codelldb 在 PATH）
  - 保存时**不**触发格式化
- `gitsigns` 在 git 仓库中能显示左侧标记
- `<leader>e` 能切出文件树
- 排错入口：`:messages` → `:checkhealth` → LSP 日志 (`:lua vim.cmd.edit(vim.lsp.get_log_path())`) → DAP 日志 (`stdpath('cache')/dap.log`)
