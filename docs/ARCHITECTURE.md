# 架构与设计

[返回 README](../README.md) · [项目需求](PROJECT.md) · [实现状态](STATUS.md)

## 总体结构

`init.lua` 只设置 Leader 并加载模块。通用行为放在 `lua/core/`，插件注册和
配置放在 `lua/plugins/`，原生 LSP server 配置放在 `lsp/`。

```text
nvim/
├── init.lua
├── lua/
│   ├── core/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocmds.lua
│   │   ├── toggles.lua
│   │   └── pack.lua
│   └── plugins/
│       ├── init.lua
│       ├── colorscheme.lua
│       ├── treesitter.lua
│       ├── completion.lua
│       ├── lsp.lua
│       ├── format.lua
│       ├── dap.lua
│       ├── git.lua
│       ├── lazygit.lua
│       ├── filetree.lua
│       ├── picker.lua
│       ├── statusline.lua
│       ├── editing.lua
│       ├── scroll.lua
│       ├── motion.lua
│       ├── outline.lua
│       ├── trouble.lua
│       ├── splits.lua
│       ├── todo.lua
│       ├── session.lua
│       ├── bufferline.lua
│       ├── terminal.lua
│       └── whichkey.lua
├── lsp/
│   ├── clangd.lua
│   └── rust_analyzer.lua
├── docs/
├── nvim-pack-lock.json
├── AGENTS.md
└── README.md
```

## 启动流程

```text
init.lua
├── core.options
├── core.keymaps
├── core.autocmds
├── core.toggles
├── core.pack
└── plugins
    ├── vim.pack.add(...)
    ├── plugins.colorscheme
    ├── plugins.treesitter
    ├── plugins.completion
    ├── plugins.lsp
    ├── plugins.format
    ├── plugins.dap
    ├── plugins.git
    ├── plugins.lazygit
    ├── plugins.filetree
    ├── plugins.picker
    ├── plugins.statusline
    ├── plugins.editing
    ├── plugins.scroll
    ├── plugins.motion
    ├── plugins.outline
    ├── plugins.trouble
    ├── plugins.splits
    ├── plugins.todo
    ├── plugins.session
    ├── plugins.bufferline
    ├── plugins.terminal
    └── plugins.whichkey
```

主题最先配置，避免界面先使用默认高亮。`which-key` 最后配置，使前面注册的
所有 `desc` 都已存在。

## 核心模块

### 基础配置

- `lua/core/options.lua`：缩进、显示、搜索、窗口、持久化、补全菜单和折叠。
- `lua/core/keymaps.lua`：不依赖插件的快捷键。
- `lua/core/autocmds.lua`：yank 高亮、保存前创建目录、恢复光标位置，以及
  特殊窗口的 `q` 关闭行为。
- `lua/core/toggles.lua`：运行时 UI 开关（relative number、wrap、spell、
  diagnostics、inlay hints、format-on-save、smooth scroll），不引入
  snacks.nvim。
- `lua/core/pack.lua`：`vim.pack` 日常管理快捷键（`<leader>l*`），对应
  LazyVim `<leader>l` / AstroNvim 插件子命令思路，不引入 lazy.nvim UI。

### 插件管理

插件由 Neovim 0.12 内置 `vim.pack` 管理，统一在
`lua/plugins/init.lua` 注册：

- `vim.pack` 不提供 lazy loading，也不会替插件调用 `setup()`。
- `vim.pack.add()` 会并行安装缺失插件，但在继续执行后续 Lua 代码前等待
  安装完成，并将插件加入当前会话。
- 锁文件为配置根目录的 `nvim-pack-lock.json`，必须纳入版本控制，不能手工
  编辑。
- 每个插件的 `require` 使用 `pcall` 防护，首次安装失败时只告警，不让整个
  配置中断。
- 更新、浏览、health、日志、重装与删磁盘副本通过 `lua/core/pack.lua` 的
  `<leader>l*` 暴露；命令级说明见 [维护与验证](MAINTENANCE.md)。

### LSP 与补全

- `lua/plugins/lsp.lua` 使用原生 `vim.lsp.config()` 和
  `vim.lsp.enable()`，不依赖 `nvim-lspconfig`。
- `lsp/clangd.lua` 与 `lsp/rust_analyzer.lua` 利用 Neovim 0.11+
  的约定路径自动合并到对应 server 配置。
- `clangd` 通过 `--clang-tidy` 提供 C/C++ 静态分析。
- `rust-analyzer` 的 `check.command = 'clippy'` 提供 Rust 静态分析。
- `blink.cmp` 提供 LSP、路径、buffer 和 snippet 补全；
  `blink.get_lsp_capabilities()` 注入所有 LSP client capabilities。
- `friendly-snippets` 由 blink.cmp 内置 snippets source 自动发现，不需要
  LuaSnip。

### Treesitter

`nvim-treesitter` 和 `nvim-treesitter-textobjects` 都跟随 `main` 分支，以
适配 Neovim 0.12：

