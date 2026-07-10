# Neovim 0.12 配置

一份面向 C++ 与 Rust、模块化的 Neovim 配置，支持 Linux / macOS；插件由
Neovim 0.12 内置 `vim.pack` 管理。

核心能力包括：

- clangd / rust-analyzer LSP 与 blink.cmp 补全。
- clang-format / rustfmt 格式化，clang-tidy / clippy 静态分析。
- Treesitter 高亮、文本对象与上下文。
- nvim-dap + codelldb 调试。
- Git、文件树、模糊查找、终端、会话和窗口导航。

保存时自动格式化默认关闭；使用 `<leader>fm` 手动格式化。

## 快速开始

需要 **Neovim ≥ 0.12**、Git，以及所用语言对应的工具链。完整依赖与各平台
安装命令见 [安装与依赖](docs/SETUP.md)。

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

首次启动安装插件后执行一次：

```vim
:TsEnsure
```

## 文档

- [项目背景与原始需求](docs/PROJECT.md)
- [架构与设计](docs/ARCHITECTURE.md)
- [实现与计划状态](docs/STATUS.md)
- [安装与系统依赖](docs/SETUP.md)
- [快捷键索引](docs/KEYMAPS.md)
- [改进建议索引](docs/IMPROVEMENTS.md)
- [维护与验证](docs/MAINTENANCE.md)
- [日志与故障排查](docs/TROUBLESHOOTING.md)
- [AI 修改约束](AGENTS.md)

## 常用入口

- `<leader>` 为 `Space`；停顿片刻会显示 which-key 导航。
- `<leader>e`：切换文件树。
- `<leader>ff`：查找文件。
- `<leader>fg`：全文搜索。
- `<leader>fm`：手动格式化。
- `<leader>gg`：打开 lazygit。
- `<F5>`：启动或继续调试。

全部键位及分组见 [快捷键索引](docs/KEYMAPS.md)。

## 排查

先执行 `:messages` 与 `:checkhealth`。LSP、Treesitter、DAP、vim.pack 相关
问题见 [日志与故障排查](docs/TROUBLESHOOTING.md)。
