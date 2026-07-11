# LazyVim / AstroNvim 可借鉴项

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md) ·
[架构选型](../ARCHITECTURE.md#选型记录)

对照仓库内 `LazyVim/` 与 `AstroNvim/` 源码，整理对本配置有参考价值的能力。
目标是**按缺口 cherry-pick**，不是复刻发行版。生命周期状态仍以
[实现状态](../STATUS.md) 为准；具体落地论证可再拆到各专题文档。

对照时的本仓库边界（不可破坏）：

- 插件管理：`vim.pack`（不用 lazy.nvim）
- LSP：原生 `vim.lsp.config()` / `vim.lsp.enable()`（不用 nvim-lspconfig、mason）
- Rust：直接 rust-analyzer（不用 rustaceanvim）
- 静态分析：clangd `--clang-tidy` + clippy（不用 none-ls）
- 保存格式化：默认关闭
- 已明确不采用：snacks / noice / edgy / dashboard / heirline / telescope 等（见
  [架构选型](../ARCHITECTURE.md#明确不采用)）

---

## 已覆盖的重叠能力

两边“开箱 IDE”主干，本配置大多已有等价实现，无需再对齐插件表。

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

---

## P2：已有专题或按需再议

| 项 | 主要来源 | 本仓库位置 / 说明 |
|----|----------|-------------------|
| Harpoon v2 | LazyVim extra | [Harpoon v2](editor-experience.md#harpoon-v2) |
| `vim.ui.input` 美化 | snacks.input / dressing | [vim.ui.input](editor-experience.md#vimuiinput-界面)；仅 input，不引入 snacks/noice |
| Markdown buffer 渲染 | 社区常见 | [Markdown buffer 内渲染](editor-experience.md#markdown-buffer-内渲染) |
| 启动性能基准 / CI smoke | 两边仓库实践 | [quality.md](quality.md) |
| yanky / dial | LazyVim coding/editor extras | 有明确痛点再加 |
| illuminate / document highlight | LV / snacks.words | 可用原生 `vim.lsp.buf.document_highlight` |
| zen / zoom / scratch | snacks | 架构倾向不引入 snacks；可用轻量原生替代 |
| lazydev.nvim | 两边 | 仅在常改本配置 Lua 时值得 |
| F5 / F9 等调试功能键 | Astro | 映射到现有 dap 命令即可 |
| 折叠策略级联 | Astro：LSP → treesitter → indent | 可改进 `foldexpr`，不必 heirline |
| “Last Session” 快捷入口 | Astro dashboard / LV persistence | resession 已具备，可补快捷键 |

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
| snacks 全家桶 | 范围过大；toggle/scroll/indent 已有替代 |
| noice / nvim-notify / edgy / dashboard 类 | 收益不清或过重 |
| heirline | lualine + bufferline 已够 |
| telescope | 已选 fzf-lua |
| format-on-save 默认开启 | 硬性基线相反 |
| nvim-ts-autotag / better-escape | 与主工作流无关，或可用原生 keymap |
| persistence.nvim | 已有 resession |
| AI extras（copilot / avante 等） | 需单独决策，非当前缺口 |
| Web 向 extras（prettier、eslint 等） | 非 C++ / Rust 主路径 |

---

## 两边差异对本仓库的启示

| 维度 | LazyVim | AstroNvim | 对本仓库 |
|------|---------|-----------|----------|
| UX 中枢 | snacks 极大 | snacks + neo-tree + heirline | 继续单点插件 + 原生 API |
| 语言包 | extras 很全（clangd / rust / cmake） | 核心通用，语言靠 Community | 只抄配方进 `lsp/` 与 `plugins/` |
| 格式化默认 | 开 | 开 | 保持关 |
| 可移植精华 | root、lang recipes、grug-far | large-buf、sign handlers、事件延迟加载 | 抄模式，不抄依赖图 |

**一句话**：最值得搬的是项目根、DAP 启动、clangd 头文件切换、大文件防护、
项目替换与 Cargo.toml 辅助；最不该搬的是插件管理器、Mason、rustaceanvim、
snacks/noice 全家桶，以及默认开启 format-on-save。

---

## 建议落地顺序

1. 已有计划先做：[DAP 启动体验](project-workflow.md#dap-启动体验)、
   [项目任务入口](project-workflow.md#项目任务入口)（可顺带落地项目根检测）。
2. 低成本增量：clangd `SwitchSourceHeader`、大文件降级、`]e`/`[e`、Flash 增量选择、
   LSP 能力门控。
3. 新插件候选：`grug-far`、`crates.nvim`；sign 列交互按需。
4. P2 与按需专题维持现状，有真实痛点再开实现。

将某项移入实现时：先更新 [实现状态](../STATUS.md) 的“正在实现”，完成验证后再移到
“已实现”；需要单独论证的方案写回对应专题文档，本页只保留对照结论与优先级。
