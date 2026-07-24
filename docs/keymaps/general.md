# 通用、窗口与 Buffer

[返回快捷键索引](../KEYMAPS.md)

## 通用

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>w` | normal | 保存当前文件 |
| `<leader>q` | normal | 关闭当前窗口 |
| `<leader>Q` | normal | 强制退出全部 Neovim 窗口 |
| `<esc>` | normal | 清除搜索高亮 |
| `<` / `>` | visual | 减少 / 增加缩进并保持选区 |
| `J` / `K` | visual | 向下 / 向上移动选中行 |
| `n` / `N` | normal | 下 / 上一个搜索结果并居中 |
| `<leader>y` | normal / visual | yank 到系统剪贴板 |
| `<leader>Y` | normal | yank 当前行到系统剪贴板 |
| `<leader>p` | normal / visual | 从系统剪贴板粘贴 |
| `<leader>.` | normal | 切换 scratch buffer |
| `<leader>n` | normal | 通知历史 |

## 窗口与分屏

`<C-h/j/k/l>` 由 smart-splits 接管。位于 Neovim 分屏边缘时，它可以继续
穿越 tmux、wezterm 或 kitty pane；没有复用器时等价于普通窗口导航。
LSP 的 normal 模式签名帮助使用 `<leader>ck`，不占用 `<C-k>`。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>-` | normal | 水平分屏（下方，复用当前 buffer） |
| `<leader>\|` | normal | 垂直分屏（右侧，复用当前 buffer） |
| `<C-h>` / `<C-j>` | normal | 移到左 / 下窗口或 pane |
| `<C-k>` / `<C-l>` | normal | 移到上 / 右窗口或 pane |
| `<M-h>` / `<M-j>` | normal | 向左 / 下调整分屏大小 |
| `<M-k>` / `<M-l>` | normal | 向上 / 右调整分屏大小 |
| `<C-Up>` / `<C-Down>` | normal | 原生纵向调整窗口大小 |
| `<C-Left>` / `<C-Right>` | normal | 原生横向调整窗口大小 |
| `<leader><leader>h` / `<leader><leader>j` | normal | 与左 / 下窗口交换 buffer |
| `<leader><leader>k` / `<leader><leader>l` | normal | 与上 / 右窗口交换 buffer |

方向由 `splitbelow` / `splitright` 决定。终端分屏仍用
`<leader>th` / `<leader>tv`。

## 滚动

以下映射由 snacks.scroll 接管。`<leader>uS` 可临时关闭平滑滚动，回退到
原生翻页。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<C-f>` / `<C-b>` | normal / visual | 平滑向下 / 向上翻一页 |
| `<C-d>` / `<C-u>` | normal / visual | 平滑向下 / 向上翻半页 |

## UI toggle

运行时开关，不持久化；重启后恢复默认。实现见 `lua/core/toggles.lua`
（`Snacks.toggle`）。

| 快捷键 | 模式 | 作用域 | 说明 |
| --- | --- | --- | --- |
| `<leader>ur` | normal | window | 切换相对行号 |
| `<leader>uw` | normal | window | 切换折行 |
| `<leader>us` | normal | window | 切换拼写检查 |
| `<leader>ud` | normal | global | 切换诊断显示 |
| `<leader>uh` | normal | buffer | 切换 inlay hints |
| `<leader>uf` | normal | session | 切换保存时格式化（启动默认关闭） |
| `<leader>uS` | normal | session | 切换平滑滚动（启动默认开启） |
| `<leader>ul` | normal | window | 切换行号 |
| `<leader>uc` | normal | window | 切换 conceallevel |
| `<leader>uT` | normal | buffer | 切换 Treesitter 高亮 |
| `<leader>ug` | normal | global | 切换缩进线 |
| `<leader>uD` | normal | global | 切换 dim |
| `<leader>ub` | normal | global | 切换 dark / light background |
| `<leader>uz` | normal | session | 切换 Zen 模式 |
| `<leader>uZ` | normal | session | 切换 Zoom |
| `<leader>u.` | normal | session | 选择 scratch buffer |
| `<leader>un` | normal | session | 关闭全部通知 |

`<leader>uf` 与 `:FormatEnable` / `:FormatDisable` 共用
`vim.g.user_format_on_save`。

## Buffer

关 buffer 使用 `Snacks.bufdelete`，避免侧栏 explorer 被撑满整屏。
`<leader>bo` 使用 `Snacks.bufdelete.other()`（关其他 listed buffer），与
旧 BufferLineCloseOthers 语义接近但不依赖 bufferline 分组。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<S-l>` / `<S-h>` | normal | 下 / 上一个 buffer |
| `<leader>bd` | normal | 删除当前 buffer（保留窗口布局） |
| `<leader>bD` | normal | 删除当前 buffer 并关闭窗口（`:bd`） |
| `<leader>1` ... `<leader>9` | normal | 跳到第 N 个 buffer |
| `<leader>bp` | normal | 切换当前 buffer 的 pin |
| `<leader>bP` | normal | 关闭所有未 pin 的 buffer |
| `<leader>bo` | normal | 关闭其他 buffer |
| `<leader>br` / `<leader>bl` | normal | 关闭右侧 / 左侧 buffer |
