# 编码、LSP 与调试

[返回快捷键索引](../KEYMAPS.md)

## 补全

blink.cmp 使用 `default` preset，来源包括 LSP、路径、snippet 和当前 buffer。
菜单默认不预选候选项。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-space>` | insert | 显示补全菜单；菜单已显示时切换文档窗口 |
| `<C-e>` | insert | 取消当前预览并隐藏补全菜单 |
| `<C-y>` | insert | 选择并接受候选项 |
| `<Up>` / `<Down>` | insert | 上 / 下一个候选项 |
| `<C-p>` / `<C-n>` | insert | 上 / 下一个候选项 |
| `<C-b>` / `<C-f>` | insert | 向上 / 向下滚动补全文档 |
| `<Tab>` / `<S-Tab>` | insert / select | 向前 / 向后跳转 snippet 占位符 |
| `<C-k>` | insert | 显示或隐藏函数签名 |

这些键来自 blink.cmp 1.x 的 preset；配置位置是
`lua/plugins/completion.lua`。

## 注释

Neovim 0.10+ 原生提供注释操作，无需额外插件。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `gcc` | normal | 切换当前行注释 |
| `gc{motion}` | normal / operator-pending | 切换 motion 范围内的注释，例如 `gcip` |
| `gc` | visual | 切换选中区域注释 |

## 全局诊断

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `[d` / `]d` | normal | 上 / 下一条诊断并打开浮窗 |
| `<leader>cd` | normal | 当前行诊断浮窗 |
| `<leader>cl` | normal | 把诊断写入 location list |

Trouble 的诊断列表见 [工具快捷键](tools.md#trouble)。

## LSP

以下映射在 clangd 或 rust-analyzer 附着后成为 buffer-local 映射。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `gd` | normal | 跳转定义 |
| `gD` | normal | 跳转声明 |
| `gr` | normal | 列出引用 |
| `gi` | normal | 跳转实现 |
| `gy` | normal | 跳转类型定义 |
| `K` | normal | Hover 文档 |
| `<C-k>` | insert | 函数签名 |
| `<leader>ck` | normal | 函数签名 |
| `<leader>rn` | normal | 重命名符号 |
| `<leader>ca` | normal / visual | Code action |
| `<leader>cs` | normal | 文档符号 |
| `<leader>cw` | normal | 工作区符号 |
| `<leader>ci` / `<leader>co` | normal | incoming / outgoing 调用链 |

insert 模式的 `<C-k>` 与 blink.cmp preset 同名，用途相同（显示签名）。
normal 模式使用 `<leader>ck`，避免覆盖 smart-splits 的向上切窗。
inlay hints 用 `<leader>uh` 切换，见 [UI toggle](general.md#ui-toggle)。

LSP 的 fzf-lua 查询快捷键见 [导航快捷键](navigation.md#fzf-lua)。

## 格式化

保存格式化默认关闭。

| 快捷键 / 命令 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>fm` | normal / visual | 手动格式化当前 buffer 或选区 |
| `<leader>uf` | normal | 切换保存格式化（会话内；启动默认关闭） |
| `:FormatEnable` | command | 当前 Neovim 会话启用保存格式化 |
| `:FormatDisable` | command | 关闭保存格式化 |

格式化器：C/C++ 使用 clang-format，Rust 使用 rustfmt，Lua 可选使用 stylua。

## 调试

C、C++ 与 Rust 都通过 nvim-dap 和 codelldb 调试。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<F5>` | normal | 启动或继续 |
| `<F10>` | normal | Step over |
| `<F11>` | normal | Step into |
| `<F12>` | normal | Step out |
| `<leader>db` | normal | 切换普通断点 |
| `<leader>dB` | normal | 输入条件并设置条件断点 |
| `<leader>dl` | normal | 输入日志并设置 log point |
| `<leader>dc` | normal | 运行到光标 |
| `<leader>dr` | normal | 切换 REPL |
| `<leader>dt` | normal | 终止调试会话 |
| `<leader>du` | normal | 切换 DAP UI |
| `<leader>de` | normal / visual | 求值光标处或选中表达式 |

启动配置目前仍可能要求输入 executable 路径。自动推断目标的改进见
[DAP 启动体验](../improvements/project-workflow.md#dap-启动体验)。
