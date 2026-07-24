# snacks.nvim 迁徙计划（对齐 LazyVim）

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md) ·
[架构选型](../ARCHITECTURE.md#选型记录) ·
[发行版对照](distro-lessons.md)

## 目标

引入 [snacks.nvim](https://github.com/folke/snacks.nvim)，**功能启用集合与键位语义参考
LazyVim 默认接线**，插件管理与硬性基线仍遵守本仓库约束：

- 继续只用 `vim.pack`（不引入 lazy.nvim / LazyExtras）。
- 不引入 `noice.nvim`、`edgy.nvim`、`nvim-notify`（LazyVim 常与 snacks 并存，本仓库仍拒绝）。
- LSP / 格式化 / Treesitter / DAP 路径不变；`vim.g.user_format_on_save` 启动仍为
  `false`。
- 新逻辑放在独立 `lua/plugins/snacks.lua`（及必要的拆分），不堆进 `init.lua`。

本文件是迁徙的**唯一详细方案来源**（含[阶段验收步骤](#阶段验收步骤)）。落地时按
阶段改代码与文档；完成后把本项从
[计划实现](../STATUS.md#计划实现)移到[已实现](../STATUS.md#已实现)，并修订
[架构](../ARCHITECTURE.md) 中「明确不采用 snacks」的表述。

## 背景与决策变更

历史立场见 [ARCHITECTURE 明确不采用](../ARCHITECTURE.md#明确不采用) 与
[distro-lessons](distro-lessons.md)：曾因「范围过大、已有单点替代」拒绝全家桶。

当前决策改为：**接受 snacks 作为 UX 中枢**，用 LazyVim 已验证的模块组合替换分散的
等价插件，换取一致体验（尤其 `bufdelete`、picker、explorer、toggle、notifier）。

原则仍是「抄 LazyVim 配方，不抄依赖图」：只迁 snacks 相关能力，不迁 Mason、
rustaceanvim、format-on-save 默认开启、noice 等。

## LazyVim 中 snacks 的实际用法（对照基准）

### 默认 `setup` 启用（LazyVim UI 配置）

| 模块 | LazyVim | 说明 |
| --- | --- | --- |
| `indent` | 开 | 缩进线 |
| `input` | 开 | 美化 `vim.ui.input` |
| `notifier` | 开 | 美化 `vim.notify` + 历史 |
| `scope` | 开 | 基于 indent/treesitter 的 scope |
| `scroll` | 开 | 平滑滚动 |
| `statuscolumn` | 关 | LazyVim 在 options 另配 |
| `toggle` | 开 | `<leader>u*` 开关框架 |
| `words` | 开 | LSP 引用高亮与跳转 |
| `dashboard` | 开 | 启动页（另段配置） |

### 主要通过 keymap / 其他插件调用（未必在 opts 里 `enabled`）

| 能力 | LazyVim 典型入口 | 本仓库现状 |
| --- | --- | --- |
| `bufdelete` | `<leader>bd` / bufferline close | `:bdelete`（布局不友好） |
| `picker` | 大量 `<leader>f*` / `<leader>s*` / LSP goto | fzf-lua |
| `explorer` | `<leader>e` | nvim-tree |
| `terminal` | `<C-\>` / `<leader>ft` 等 | toggleterm |
| `lazygit` | `<leader>gg` | lazygit.nvim |
| `gitbrowse` | `<leader>gB` | 无（且 `<leader>gB` 已被 gitsigns blame 占用） |
| `zen` / zoom | `<leader>uz` / `<leader>wm` | 无 |
| `profiler` | `<leader>dpp` 等 | 无 |
| `rename`（文件） | `<leader>cR` 一类 | 仅有符号 rename |
| `bigfile` / `quickfile` | 常开 | 无 |
| `scratch` | `<leader>.` | 无 |

参考：[LazyVim UI](https://www.lazyvim.org/plugins/ui)、
[LazyVim keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)、
[snacks README](https://github.com/folke/snacks.nvim)。

## 与现有插件的冲突矩阵

迁徙必须二选一，避免双绑定与双 UI。

| snacks 模块 | 现有实现 | 建议 | 理由 |
| --- | --- | --- | --- |
| `bufdelete` | `core/keymaps` `:bdelete` | **替换** | 直接修复关 buffer 时 nvim-tree 全屏问题 |
| `picker` | fzf-lua | **替换** | 对齐 LazyVim 主路径；`vim.ui.select` 改由 snacks 或保留过渡期 |
| `explorer` | nvim-tree | **替换** | LazyVim 默认 explorer 路径；bufferline offset 需改 filetype |
| `terminal` | toggleterm | **替换** | 减少终端栈重复；键位映射到 `Snacks.terminal` |
| `lazygit` | lazygit.nvim | **替换** | `Snacks.lazygit` 即可 |
| `scroll` | neoscroll | **替换** | 对齐 LV；保留 `<leader>uS` 可关平滑滚动 |
| `indent` + `scope` | mini.indentscope | **替换 indentscope** | 保留 mini.pairs / surround / ai |
| `toggle` | `core/toggles.lua` | **替换** | 用 `Snacks.toggle` 重建；**强制保留 format-on-save 默认关** |
| `input` | 原生 / 计划 dressing | **启用 snacks.input** | 取消 dressing 计划项或标为被本方案吸收 |
| `notifier` | 原生 `vim.notify` | **启用** | 不引入 nvim-notify / noice |
| `words` | 无 | **启用** | 补齐 LSP 引用导航 |
| `dashboard` | 无（resession） | **可选阶段** | 若启用，会话按钮对接 resession，不要 persistence |
| `zen` / zoom / scratch / profiler / gitbrowse / rename / bigfile | 无或局部 | **后置阶段** | 按 LazyVim 键位补齐，注意与本仓库现有 `<leader>gB` 等冲突 |

**明确不迁（即使 LazyVim 有）：**

- `noice.nvim`、`edgy.nvim`、`nvim-notify`
- lazy.nvim UI / LazyExtras / Mason
- 把保存格式化默认改为开启
- 把 `<leader>w` 改成 Window 组（会破坏当前「保存」键；窗口关闭继续用
  `<leader>q`，退出用 `<leader>Q` 或另议 `qq`）

## 目标模块启用表（本仓库）

与 LazyVim 对齐的推荐最终态：

```lua
-- 示意：实际落在 lua/plugins/snacks.lua
require('snacks').setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  dashboard = { enabled = false }, -- 阶段 D 再开；默认先关
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  picker = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = true },
  -- bufdelete / terminal / lazygit / zen / gitbrowse / rename / toggle
  -- 多为 API，按需 keymap 调用，不必全部写在 opts
})
```

## 阶段计划

每阶段结束都应能稳定日常使用；不要一次拆掉所有旧插件。

### 阶段 0：文档与架构准入（本阶段产出）

1. 本文件入库；[IMPROVEMENTS](../IMPROVEMENTS.md) / [STATUS](../STATUS.md) 挂上计划项。
2. 实现开始前修订 [ARCHITECTURE](../ARCHITECTURE.md)：
   - 从「明确不采用」移除 `snacks.nvim`；
   - 在选型记录中写明「UX 中枢改为 snacks，对齐 LazyVim 模块集；仍拒绝
     noice/edgy/dashboard 类独立插件（dashboard 若启用则用 snacks.dashboard）」。
3. 更新 [distro-lessons](distro-lessons.md)「明确不借鉴」表：snacks 全家桶一行改为
   「已改为计划迁徙，见 snacks-migration」。

**验收：** 文档一致，无代码行为变化。

### 阶段 A：接入 snacks + 无冲突增量（低风险）

**代码：**

1. `lua/plugins/init.lua` 注册
   `{ src = 'https://github.com/folke/snacks.nvim' }`。
2. 新建 `lua/plugins/snacks.lua`：`pcall(require, 'snacks')` 后 `setup`。
3. **加载顺序：** snacks 应尽早 `setup`（在依赖其 API 的 bufferline / toggle /
   picker 键位之前）。建议紧接 colorscheme 之后、或与 core 插件加载并行但保证
   首次 `Snacks.*` 调用前已 setup。
4. 本阶段只启用：`bigfile`、`quickfile`、`input`、`notifier`、`words`，以及
   **keymap 调用** `Snacks.bufdelete`。
5. 修改 `lua/core/keymaps.lua`：
   - `<leader>bd` → `Snacks.bufdelete()`
   - 新增 `<leader>bD` → 删 buffer 且关窗口（对齐 LV `:bd`）
6. 修改 `lua/plugins/bufferline.lua`：`close_command` /
   `right_mouse_command` 改为 `Snacks.bufdelete`。
7. 可选：`<leader>bo` / `<leader>bi` 改为 `Snacks.bufdelete.other()` /
   `invisible()`（替换 BufferLineCloseOthers 的「关其他」语义时需在文档说明差异）。

**暂不删：** fzf-lua、nvim-tree、toggleterm、neoscroll、mini.indentscope、
`core/toggles.lua`。

**文档：** 更新 `docs/keymaps/general.md` Buffer 节；STATUS 将该阶段标为进行中/完成。

**验收：**

- `:checkhealth snacks` 通过。
- 侧栏开着时 `<leader>bd`：标签消失，explorer **不**全屏。
- 未保存 buffer 弹出确认（Yes/No/Cancel）。
- `vim.notify` 走 notifier；`vim.ui.input`（如 resession 命名）可用 input UI。
- 打开大文件时 bigfile 降级行为可感知（或至少无报错）。
- 保存格式化启动仍为关。

### 阶段 B：替换滚动 / 缩进 / toggle（中风险）

1. **scroll：** 启用 `scroll = { enabled = true }`；删除 neoscroll 注册与
   `lua/plugins/scroll.lua`；用 `vim.pack.del` 清磁盘副本。
   - `<C-f/b/d/u>` 交给 snacks.scroll（不要在 core 重复绑定）。
   - `<leader>uS` 改为 `Snacks.toggle.scroll()` 或等价，语义保持「可关平滑滚动」。
2. **indent / scope：** 启用二者；从 `editing.lua` 移除 mini.indentscope 安装与
   setup；保留 mini.pairs / surround / ai。
3. **toggle：** 用 `Snacks.toggle` 重建 `lua/core/toggles.lua`（可改名为仍由
   snacks 模块挂键，或薄封装）：
   - 必保：relativenumber、wrap、spell、diagnostics、inlay_hints、
     **format_on_save（默认 false）**、scroll。
   - 可按 LV 追加：line number、conceallevel、treesitter、dim、indent、
     background 等（新增键必须有 `desc` 并写文档）。
4. 更新 `docs/keymaps/general.md` 滚动与 UI toggle；MAINTENANCE 中「不要重复绑定
   neoscroll」改为 snacks.scroll。

**验收：** 翻页平滑；缩进线正常；`<leader>u*` 可切换且 format-on-save 默认关；
无 neoscroll / indentscope 残留报错。

### 阶段 C：替换 picker / explorer / terminal / lazygit（高风险）

按子步骤做，每步可独立提交式验证。

#### C1. Picker

1. 启用 `picker`；将 `lua/plugins/picker.lua` 从 fzf-lua 改为 snacks picker
   键位表。
2. 键位策略（推荐 **保持本仓库 `<leader>f*` 前缀**，降低肌肉记忆成本；语义对齐
   LV，不必照搬 LV 的 `<leader>s*` 分裂）：

   | 本仓库键 | 迁到 |
   | --- | --- |
   | `<leader>ff` | `Snacks.picker.files` |
   | `<leader>fg` | `Snacks.picker.grep` |
   | `<leader>fb` / `fr` / `fl` … | 对应 buffers / recent / lines … |
   | LSP / Git 子键 | `Snacks.picker.lsp_*` / `git_*` |
   | `<leader>f.` resume | `Snacks.picker.resume` |
   | `vim.ui.select` | snacks picker 的 select 集成（若官方 API 可用） |

3. todo-comments 的 `<leader>ft`、Trouble 相关若依赖 fzf，改为 snacks 或 Trouble
   自带入口。
4. 移除 fzf-lua 注册与 `vim.pack.del`。

**验收：** 大仓库文件搜索与 live grep 可接受；code action / select UI 可用；
文档 `docs/keymaps/navigation.md` 已改「fzf-lua」表述。

#### C2. Explorer

1. 启用 `explorer`；`<leader>e` → `Snacks.explorer()`（或 LV 等价 toggle）。
2. 迁移或废弃 `<leader>fe` / `<leader>fc`（若 snacks explorer API 无精确对等，
   文档写明替代操作）。
3. bufferline `offsets`：`NvimTree` → snacks explorer 对应 filetype（实现时以
   实机 `filetype` 为准，常见为 `snacks_picker` / layout 相关类型，需验证）。
4. session.lua 中跳过非真实 buffer 的规则加入 explorer filetype。
5. neoscroll 已删则忽略；若滚动排除列表仍在别处，更新之。
6. 移除 nvim-tree（及是否保留 nvim-web-devicons：其他 UI 若仍需要则保留）。

**验收：** 开关树、打开文件、与 bufferline offset 无重叠；`<leader>bd` + 侧栏布局
仍正确。

#### C3. Terminal + Lazygit

1. `<C-\>`、`<leader>tf/th/tv/tt` 映射到 `Snacks.terminal` 浮窗/分屏变体（按
   snacks API 对齐现有语义；对不上的键删除并改文档）。
2. `<leader>gg` / `gG` → `Snacks.lazygit`（cwd / 文件目录语义对齐现文档）。
3. 移除 toggleterm、lazygit.nvim。

**验收：** 浮窗/分屏终端、lazygit、从 terminal 用 `<C-h/j/k/l>` 离开的行为与
smart-splits 不冲突（按 snacks + smart-splits 实测调整）。

### 阶段 D：LazyVim 增值能力（按需）

每项可单独合并，互不阻塞。

| 项 | 建议键位 | 冲突注意 |
| --- | --- | --- |
| `gitbrowse` | 建议 `<leader>go` 或 `<leader>gY` 复制 URL | **不要占用** 现有 `<leader>gB`（blame） |
| `zen` / zoom | `<leader>uz` / `<leader>uZ` 或 `<leader>wm` | `<leader>u` group 已存在 |
| `scratch` | `<leader>.` / 选择列表 | 确认不与现有映射冲突 |
| 文件 `rename` | `<leader>cR` 或 `<leader>R` | 与符号 `<leader>rn` 区分 |
| `profiler` | `<leader>dpp` 等 | 挂在 Debug group |
| `dashboard` | 启用后用 resession 做 Restore Session | 去掉 Lazy/LazyExtras 按钮；无文件参数启动才显示，避免破坏「带参数打开文件」 |

**验收：** 各项单独可开可关；文档与 which-key group 已更新。

### 阶段 E：清理与架构收口

1. 确认无残留 `require('fzf-lua')` / `nvim-tree` / `toggleterm` / `neoscroll` /
   `lazygit` / `mini.indentscope`。
2. `nvim-pack-lock.json` 仅由 `vim.pack` 更新，不手改。
3. 修订 ARCHITECTURE 插件列表与加载顺序图；TROUBLESHOOTING 增加 snacks 常见问题
   （picker 慢、explorer filetype、notifier 挡住消息等）。
4. 将 [editor-experience 的 vim.ui.input](editor-experience.md#vimuiinput-界面)
   标为「由 snacks.input 吸收」或关闭。
5. distro-lessons 对照表改为「UX 中枢 = snacks」。
6. 按 [MAINTENANCE 验证清单](../MAINTENANCE.md#验证清单) 做一次完整核对。

## 建议文件变更清单

| 路径 | 动作 |
| --- | --- |
| `lua/plugins/init.lua` | 增 snacks；阶段性删旧插件 |
| `lua/plugins/snacks.lua` | **新建**：setup + 多数 Snacks 键位 |
| `lua/core/keymaps.lua` | `bd` / `bD`；可能精简与 snacks 重复的项 |
| `lua/core/toggles.lua` | 改为 Snacks.toggle 或删除并由 snacks.lua 接管 |
| `lua/plugins/bufferline.lua` | close → bufdelete；offset filetype |
| `lua/plugins/picker.lua` | 重写为 snacks picker 或并入 snacks.lua |
| `lua/plugins/filetree.lua` | 删除（阶段 C2） |
| `lua/plugins/scroll.lua` | 删除（阶段 B） |
| `lua/plugins/terminal.lua` | 删除（阶段 C3） |
| `lua/plugins/lazygit.lua` | 删除（阶段 C3） |
| `lua/plugins/editing.lua` | 去掉 indentscope |
| `lua/plugins/session.lua` | 排除 snacks explorer / dashboard buffer |
| `lua/plugins/whichkey.lua` | 按新增前缀补 group |
| `docs/keymaps/*.md`、`KEYMAPS.md` | 随阶段更新 |
| `docs/ARCHITECTURE.md`、`STATUS.md`、`TROUBLESHOOTING.md` | 阶段 0 / E |
| `nvim-pack-lock.json` | 仅自动变更 |

## 键位迁移原则

1. **优先保留本仓库已有 leader 字母**（`f` 找文件、`e` 树、`t` 终端、`g` Git、
   `u` UI、`b` buffer），避免强迫切换到 LazyVim 的 `s` search 分裂，除非用户后续
   要求全盘 LV 键位。
2. 所有新 keymap 必须有 `desc`；分组变化才改 `KEYMAPS.md`。
3. 不抢占：`<C-h/j/k/l>`（smart-splits）、`s`/`S`（Flash）、`gs*`（mini.surround）、
   `<leader>p`（剪贴板）、`<leader>l*`（vim.pack）。
4. `<leader>q` / `<leader>Q` 维持「关窗口 / 强制退出」；关文件统一走
   `<leader>bd`（与 LV 一致：关文件 ≠ `:quit`）。

## 风险与缓解

| 风险 | 缓解 |
| --- | --- |
| snacks 体积与启动变慢 | 阶段 A 先测 startup；开启 `quickfile`；避免无用模块 |
| picker 在超大 C++/Rust 树不如 fzf 二进制 | C1 验收时对比；若不可接受可保留 fzf-lua 仅作 grep 后端或回退（需在 STATUS 记录） |
| explorer 与 bufferline / session 不兼容 | C2 专项测 offset、session 保存内容 |
| 与 smart-splits / Flash 键位冲突 | 终端与滚动排除列表实测 |
| 文档与「不采用 snacks」矛盾 | 阶段 0 先改架构文档再写代码 |
| 一次大爆炸难回滚 | 严格按 A→B→C→D 阶段；每阶段可运行 |

## 非目标

- 不复刻 LazyVim 发行版或 extras 市场包。
- 不引入 noice / edgy / mason / lazy.nvim。
- 不改变 C++/Rust LSP、DAP、conform、Treesitter `main` 策略。
- 不默认开启 format-on-save。

## 建议落地顺序（摘要）

1. 阶段 0 文档准入（含 ARCHITECTURE 修订许可）。
2. 阶段 A：`bufdelete` + input/notifier/words/bigfile（立刻解决关文件问题）。
3. 阶段 B：scroll / indent / toggle。
4. 阶段 C1→C2→C3：picker → explorer → terminal/lazygit。
5. 阶段 D 按需增值。
6. 阶段 E 清理与验证。

实现任一阶段前，仍须按 AGENTS 约定：说明拟改文件并取得明确许可后再动代码。

## 阶段验收步骤

每阶段结束都应能稳定日常使用后再进入下一阶段。一次落地后也可按本节复验。
通用基线核对见 [维护与验证](../MAINTENANCE.md#验证清单)；本节只覆盖 snacks
迁徙专项。

### 阶段 0：文档准入

- [ARCHITECTURE](../ARCHITECTURE.md) 已从「明确不采用」移除 snacks，选型写明
  UX 中枢 = snacks。
- [STATUS](../STATUS.md) / [IMPROVEMENTS](../IMPROVEMENTS.md) 与本文件状态一致。
- 本阶段无代码行为变化。

### 阶段 A：接入 + 无冲突增量

**验收状态（Linux，2026-07-24）：已通过。**

1. `:checkhealth snacks` 通过。
2. 侧栏开着时 `<leader>bd`：标签消失，explorer **不全屏**。
3. 未保存 buffer 关闭时出现 Yes/No/Cancel。
4. `vim.notify` 走 notifier；`vim.ui.input`（如 `<leader>Ss` 命名会话）可用
   snacks.input（需在正常 TUI 会话中测；`UIEnter` 后生效）。
5. 打开大文件时 bigfile 降级可感知，或至少无报错。
6. `:lua =vim.g.user_format_on_save` 启动值为 `false`。

### 阶段 B：scroll / indent / toggle

**验收状态（Linux，2026-07-24）：已通过。**

1. `<C-f/b/d/u>` 平滑滚动；`<leader>uS` 可关回原生翻页。
2. 缩进线可见；`ii` / `ai`、`[i` / `]i`（snacks.scope）正常。
3. `<leader>u*` 可切换；`<leader>uf` 默认关，开后再关一次确认。
4. 启动与 `:messages` 无 neoscroll / mini.indentscope 残留报错。

### 阶段 C1：Picker

**验收状态（Linux，2026-07-24）：已通过**（含修复 which-key「Find: git」
分组遮挡 `<leader>fg` 后的复验；Git picker 为 `fgs` / `fgc` / `fgC` / `fgb`）。

1. `<leader>ff` 大仓库文件搜索、`<leader>fg` live grep 可接受。
2. `<leader>fa` / LSP code action 的 `vim.ui.select` 弹出 snacks picker。
3. `<leader>f.` resume、`<leader>ft` TODO 搜索可用。
4. [导航快捷键](../keymaps/navigation.md) 主路径表述为 snacks picker，而非
   fzf-lua。

### 阶段 C2：Explorer

**验收状态（Linux，2026-07-24）：已通过。**

1. `<leader>e` 开关树；`<leader>fe` 定位当前文件（折叠全部在 explorer 内用
   `Z`，无独立 `<leader>fc`）。
2. 从树打开文件；bufferline offset 不与标签重叠。实机 filetype 预期为
   `snacks_picker_list`；不符时用 `:lua =vim.bo.filetype` 核对后改
   `lua/plugins/bufferline.lua`。
3. 侧栏开着再测 `<leader>bd`，布局仍正确。
4. 会话保存 / 恢复不把 explorer 当普通文件 buffer。

### 阶段 C3：Terminal + Lazygit

**验收状态（Linux，2026-07-25）：已通过**（含为 `th`/`tv` 分配独立
`count`，避免与浮窗终端共用实例）。

1. `<C-\>` / `<leader>tf` 浮窗；`<leader>th` / `tv` 分屏终端。
2. 终端内 `<esc>` / `jk` 退出 insert；`<C-h/j/k/l>` 能离开且不与
   smart-splits 死锁。
3. `<leader>gg` / `gG` / `gl` / `gL`（需 `PATH` 有 `lazygit`）。
4. 无 toggleterm / lazygit.nvim 加载错误。

### 阶段 D：增值（本仓库 dashboard 默认关闭）

**验收状态（Linux，2026-07-25）：已通过**（`<leader>go` 的 `desc` 由
`Git: browse in browser` 改为 `Git: browse`，避免 which-key 截成 “brows”）。

| 项 | 步骤 |
| --- | --- |
| gitbrowse | `<leader>go` 打开远端；不占用 `<leader>gB`（blame） |
| zen / zoom | `<leader>uz` / `<leader>uZ` |
| scratch | `<leader>.` 开关；`<leader>u.` 选择列表 |
| 文件 rename | `<leader>cR`（与 `<leader>rn` 符号 rename 区分） |
| profiler | `<leader>dpp` / `<leader>dph` |
| dashboard | **应仍关闭**；无文件参数启动走 resession，不出现 snacks 启动页 |

### 阶段 E：清理与收口

**验收状态（Linux，2026-07-25）：已通过。**

1. 代码无残留 `require`：`fzf-lua` / `nvim-tree` / `toggleterm` / `neoscroll` /
   `lazygit`（插件）/ `mini.indentscope`。
2. `nvim-pack-lock.json` 含 snacks、无上述旧插件（仅由 `vim.pack` 自动更新，
   勿手改）。
3. 按 [维护验证清单](../MAINTENANCE.md#验证清单) 完整核对一次。
4. 再次确认 format-on-save 默认关闭。

### 快速冒烟（全阶段一次过）

在真实 TUI 会话中依次确认：

```text
:lua =vim.g.user_format_on_save   → false
:checkhealth snacks
<leader>e → 开文件 → <leader>bd
<leader>ff / <leader>fg
<C-\> 终端 → <C-h> 离开
<leader>ur / <leader>uf / <leader>uS
```
