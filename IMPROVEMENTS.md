# 改进建议

这份文档记录当前配置在参考 LazyVim / AstroNvim 后，仍然值得继续改进的方向。

原则仍以 [AGENTS.md](AGENTS.md) 为准：保持 Neovim 0.12 原生路线、`vim.pack`、单功能单文件、跨平台，以及保存时默认不自动格式化。

## 当前判断

当前项目已经吸收了 LazyVim / AstroNvim 中最适合本仓库的一批能力：`blink.cmp`、`fzf-lua`、`conform.nvim`、`trouble.nvim`、`mini.*`、`aerial.nvim`、`smart-splits.nvim`、`resession.nvim`、`toggleterm.nvim`、`neoscroll.nvim` 等。

后续重点不应是复刻完整发行版，而是补齐个人 C++ / Rust 工作流中真实高频的缺口。

## 最值得优先做

### 1. render-markdown.nvim

这是第 4 批剩余项中收益最稳定的一项。仓库长期维护 `README.md`、`KEYMAPS.md`、`AGENTS.md` 这类 Markdown 文档，buffer 内渲染标题、列表、代码块和表格会明显提升阅读体验。

推荐原因：

- 不依赖 npm 或浏览器。
- 符合“单功能单文件”的插件边界。
- 与已否定的 `markdown-preview.nvim` 相比更轻量。

建议落地方式：

- 注册 `MeanderingProgrammer/render-markdown.nvim`。
- 新建 `lua/plugins/markdown.lua`。
- 默认只对 Markdown 文件启用。
- 同步更新 `README.md`、`KEYMAPS.md`。

### 2. 原生 toggle 层

LazyVim 的 `<leader>u*` 开关很实用，但不需要引入 `snacks.nvim`。可以用 Neovim 原生 API 做一个轻量 toggle 模块。

建议提供：

- `<leader>ur`：切换 relative number。
- `<leader>uw`：切换 wrap。
- `<leader>us`：切换 spell。
- `<leader>ud`：切换 diagnostics。
- `<leader>uh`：切换 inlay hints。
- `<leader>uf`：切换 format-on-save。
- `<leader>uS`：切换 smooth scroll。

建议落地方式：

- 新建 `lua/core/toggles.lua` 或 `lua/plugins/toggles.lua`。
- 新增 `<leader>u` which-key 分组。
- 同步 `KEYMAPS.md` 和 `README.md` 的 Leader 分组。

注意：`format-on-save` 仍必须默认关闭，只允许运行时显式打开。

### 3. DAP 启动体验

当前 `lua/plugins/dap.lua` 能跑 C++ / Rust，但启动目标主要靠手动输入 executable 路径。可以借鉴发行版里“项目工作流优先”的思路，减少每次调试前的手工步骤。

建议改进：

- Rust：从 `target/debug/` 或 `cargo metadata` 推断可执行文件。
- C / C++：从 `build/`、`cmake-build-*`、`compile_commands.json` 周边路径推断可执行文件。
- 支持读取 `.vscode/launch.json`，方便复用项目配置。
- 给“重新运行上次调试配置”提供快捷键。

建议保持：

- 仍使用 `codelldb`。
- 不引入 mason。
- 不改成 `rustaceanvim`，保持 C++ / Rust 调试路径一致。

### 4. 项目任务 / 构建入口

当前有 DAP 和 toggleterm，但没有统一的 build / test / run 入口。LazyVim / AstroNvim 都强调在编辑器内完成项目任务，这对 C++ / Rust 很有价值。

两种路线：

- 轻量路线：用原生命令和 toggleterm 做 `<leader>T*` 任务入口。
- 插件路线：引入 `stevearc/overseer.nvim` 做任务管理。

建议先从轻量路线开始：

- `<leader>Tb`：build。
- `<leader>Tt`：test。
- `<leader>Tr`：run。
- Rust 项目优先调用 `cargo build` / `cargo test` / `cargo run`。
- CMake 项目优先调用 `cmake --build build`。

如果后续需要任务历史、并发任务、状态列表，再考虑 `overseer.nvim`。

## 看使用习惯再做

### 5. Harpoon v2

Harpoon 适合在少数高频文件之间固定跳转，和 fzf-lua 的全量搜索互补。

需要注意当前 `bufferline.lua` 已经使用 `<leader>1..9` 跳转 buffer，因此不建议照搬 Harpoon 常见的数字键方案。

建议键位：

- `<leader>ha`：添加当前文件。
- `<leader>hh`：打开 Harpoon 列表。
- `<leader>h1..h5`：跳转到第 1-5 个固定文件。

落地时需要新增 `<leader>h` which-key 分组，并同步文档。

### 6. vim.ui.input 美化

当前 `fzf-lua` 已接管 `vim.ui.select()`，但 `vim.ui.input()` 还是原生 UI。DAP 条件断点、log point、session 命名都会用到它。

可选方案：

- 引入 `stevearc/dressing.nvim`。
- 只启用 input 相关能力。
- 保持 `fzf-lua` 继续接管 select。

这比引入 `noice.nvim` 或 `snacks.nvim` 更符合本仓库风格。

### 7. 启动性能基准

因为 `vim.pack` 不支持 lazy loading，插件数量增加后需要有一个简单的启动成本观测方式。

建议补充文档或脚本：

```bash
nvim --headless --startuptime startup.log +qa
```

可以在每批新增插件后记录一次，避免配置逐渐变慢但难以定位。

### 8. CI / smoke test

配置仓库也适合有最小验证，尤其目标是三平台可启动。

建议先做本地脚本，后续再考虑 GitHub Actions：

- `nvim --headless +qa`
- Lua 语法检查。
- 可选 `stylua --check`。

CI 不需要安装全部语言工具链，重点是保证配置文件能启动、插件注册没有语法错误。

## 小清理项

### 9. `.neoconf.json` 孤儿文件

仓库里存在 `.neoconf.json`，但没有引入 `neoconf.nvim`。如果不计划使用 neoconf，建议删除；如果只是预留，应在 README 或本文件中说明。

当前倾向：删除或明确标注为预留，不建议为了它额外引入 neoconf。

### 10. README 目录结构补全

`README.md` 目录树主要描述运行配置，但可以补充 `AGENTS.md`、`KEYMAPS.md`、`IMPROVEMENTS.md`，让入口文档和仓库实际结构更一致。

## 不建议跟进

以下方向虽然出现在 LazyVim / AstroNvim 中，但不适合当前仓库：

- `snacks.nvim`：功能集合过大，和“单功能单文件”约定冲突。
- `lazy.nvim`：用户已明确选择 Neovim 0.12 内置 `vim.pack`。
- `mason.nvim`：跨平台尤其 Windows 上容易引入额外问题，当前选择是 README 文档化系统级安装。
- `nvim-lspconfig`：当前只有 clangd / rust-analyzer，原生 `vim.lsp.config()` 足够。
- `heirline.nvim`：能力强但配置复杂，当前 `lualine.nvim` + `bufferline.nvim` 已满足需求。
- `noice.nvim`：替换 cmdline/messages 的范围较大，容易和 Neovim 0.12 原生 UI 改动产生摩擦。
- `none-ls.nvim`：当前格式化由 conform 负责，lint 由 clangd / rust-analyzer 原生能力负责。

## 推荐批次

### 下一批

- `render-markdown.nvim`
- 原生 `<leader>u` toggle 层
- README 目录结构补全
- `.neoconf.json` 清理

### 再下一批

- DAP executable 自动选择
- 项目任务 / 构建入口

### 按需

- Harpoon v2
- `vim.ui.input` 美化
- 启动性能基准
- CI / smoke test