- `nvim-treesitter.configs` 模块已不存在。
- parser 管理由 `require('nvim-treesitter').install()` / `update()` 完成。
- 高亮、折叠和缩进通过 `FileType` autocmd 显式启用。
- parser 不在启动时自动安装。首次安装用 `:TsEnsure`，更新用 `:TsUpdate`。
- `treesitter-context` 直接使用 `vim.treesitter`，不依赖旧配置层。

### 格式化

`conform.nvim` 负责 C/C++、Rust 和可选 Lua 格式化：

- C/C++ 使用 `clang-format`。
- Rust 使用 `rustfmt`。
- Lua 可选使用 `stylua`。
- `vim.g.user_format_on_save` 启动时固定为 `false`。
- `<leader>fm` 手动格式化；`<leader>uf` 与 `:FormatEnable` /
  `:FormatDisable` 只在当前 Neovim 会话内切换保存格式化。
- 没有使用 `conform.setup({ format_on_save = ... })`，因为显式
  `BufWritePre` autocmd 才能支持运行时开关。

### 调试

`nvim-dap`、`nvim-dap-ui` 和 `nvim-dap-virtual-text` 共用 `codelldb`
调试 C、C++ 和 Rust。当前启动配置允许手动选择可执行文件，也支持附加进程。

### 导航与界面

- `fzf-lua` 使用系统 `fzf`，并接管 `vim.ui.select()`。
- `nvim-tree` 提供文件树并禁用 netrw。
- `aerial` 按 LSP、Treesitter、Markdown、man 的顺序选择大纲后端。
- `smart-splits` 接管 normal mode 的 `<C-h/j/k/l>`，可穿越
  tmux/wezterm/kitty pane；没有复用器时退化为普通 Neovim 分屏导航。
- `toggleterm` 的 terminal-mode 映射先退出 terminal mode，再使用原生
  `<C-w>` 导航离开终端 buffer。
- `bufferline` 为 nvim-tree 和 aerial 预留 offset。
- `lualine` 使用全局状态栏，展示 Git、诊断、DAP 和已附着 LSP 信息；它没有
  独立快捷键。
- `mini.indentscope` 在文件树、浮窗、终端、DAP UI 等特殊 filetype 中禁用。

### 会话

`resession.nvim` 使用 `cwd@branch` 作为自动会话名：

- `VimLeavePre` 保存当前会话。
- 只有无文件参数启动时，`VimEnter` 才自动恢复。
- 文件树、终端、DAP UI 等临时 buffer 不写入会话。

## 路径与工具约定

- 路径优先使用 `vim.fs.joinpath()` 和 `vim.fn.stdpath()`。
- 系统工具从 `PATH` 发现，不硬编码个人机器路径。

## 关键交互约定

- `<Space>` 是全局和 local Leader。
- 所有自定义快捷键必须设置 `desc`。
- `s` / `S` 由 Flash 使用；原生 substitute char/line 分别改用 `cl` / `cc`。
- mini.surround 使用 `gs*`，避免与 Flash 冲突。
- `<C-f>/<C-b>/<C-d>/<C-u>` 由 neoscroll 接管。
- `<C-h/j/k/l>` 由 smart-splits 接管，不能在 core 中重复绑定。

完整键位见 [快捷键索引](KEYMAPS.md)。

## 选型记录

### 已采用

- `vim.pack`：与 Neovim 0.12 原生 API 保持一致。
- `blink.cmp`：稳定的补全和预编译 fuzzy matcher。
- 原生 LSP 配置：当前只有 clangd 与 rust-analyzer，不需要额外配置层。
- `conform.nvim`：只负责格式化，静态分析留给语言 server。
- `nvim-dap` + codelldb：C/C++/Rust 使用统一调试路径。
- `fzf-lua`：使用系统 `fzf`，适合大型代码库。
- `resession.nvim`：支持命名和 branch-scoped 会话。

### 明确不采用

- `lazy.nvim`：与已选定的 `vim.pack` 重叠。
- `nvim-cmp` 或原生 LSP completion：补全统一使用 blink.cmp。
- `nvim-lspconfig`：两个 server 使用原生配置已足够。
- `mason.nvim`：系统工具统一由平台包管理器安装。
- `rustaceanvim`：会让 Rust 与 C++ 走不同的 LSP/调试路径。
- `none-ls.nvim`：格式化与 lint 职责已有明确归属。
- `snacks.nvim`、`noice.nvim`、`alpha-nvim`、`dashboard-nvim`、
  `edgy.nvim`、`nvim-notify`：功能范围过大或当前没有明确收益。
- `telescope.nvim`：当前使用系统 `fzf` 驱动的 fzf-lua。
- `heirline.nvim`：lualine + bufferline 已满足状态栏和 buffer 展示。
- `markdown-preview.nvim`：依赖 npm 和浏览器；若需要 Markdown buffer
  内渲染，优先评估 render-markdown.nvim。
- `windwp/nvim-autopairs`：mini.pairs 更轻量。
- `windwp/nvim-ts-autotag`：主要服务 HTML/JSX，与 C++/Rust 主工作流无关。
- `max397574/better-escape.nvim`：简单逃离键可由原生 keymap 实现，不值得
  增加依赖。
- `folke/persistence.nvim`：已由支持命名会话的 resession 替代。
