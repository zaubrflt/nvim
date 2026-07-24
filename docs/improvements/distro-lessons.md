# LazyVim / AstroNvim / NvChad 可借鉴项

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md) ·
[架构选型](../ARCHITECTURE.md#选型记录)

对照仓库内 `LazyVim/`、`AstroNvim/` 与 `NvChad/` 源码，整理对本配置有参考价值的
能力。目标是**按缺口 cherry-pick**，不是复刻发行版。生命周期状态仍以
[实现状态](../STATUS.md) 为准；具体落地论证可再拆到各专题文档。

`NvChad/` 为 v2.5 **主插件仓**（需配合 starter 使用）。`NvChad/ui`、base46、自定
义 term / tabufline 等在独立仓库；本树对照以主仓插件表、options、mappings 与
autocmds 为准。

对照时的本仓库边界（不可破坏）：

- 插件管理：`vim.pack`（不用 lazy.nvim）
- LSP：原生 `vim.lsp.config()` / `vim.lsp.enable()`（不用 nvim-lspconfig、mason）
- Rust：直接 rust-analyzer（不用 rustaceanvim）
- 静态分析：clangd `--clang-tidy` + clippy（不用 none-ls）
- 保存格式化：默认关闭
- 已明确不采用：noice / edgy / heirline / telescope / base46 / NvChad UI
  全家桶等（见 [架构选型](../ARCHITECTURE.md#明确不采用)）。snacks 见
  [迁徙计划](snacks-migration.md)。

---

## 已覆盖的重叠能力

LazyVim / AstroNvim 的“开箱 IDE”主干，本配置大多已有等价实现，无需再对齐插件表。

| 能力 | LazyVim / AstroNvim | 本配置 |
|------|---------------------|--------|
| 补全 | blink.cmp | 同 |
| C++ / Rust LSP | clangd；LV 用 rustaceanvim | 原生配置 clangd + rust-analyzer |
| 格式化 | conform 或 LSP + null-ls | conform（默认关） |
| 静态分析 | tidy/clippy 或 null-ls | clangd `--clang-tidy` + clippy |
| 调试 | nvim-dap + dap-ui | 同 + 共用 codelldb |
| Treesitter / 文本对象 | 有 | 同（`main`；`:TsEnsure` 用户管理） |
| Git | gitsigns + lazygit | 同 |
| 文件树 | neo-tree / snacks explorer | nvim-tree |
| 搜索 | snacks picker / fzf | fzf-lua |
| 大纲 | aerial（LV 为 extra） | aerial |
| Trouble / TODO | 有 | 有 |
| 分屏导航 | smart-splits（Astro） | 同 |
| 会话 | persistence / resession | resession |
| UI toggle | snacks / astrocore `<leader>u*` | 原生 `lua/core/toggles.lua` |
| Flash / surround / pairs | 有 | 同 |
| which-key | 有 | 有 |

NvChad 与本配置重叠的通用编辑能力（亦无需对齐插件表）：

| 能力 | NvChad | 本配置 |
|------|--------|--------|
| 文件树 / Git / which-key | nvim-tree、gitsigns、which-key | 同 |
| 格式化 | conform（示例偏 Lua） | conform（clang-format / rustfmt；默认关） |
| Treesitter / snippets | treesitter、friendly-snippets | 同（parser 用户管理） |
| 补全 | nvim-cmp + LuaSnip | blink.cmp |
| 搜索 | telescope | fzf-lua |
| LSP 安装与配置层 | mason + nvim-lspconfig | 原生 LSP + 系统工具 |
| 缩进线 / 自动括号 | indent-blankline、nvim-autopairs | mini.indentscope、mini.pairs |
| `<Esc>` 清搜索、`<leader>fm`、providers 禁用 | 有 | 已有 |

NvChad **核心插件表不含 DAP**；C++ / Rust 调试与项目任务仍以 LazyVim / Astro
笔记及 [项目工作流](project-workflow.md) 为准。

---

## P0：优先考虑（直接服务 C++ / Rust）

### 项目根目录检测

- **来源**：LazyVim `LazyVim.root`；AstroNvim astrocore rooter。
- **做法**：LSP → `.git` / 语言 markers → cwd，可缓存。
- **可借鉴**：小型工具函数，统一 fzf-lua、grep、DAP、任务入口的项目根；不引入
  snacks 或 astrocore。
- **关联**：[DAP 启动体验](project-workflow.md#dap-启动体验)、
  [项目任务入口](project-workflow.md#项目任务入口)。

### DAP 启动：可执行文件发现与 launch.json

- **来源**：AstroNvim DAP；LazyVim `extras.dap.core`。
- **可借鉴**：
  1. 重新运行上一次调试配置；
  2. Rust / CMake 可执行文件自动列举；
  3. 读取 `.vscode/launch.json`，映射到 codelldb。
- **边界**：继续共用 codelldb；不引入 mason-nvim-dap、rustaceanvim。
- **关联**：[DAP 启动体验](project-workflow.md#dap-启动体验)（已有计划）。

### clangd 源 / 头切换

- **来源**：LazyVim `extras.lang.clangd`。
- **可借鉴**：`<leader>ch`（或同类）调用 `SwitchSourceHeader`；可选记录
  compile_commands / `.clangd` 等 root markers。
- **注意**：NvChad 将 `<leader>ch` 绑到 NvCheatsheet；本仓库该键更适合给
  clangd 源/头切换，不跟 NvChad 键位。
- **可选加深**：`clangd_extensions`（AST 视图等）仅在有真实需求时引入。

### 大文件自动降级

- **来源**：AstroNvim large-buf；LazyVim `snacks.bigfile`。
- **Astro 思路（更可移植）**：约 1.5MB / 十万行 / 超长行 → 关闭或减弱
  treesitter、补全、indent guides、format 等。
- **可借鉴**：纯 autocmd + buffer 标志，零新插件。

### 轻量 build / test / run 入口

- **来源**：LazyVim overseer / neotest；Astro 侧多为 toggleterm 专用终端 + 社区包。
- **可借鉴**：先用原生命令 + 现有 toggleterm（`<leader>Tb/t/r`），出现任务历史、
  并发或依赖图需求后再评估 overseer；neotest 仅在需要 watch/summary 时评估。
- **关联**：[项目任务入口](project-workflow.md#项目任务入口)（已有计划）。

---

## P1：体验增强、成本可控

### 项目级 search & replace

- **来源**：LazyVim `grug-far.nvim`（常绑 `<leader>sr`）。
- **可借鉴**：与 fzf-lua 的搜索互补，适合跨文件重构替换。

### Cargo.toml 辅助（不含 rustaceanvim）

- **来源**：LazyVim `extras.lang.rust` 中的 `crates.nvim`。
- **可借鉴**：只增强 `Cargo.toml` 的 crate 补全与版本操作；**不**引入
  rustaceanvim。

### Flash 增量选择

- **来源**：LazyVim Flash 配置（如 `<C-Space>` 扩大 / 缩小选择）。
- **可借鉴**：本配置已有 Flash，多半只需改 `lua/plugins/motion.lua`，不必加插件。

### 按严重级别跳转诊断

- **来源**：两边均有 `]e`/`[e`、`]w`/`[w`。
- **可借鉴**：原生 `vim.diagnostic.jump` + severity 过滤，几行 keymap 即可。

### LSP 能力门控 keymap

- **来源**：LazyVim / AstroNvim（`has` / `cond` 或 on_attach 检查）。
- **可借鉴**：在 `LspAttach` 中用 `client:supports_method` 再绑定 format、
  rename、code action 等，减少无效键。

### Sign 列交互

- **来源**：AstroNvim（astroui sign handlers）。
- **可借鉴**：点击 diagnostic sign → float；Ctrl+点击 → code action；点击
  DAP sign → 切换断点。手写 handler，不依赖 astroui。

### 分屏稳定与行号高亮（NvChad options）

- **来源**：NvChad `options.lua` 的 `splitkeep = "screen"`、
  `cursorlineopt = "number"`。
- **可借鉴**：各一行 option；前者减少分屏时内容跳动，后者只高亮行号列。
  属偏好项，零新插件。

### 含 ignored 的全量找文件（NvChad picker 配方）

- **来源**：NvChad `<leader>fa`（Telescope `find_files` + hidden / no_ignore）。
- **可借鉴**：用现有 fzf-lua 补一个对称的 files 变体；本配置已有 hidden
  grep，不必引入 telescope。

### 隐藏终端再选择（NvChad term 配方）

- **来源**：NvChad Telescope `terms` 扩展；UI 仓另有可切换终端。
- **可借鉴**：多 toggleterm 实例时，用 fzf-lua 或简单 `vim.ui.select` 列出隐藏
  终端。优先级低于 DAP / 任务入口。

---

## P2：已有专题或按需再议

| 项 | 主要来源 | 本仓库位置 / 说明 |
|----|----------|-------------------|
| Harpoon v2 | LazyVim extra | [Harpoon v2](editor-experience.md#harpoon-v2) |
| `vim.ui.input` 美化 | snacks.input / dressing；NvChad NvRenamer 同族 | [vim.ui.input](editor-experience.md#vimuiinput-界面)；仅 input，不引入 snacks/noice/NvChad UI |
| Markdown buffer 渲染 | 社区常见 | [Markdown buffer 内渲染](editor-experience.md#markdown-buffer-内渲染) |
| 启动性能基准 / CI smoke | LV / Astro 仓库实践 | [quality.md](quality.md) |
| yanky / dial | LazyVim coding/editor extras | 有明确痛点再加 |
| illuminate / document highlight | LV / snacks.words | 可用原生 `vim.lsp.buf.document_highlight` |
| zen / zoom / scratch | snacks | 架构倾向不引入 snacks；可用轻量原生替代 |
| lazydev.nvim | LV / Astro | 仅在常改本配置 Lua 时值得 |
| F5 / F9 等调试功能键 | Astro | 映射到现有 dap 命令即可 |
| 折叠策略级联 | Astro：LSP → treesitter → indent | 可改进 `foldexpr`，不必 heirline |
| “Last Session” 快捷入口 | Astro dashboard / LV persistence | resession 已具备，可补快捷键 |
| 关闭 LSP semantic tokens | NvChad `on_init` | 减少与 Treesitter 双重高亮；clangd / rust-analyzer 可能丢掉有用语义色，需实机试 |
| nvim-tree `hijack_cursor` / `sync_root_with_cwd` | NvChad nvimtree 配置 | 本配置已有 `update_focused_file` 等；小增强，非刚需 |
| `User FilePost` 延迟加载 | NvChad autocmds | 思路可参考，但 `vim.pack` 无 lazy load；收益有限，不必照搬 |

---

## 明确不借鉴

与 [架构选型](../ARCHITECTURE.md#明确不采用) 及项目原则冲突：

| 不搬 | 原因 |
|------|------|
| lazy.nvim / LazyExtras / AstroCommunity 整包 | 与 `vim.pack` 重叠 |
| mason 全家桶 | 工具由平台包管理器安装 |
| nvim-lspconfig | 仅两个 server，原生足够 |
| rustaceanvim | 破坏 C++ / Rust 统一调试路径 |
| none-ls | 格式化与 lint 职责已有归属 |
| snacks 全家桶 | **已改决策**：计划按 LazyVim 模块集迁入，见 [snacks 迁徙](snacks-migration.md)；仍拒绝 noice/edgy/lazy.nvim |
| noice / nvim-notify / edgy / dashboard 类 | 收益不清或过重 |
| heirline | lualine + bufferline 已够 |
| telescope | 已选 fzf-lua |
| base46 / NvChad UI / NvDash / NvCheatsheet / 主题切换器 | 本配置固定 Nordic + which-key + docs；不引入整套 UI |
| minty 等调色工具 | 与 C++ / Rust 主工作流无关 |
| format-on-save 默认开启 | 硬性基线相反 |
| 默认 2 空格缩进 | 本配置默认四空格 + guess-indent |
| Insert 模式 `<C-h/j/k/l>` 移光标 | 与本配置 insert `<C-k>` 签名帮助冲突 |
| 普通模式 `<C-h/j/k/l>` 原生分屏导航 | 已由 smart-splits 接管 |
| nvim-ts-autotag / better-escape | 与主工作流无关，或可用原生 keymap |
| persistence.nvim | 已有 resession |
| AI extras（copilot / avante 等） | 需单独决策，非当前缺口 |
| Web 向 extras（prettier、eslint 等） | 非 C++ / Rust 主路径 |

---

## 发行版差异对本仓库的启示

| 维度 | LazyVim | AstroNvim | NvChad | 对本仓库 |
|------|---------|-----------|--------|----------|
| 定位 | 语言 extras 丰富的 IDE 发行版 | 可扩展核心 + Community | UI + 通用编辑骨架 | 只抄配方，不抄依赖图 |
| UX 中枢 | snacks 极大 | snacks + neo-tree + heirline | base46 + NvChad UI | **计划**迁 snacks（见 [snacks 迁徙](snacks-migration.md)）；实现前仍为单点插件 |
| 语言 / 调试 | extras（clangd / rust / cmake / dap） | 核心通用，语言靠 Community | 核心几乎无 DAP | C++ / Rust 工作流跟 LV/Astro，不跟 NvChad |
| 格式化默认 | 开 | 开 | 未强制为本仓库基线 | 保持关 |
| 可移植精华 | root、lang recipes、grug-far | large-buf、sign handlers、事件延迟 | `splitkeep` / `cursorlineopt`、全量 files、term picker | 边角体验可抄；主干仍看 LV/Astro |

**一句话**：最值得搬的是项目根、DAP 启动、clangd 头文件切换、大文件防护、
项目替换与 Cargo.toml 辅助；NvChad 只补充少量 editor option 与 picker/终端小
体验。snacks 已改为按 [迁徙计划](snacks-migration.md)对齐 LazyVim 接入；仍不搬
插件管理器、Mason、rustaceanvim、noice/base46 UI，以及默认开启 format-on-save。

---

## 建议落地顺序

1. 已有计划先做：[DAP 启动体验](project-workflow.md#dap-启动体验)、
   [项目任务入口](project-workflow.md#项目任务入口)（可顺带落地项目根检测）。
2. 低成本增量：clangd `SwitchSourceHeader`、大文件降级、`]e`/`[e`、Flash 增量选择、
   LSP 能力门控；可选 `splitkeep` / `cursorlineopt`。
3. 新插件候选：`grug-far`、`crates.nvim`；sign 列交互按需；可选 fzf-lua 全量
   files 与隐藏终端选择（NvChad 配方，仍用现有栈）。
4. P2 与按需专题维持现状，有真实痛点再开实现。

将某项移入实现时：先更新 [实现状态](../STATUS.md) 的“正在实现”，完成验证后再移到
“已实现”；需要单独论证的方案写回对应专题文档，本页只保留对照结论与优先级。
