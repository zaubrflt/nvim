# 工具、终端与会话

[返回快捷键索引](../KEYMAPS.md)

## Trouble

Trouble 统一展示诊断、LSP 位置、quickfix 和 location list。以下 Leader
映射均为 toggle。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>xx` | normal | 工作区诊断 |
| `<leader>xX` | normal | 当前 buffer 诊断 |
| `<leader>xs` | normal | 文档符号 |
| `<leader>xl` | normal | LSP 定义、引用与实现 |
| `<leader>xL` | normal | Location list |
| `<leader>xq` | normal | Quickfix list |
| `<leader>xt` | normal | TODO 注释 |
| `]x` / `[x` | normal | 下 / 上一个 Trouble 项；窗口关闭时跳诊断 |

Trouble 窗口内常用 `<CR>` 跳转，`o` / `<C-x>` / `<C-v>` / `<C-t>`
分别在当前窗口、水平分屏、垂直分屏和新 tab 打开，`q` 关闭，`?` 查看帮助。

## TODO 注释

todo-comments 高亮 `TODO`、`FIXME`、`HACK`、`WARN`、`PERF`、`NOTE`、
`TEST` 等关键词。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `]t` / `[t` | normal | 下 / 上一个 TODO 注释 |
| `<leader>ft` | normal | 使用 fzf-lua 搜索工作区 TODO |
| `<leader>xt` | normal | 使用 Trouble 列出 TODO |

## 终端

toggleterm 提供持久的浮窗、水平和垂直终端实例。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-\>` | normal / terminal | 切换默认终端 |
| `<leader>tf` | normal / terminal | 浮窗终端 |
| `<leader>th` | normal / terminal | 水平终端 |
| `<leader>tv` | normal / terminal | 垂直终端 |
| `<leader>tt` | normal / terminal | 切换默认终端 |
| `<leader>tn` | normal | 选择终端实例 |
| `<esc>` / `jk` | terminal | 退出 terminal mode 到 normal mode |
| `<C-h/j/k/l>` | terminal | 退出 terminal mode并移到对应窗口 |

Windows 检测到 PowerShell 7 时会继承 UTF-8 shell 配置。

## 会话

自动会话名为 `cwd@branch`。退出时保存；只有无文件参数启动 Neovim 时才自动
恢复。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>Ss` | normal | 命名保存，默认名为 `cwd@branch` |
| `<leader>Sl` | normal | 从列表选择并加载会话 |
| `<leader>SL` | normal | 加载当前 `cwd@branch` 自动会话 |
| `<leader>Sa` | normal | 加载自动会话但不绑定后续保存 |
| `<leader>Sd` | normal | 删除会话 |
