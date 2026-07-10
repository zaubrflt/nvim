# 项目背景与需求

[返回 README](../README.md) · [架构与设计](ARCHITECTURE.md) · [实现状态](STATUS.md)

## 项目背景

这是个人 Neovim 配置仓库，面向 C++ 与 Rust 开发，目标版本为
**Neovim ≥ 0.12**。

- 支持平台：Linux / macOS。
- 配置路径：`~/.config/nvim`

配置追求模块边界清晰、依赖可解释，不以复刻完整 Neovim 发行版为目标。

## 原始需求

以下需求是项目基线，后续重构和扩展不得破坏：

0. 支持 Linux / macOS。
1. 提供默认代码缩进、空格缩进等基础配置。
2. 支持 C++（clangd）和 Rust（rust-analyzer）的 LSP，包括补全、跳转、
   悬停与重构。
3. 支持上述语言的调试器。
4. 支持 C++ 使用 `clang-format`、Rust 使用 `rustfmt` 格式化。
5. 支持 C++ 使用 `clang-tidy`、Rust 使用 `clippy` 静态分析。
6. 使用 Treesitter 提供语法高亮。
7. 默认主题使用 `AlexvZyl/nordic.nvim`。
8. 提供 Git 支持。
9. 提供文件目录树。
10. 保存文件时自动格式化必须默认关闭。
11. 配置按功能拆分，不能把多个功能堆入 `init.lua`。
12. 必要快捷键必须文档化。详细快捷键统一维护在
    [快捷键索引](KEYMAPS.md)，README 只提供入口。

## 项目原则

- 优先使用 Neovim 0.12 原生 API。
- 插件只补充明确缺口，避免引入功能高度重叠的框架。
- 系统工具通过平台包管理器安装，不在 Neovim 内部再维护一套工具链。
- 运行配置、用户文档和维护约束分别维护；每类信息只有一个详细来源。
