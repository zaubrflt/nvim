# Git 与 Lazygit

[返回快捷键索引](../KEYMAPS.md)

## Gitsigns

gitsigns 在 sign column 中显示当前 buffer 相对 Git 索引的变化，并提供
hunk 级操作。当前字符为新增 `+`、修改 `~`、删除 `_`、顶部删除 `‾`、
未跟踪 `┆`；“修改后删除”仍使用 `~`。

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

VSCode 风格彩色竖线标记仍是计划项，见
[编辑体验改进](../improvements/editor-experience.md#git-变更标记)。

## Lazygit

Lazygit 负责 commit、rebase、分支、冲突、stash、push/pull 等仓库级操作。
系统 `PATH` 中没有 `lazygit` 时，这些映射不会注册。

| 快捷键 | 模式 | 说明 |
| --- | --- | --- |
| `<leader>gg` | normal | 在仓库根打开 Lazygit |
| `<leader>gG` | normal | 打开当前文件所在仓库 |
| `<leader>gl` | normal | 仓库 log |
| `<leader>gL` | normal | 当前文件 log |

Lazygit 浮窗内部使用其自身键位。常用：`c` commit、`a` stage all、
`r` rebase、`b` branches、`P` push、`p` pull。
