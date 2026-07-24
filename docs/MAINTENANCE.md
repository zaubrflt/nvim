# 维护与验证

[返回 README](../README.md) · [安装与依赖](SETUP.md) ·
[故障排查](TROUBLESHOOTING.md)

## 常用命令

| 命令 | 作用 |
| --- | --- |
| `:checkhealth` | 全面检查 Neovim、provider 和插件 |
| `:checkhealth vim.pack` | 检查插件和锁文件（快捷键 `<leader>lh`） |
| `:lua vim.pack.update()` | 检查全部插件更新并打开确认 buffer（`<leader>lu`） |
| `:lua vim.pack.update({ 'name' })` | 更新指定插件（`<leader>lU`） |
| `:lua vim.pack.update(nil, { offline = true })` | 离线浏览已装插件（`<leader>lb`） |
| `:lua vim.pack.del({ 'name' })` | 从磁盘移除指定插件（`<leader>lx`） |
| `:lua vim.pack.del({ 'name' }, { force = true })` | 强制移除（含当前会话 active；`<leader>lr` 重装流程） |
| `:TsEnsure` | 安装配置列表中缺失的 Treesitter parser |
| `:TsUpdate` | 更新并重新编译配置列表中的 parser |
| `:checkhealth nvim-treesitter` | 检查 CLI、编译器和 parser |
| `:checkhealth vim.lsp` | 检查原生 LSP client |
| `:lua =vim.lsp.get_clients({ bufnr = 0 })` | 查看当前 buffer 的 LSP client |
| `:messages` | 查看最近消息和错误 |

`vim.pack` 日常操作也可通过 `<leader>l*` 完成，键位见
[Pack](keymaps/tools.md#pack-vimpack)。

`vim.pack.update()` 会展示候选更新。检查变更后，在确认 buffer 中执行
`:write` 应用，或 `:quit` 放弃。更新后的插件通常应在重启 Neovim 后使用。

安装失败或目录损坏时：用 `<leader>lr`（或 `vim.pack.del(..., { force = true })`）
删掉该插件后执行 `:restart`，启动时的 `vim.pack.add()` 会按锁文件重装。

## 修改插件

新增插件时：

1. 在 `lua/plugins/init.lua` 的 `vim.pack.add()` 中增加来源。
2. 在独立的 `lua/plugins/<feature>.lua` 中配置。
3. 使用 `pcall(require, ...)` 处理插件尚不可用的情况。
4. 按依赖关系把模块加入 `lua/plugins/init.lua` 的加载顺序。
5. 启动 Neovim，使 `nvim-pack-lock.json` 更新并确认锁文件差异。
6. 若新增快捷键，同步 `docs/keymaps/` 中对应专题；分组变化时再更新
   [快捷键索引](KEYMAPS.md)。
7. 同步 [实现状态](STATUS.md)。

删除插件时先移除注册和配置，再重启并使用 `vim.pack.del()` 清理磁盘副本。
不要手工编辑锁文件。

## 修改 Treesitter parser

parser 列表位于 `lua/plugins/treesitter.lua` 的 `ensure_installed`：

1. 修改列表。
2. 执行 `:TsEnsure` 安装新增 parser，或执行 `:TsUpdate` 更新全部 parser。
3. 执行 `:checkhealth nvim-treesitter`。
4. 打开目标文件并使用 `:Inspect` 确认高亮 capture。

不要在启动时调用 `ts.install()`。`nvim-treesitter` `main` 分支没有旧版
`ensure_installed` setup 选项，也不存在 `nvim-treesitter.configs`。

## 修改 LSP

新增 server 时：

1. 新建 `lsp/<server_name>.lua` 并返回原生 server 配置 table。
2. 在 `lua/plugins/lsp.lua` 的 `vim.lsp.enable()` 列表中增加同名项。
3. 保留 blink.cmp capabilities 注入。
4. 使用 server 的项目文件测试 root marker、诊断、跳转和补全。

本配置不提供 `:LspInfo`；该命令来自未安装的 nvim-lspconfig。请使用
`:checkhealth vim.lsp`。

## 修改快捷键

- 新增或修改的自定义 keymap 必须设置 `desc`。
- 修改后更新 `docs/keymaps/` 中对应专题；只有分组或导航入口变化时才更新
  [快捷键索引](KEYMAPS.md)。
- 新增 `<leader>X` 字母前缀时，在 `lua/plugins/whichkey.lua` 注册 group。
- 同步 README 的高层入口只在导航结构发生变化时进行，不复制完整键表。
- 不要重复绑定 smart-splits 或 snacks.scroll 已接管的按键。

## 验证清单

### 启动

- `nvim --headless +qa` 能退出且没有 Lua 错误。
- `:checkhealth vim.pack` 没有缺失或损坏插件。
- `nvim-pack-lock.json` 与 `lua/plugins/init.lua` 的插件集合一致。

### Treesitter

- 首次安装或 parser 列表变化后运行 `:TsEnsure`。
- `:checkhealth nvim-treesitter` 能找到 tree-sitter CLI、C 编译器和 parser。
- 在 C++、Rust、Lua、Markdown 文件中用 `:Inspect` 验证高亮。

### C++ 与 Rust

- 在真实项目中执行 `:checkhealth vim.lsp`，确认 clangd 或 rust-analyzer
  附着。
- 测试补全、定义跳转、Hover、重命名和 code action。
- `<leader>fm` 能分别调用 clang-format 或 rustfmt。
- clangd 能产生 clang-tidy 诊断，rust-analyzer 使用 clippy 检查。
- `<F5>` 能通过 codelldb 启动调试。
- 保存文件时默认不触发格式化。

### 编辑器功能

- `<leader>e` 能切换文件树（snacks explorer）。
- snacks picker 能查找文件和执行 live grep。
- gitsigns 在 Git 仓库中显示 hunk 标记。
- `<C-h/j/k/l>` 能在分屏间导航。
- `<leader>` 能显示 which-key 分组。

snacks 迁徙专项（分阶段复验、快速冒烟）见
[阶段验收步骤](improvements/snacks-migration.md#阶段验收步骤)。

### 平台记录

只有实际执行过验证后，才在 [实现状态](STATUS.md) 中记录平台结果。
