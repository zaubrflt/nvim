# 快捷键索引

[返回 README](../README.md)

`<leader>` 是 `Space`。`<localleader>` 也预留为 `Space`，当前没有单独的
localleader 映射。按下 Leader 后停顿片刻，which-key 会根据 keymap 的
`desc` 展示可用后续按键。

## 专题

- [通用、窗口、滚动、Buffer 与 UI toggle](keymaps/general.md)
- [补全、注释、LSP、诊断、格式化与调试](keymaps/coding.md)
- [文件、搜索、大纲、文本对象与跳转](keymaps/navigation.md)
- [Git 与 Lazygit](keymaps/git.md)
- [Trouble、TODO、终端、会话与 Pack](keymaps/tools.md)

## Leader 分组

| 前缀 | 分组 | 详情 |
| --- | --- | --- |
| `<leader>b` | Buffer | [通用与窗口](keymaps/general.md#buffer) |
| `<leader>c` | Code / Diagnostics | [编码](keymaps/coding.md#lsp) |
| `<leader>d` | Debug | [编码](keymaps/coding.md#调试) |
| `<leader>f` | File / Find / Format | [编码](keymaps/coding.md#格式化) / [导航](keymaps/navigation.md) / [TODO](keymaps/tools.md#todo-注释) |
| `<leader>g` | Git | [Git](keymaps/git.md) |
| `<leader>l` | Pack | [工具](keymaps/tools.md#pack-vimpack) |
| `<leader>r` | Refactor | [编码](keymaps/coding.md#lsp) |
| `<leader>x` | Trouble | [工具](keymaps/tools.md#trouble) |
| `<leader>S` | Session | [工具](keymaps/tools.md#会话) |
| `<leader>t` | Terminal | [工具](keymaps/tools.md#终端) |
| `<leader>u` | UI | [通用](keymaps/general.md#ui-toggle) |

## Leader 单键

| 快捷键 | 用途 | 详情 |
| --- | --- | --- |
| `<leader>w` / `<leader>q` / `<leader>Q` | 保存 / 退出窗口 / 强制退出全部 | [通用](keymaps/general.md#通用) |
| `<leader>e` | 切换文件树 | [文件树](keymaps/navigation.md#文件树) |
| `<leader>.` | 切换 scratch buffer | [通用](keymaps/general.md#通用) |
| `<leader>n` | 通知历史 | [通用](keymaps/general.md#通用) |
| `<leader>y` / `<leader>Y` / `<leader>p` | 系统剪贴板 | [通用](keymaps/general.md#通用) |
| `<leader>O` | 切换代码大纲 | [代码大纲](keymaps/navigation.md#代码大纲) |
| `<leader>1` ... `<leader>9` | 跳到第 N 个 buffer | [Buffer](keymaps/general.md#buffer) |

## 非 Leader 前缀

| 前缀 | 用途 | 详情 |
| --- | --- | --- |
| `<C-h/j/k/l>` | 分屏和复用器 pane 导航 | [通用与窗口](keymaps/general.md#窗口与分屏) |
| `g*` | LSP、注释、surround 等动作 | [编码](keymaps/coding.md) / [导航](keymaps/navigation.md#编辑增强) |
| `[` / `]` | 诊断、hunk、TODO、context、文本对象导航 | [编码](keymaps/coding.md#全局诊断) / [导航](keymaps/navigation.md#treesitter-context) / [Git](keymaps/git.md#gitsigns) / [工具](keymaps/tools.md) |
| `s` / `S` | Flash 跳转 | [导航](keymaps/navigation.md#flash) |
| `<F5>` / `<F10>` / `<F11>` / `<F12>` | 调试控制 | [编码](keymaps/coding.md#调试) |
