# 工具、终端、会话与 Pack

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
| `<leader>ft` | normal | 使用 snacks picker 搜索工作区 TODO |
| `<leader>xt` | normal | 使用 Trouble 列出 TODO |

## 终端

终端由 `Snacks.terminal` 提供浮窗与分屏实例。浮窗与水平 / 垂直分屏是**不同
实例**（内部用不同 `count` 区分）；各自再按一次对应键可隐藏。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-\>` | normal / terminal | 切换浮窗终端 |
| `<leader>tf` | normal / terminal | 浮窗终端 |
| `<leader>th` | normal / terminal | 水平分屏终端（底部） |
| `<leader>tv` | normal / terminal | 垂直分屏终端（右侧） |
| `<leader>tt` | normal / terminal | 切换默认（浮窗）终端 |
| `<esc>` / `jk` | terminal | 退出 terminal mode 到 normal mode |
| `<C-h/j/k/l>` | terminal | 退出 terminal mode 并移到对应窗口 |

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

## Pack（vim.pack）

对应 LazyVim 的 `<leader>l`（打开 Lazy）与 AstroNvim 的 `<leader>p*`
插件子命令；本配置 `<leader>p` 已用于剪贴板粘贴，故用 `<leader>l` 前缀映射
原生 `vim.pack`。实现见 `lua/core/pack.lua`。

列表项前的 `*` 表示当前会话已 `vim.pack.add()`（active）。更新类操作会打开
确认 buffer：`:write` 应用，`:quit` 放弃。更完整的流程见
[维护与验证](../MAINTENANCE.md#常用命令) 与
[故障排查](../TROUBLESHOOTING.md#插件与-vimpack)。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>lu` | normal | 检查并更新全部插件 |
| `<leader>lU` | normal | 选择一个插件并更新 |
| `<leader>lb` | normal | 离线浏览已装插件（不 fetch） |
| `<leader>lh` | normal | `:checkhealth vim.pack` |
| `<leader>ll` | normal | 打开 `nvim-pack.log` |
| `<leader>lr` | normal | 删除选中插件并提示 `:restart` 按锁文件重装 |
| `<leader>lx` | normal | 从磁盘删除选中插件（未从 `vim.pack.add()` 移除仍会再装） |

## Profiler

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>dpp` | normal | 切换 snacks profiler |
| `<leader>dph` | normal | 切换 profiler 高亮 |
