# Git 与 Lazygit

[返回快捷键索引](../KEYMAPS.md)

## Gitsigns

gitsigns 在 sign column 中以彩色竖线显示当前 buffer 相对 Git 索引的变化，
并提供 hunk 级操作。新增 / 修改 / 未跟踪使用 `▎`，删除与顶部删除使用
``；颜色由 Nordic 的 `GitSignsAdd`（绿）、`GitSignsChange`（黄）、
`GitSignsDelete`（红）区分。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `]g` / `[g` | normal | 下 / 上一个 hunk |
| `<leader>gp` | normal | 预览 hunk |
| `<leader>gs` | normal / visual | Stage hunk 或选区 |
| `<leader>gr` | normal / visual | Reset hunk 或选区 |
| `<leader>gS` | normal | Stage 当前 buffer |
| `<leader>gR` | normal | Reset 当前 buffer |
| `<leader>gu` | normal | 撤销 stage hunk |
| `<leader>gb` | normal | 当前行完整 blame |
| `<leader>gB` | normal | 切换行尾 blame |
| `<leader>gd` | normal | 与索引 diff |
| `<leader>gD` | normal | 与上一次 commit diff |
| `ih` | visual / operator-pending | 选择一个 hunk |

## Lazygit

Lazygit 负责 commit、rebase、分支、冲突、stash、push/pull 等仓库级操作，
通过 `Snacks.lazygit` 打开。系统 `PATH` 中没有 `lazygit` 时，这些映射不会
注册。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>gg` | normal | 在 cwd 打开 Lazygit |
| `<leader>gG` | normal | 在当前文件目录打开 Lazygit |
| `<leader>gl` | normal | 仓库 log |
| `<leader>gL` | normal | 当前文件 log |
| `<leader>go` | normal / visual | 浏览器打开当前文件 / 选区（gitbrowse） |

Lazygit 浮窗内部使用其自身键位。常用：`c` commit、`a` stage all、
`r` rebase、`b` branches、`P` push、`p` pull。

文件重命名（LSP 集成）见 `<leader>cR`（`Snacks.rename`），与符号 rename
`<leader>rn` 区分。
