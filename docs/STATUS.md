# 实现与计划状态

[返回 README](../README.md) · [改进建议](IMPROVEMENTS.md)

本文件是功能生命周期状态的唯一来源。实现细节见
[架构与设计](ARCHITECTURE.md)，计划项的理由与方案见
[改进建议](IMPROVEMENTS.md)。

## 已实现

### 项目基线

- Linux / macOS 为支持平台。
- 默认四空格缩进，并由 guess-indent 按 buffer 适配已有文件风格。
- C/C++ 使用 clangd，Rust 使用 rust-analyzer。
- blink.cmp 提供 LSP、路径、buffer 和 friendly-snippets 补全。
- C/C++ 与 Rust 共用 nvim-dap + codelldb 调试。
- conform.nvim 提供 clang-format、rustfmt 和可选 stylua。
- clangd `--clang-tidy` 与 rust-analyzer clippy 提供静态分析。
- Treesitter `main` 分支提供高亮、折叠、缩进、文本对象和上下文。
- Nordic 是默认主题。
- gitsigns 与 lazygit 提供 buffer 级和仓库级 Git 能力；gitsigns 使用彩色竖线区分新增 / 修改 / 删除。
- nvim-tree 提供文件树。
- 保存格式化默认关闭，支持手动格式化和会话内显式切换。
- 配置按 core、plugin 和 LSP server 模块拆分。

### 编辑与导航

- fzf-lua 文件、内容、LSP 和 Git picker，并接管 `vim.ui.select()`。
- lualine、bufferline 和 which-key。
- mini.pairs、mini.surround、mini.ai、mini.indentscope。
- Flash、neoscroll、Aerial 和 smart-splits。
- `<leader>-` / `<leader>|` 创建水平与垂直分屏。
- Trouble 与 todo-comments。
- toggleterm。
- resession 命名和 branch-scoped 自动会话。
- Neovim 原生 `gc` / `gcc` 注释能力已记录在快捷键文档。
- LSP insert 模式用 `<C-k>`、normal 模式用 `<leader>ck` 显示签名，避免覆盖
  smart-splits 的向上切窗。
- 原生 UI toggle 层（`<leader>u*`）：relative number、wrap、spell、diagnostics、
  inlay hints、format-on-save、smooth scroll。
- `vim.pack` 管理快捷键（`<leader>l*`）：更新、浏览、health、日志、重装与删磁盘副本。

### 文档

- README 与 AGENTS 作为根目录入口。
- 项目、架构、状态、安装、维护和排错文档按职责拆分到 `docs/`。
- 快捷键和改进建议使用简洁索引加专题文档。
- 已删除孤立的 `.neoconf.json`（配置未使用 neoconf.nvim）。

## 正在实现

当前没有处于实现中的运行时功能。

开始实现计划项时，先把该项移到本节；完成验证后再移到“已实现”。

## 计划实现

### 优先

当前无优先项。

### 后续

- [自动推断 DAP executable 并复用 launch.json](improvements/project-workflow.md#dap-启动体验)
- [统一 build / test / run 入口](improvements/project-workflow.md#项目任务入口)

### 按需

- [Markdown buffer 内渲染](improvements/editor-experience.md#markdown-buffer-内渲染)
- [Harpoon v2](improvements/editor-experience.md#harpoon-v2)
- [`vim.ui.input()` 界面增强](improvements/editor-experience.md#vimuiinput-界面)
- [启动性能基准](improvements/quality.md#启动性能基准)
- [CI 与 smoke test](improvements/quality.md#ci-与-smoke-test)

## 验证状态

仓库没有保存可复现的 Linux / macOS 实机验证结果。完成某个平台的验证后，应按
[验证清单](MAINTENANCE.md#验证清单)记录实际结果。
