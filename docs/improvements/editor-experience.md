# 编辑体验改进

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md)

## Markdown buffer 内渲染

### 缺口

仓库长期维护多份 Markdown 文档，目前只有语法高亮，没有标题、列表、代码块
和表格的 buffer 内渲染。

### 建议

- 注册 `MeanderingProgrammer/render-markdown.nvim`。
- 新建 `lua/plugins/markdown.lua`。
- 默认只在 Markdown filetype 启用。
- 不引入 npm、浏览器或 markdown-preview.nvim。

### 验收

- README 和 `docs/` 中的 Markdown 可以正常渲染与切换回原始文本。
- 普通编辑、Treesitter 和折叠不受影响。
- 新增按键时同步 [快捷键索引](../KEYMAPS.md)。

## 原生 toggle 层

### 缺口

relative number、wrap、spell、diagnostics、inlay hints、保存格式化和平滑滚动
缺少统一的运行时开关入口。

### 建议

使用 Neovim 原生 API 新建 `lua/core/toggles.lua`，避免为简单状态切换引入
snacks.nvim：

- `<leader>ur`：relative number。
- `<leader>uw`：wrap。
- `<leader>us`：spell。
- `<leader>ud`：diagnostics。
- `<leader>uh`：inlay hints。
- `<leader>uf`：format-on-save。
- `<leader>uS`：smooth scroll。

在 which-key 注册 `<leader>u` group。format-on-save 的启动值仍必须为
`false`。

### 验收

- 每个 toggle 都反馈新状态。
- buffer-local 与 global option 的作用域明确。
- 保存格式化在重启后仍恢复为关闭。

## C-k 映射冲突

### 缺口

smart-splits 全局使用 normal-mode `<C-k>` 向上切换窗口；LSP attach 后又以
buffer-local `<C-k>` 注册函数签名，后者会覆盖前者。

### 建议

优先保留 normal-mode `<C-k>` 的四方向窗口导航一致性：

- insert mode 继续使用 `<C-k>` 显示签名。
- normal mode 签名帮助改用不冲突的 Code 分组键，例如 `<leader>ck`。
- 同步 which-key 描述和快捷键文档。

### 验收

- LSP buffer 和普通 buffer 中 `<C-h/j/k/l>` 都能四方向导航。
- normal 与 insert mode 都有可发现的签名帮助入口。

## Harpoon v2

### 使用场景

Harpoon 适合在少数高频文件间固定跳转，与 fzf-lua 的全量搜索互补。只有实际
使用中频繁需要固定 4–5 个文件时再引入。

### 建议键位

- `<leader>ha`：添加当前文件。
- `<leader>hh`：打开 Harpoon 列表。
- `<leader>h1` ... `<leader>h5`：跳到第 1–5 个固定文件。

不能使用 `<leader>1..9`，这些键已由 bufferline 占用。落地时注册
`<leader>h` which-key group。

### 验收

- 固定列表能按项目持久化。
- 键位不覆盖 bufferline、LSP 或窗口导航。
- Linux / macOS 路径均可正常工作。

## vim.ui.input 界面

### 缺口

fzf-lua 已接管 `vim.ui.select()`，但 DAP 条件断点、log point 和命名会话所用
的 `vim.ui.input()` 仍是原生界面。

### 建议

- 仅在确有体验问题时引入 `stevearc/dressing.nvim`。
- 只启用 input 能力。
- 保持 fzf-lua 继续处理 select。
- 不为此引入 noice.nvim 或 snacks.nvim。

### 验收

- DAP 与 session 输入框可用。
- `vim.ui.select()` 不被 dressing 接管。
