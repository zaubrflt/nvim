# AGENTS.md

本文件只记录 AI 修改仓库时必须遵守的硬性约束。背景、实现和历史理由通过链接
查阅，不在此重复。

## 必读文档

- [项目背景与不可变需求](docs/PROJECT.md)
- [架构、加载顺序与选型理由](docs/ARCHITECTURE.md)
- [已实现、进行中和计划状态](docs/STATUS.md)
- [快捷键索引](docs/KEYMAPS.md)
- [改进建议索引](docs/IMPROVEMENTS.md)
- [安装与依赖](docs/SETUP.md)
- [维护与验证](docs/MAINTENANCE.md)
- [故障排查](docs/TROUBLESHOOTING.md)

## 不可破坏的基线

1. 目标版本是 Neovim ≥ 0.12。
2. 支持平台为 Linux / macOS。
3. [原始 0–12 项需求](docs/PROJECT.md#原始需求)必须持续满足。
4. 保存时自动格式化必须默认关闭。
5. 新功能按职责拆分，不能把实现堆入 `init.lua`。

## 操作授权约束

- 修改项目中的任何文件前，必须先说明拟修改内容并取得用户的明确许可；未经
  许可只能进行只读分析。
- 不得自动执行 `git add`、`git commit` 或同类提交操作；只有用户针对该次
  操作明确要求并许可时才可执行。

## 架构约束

- 插件管理只使用 Neovim 原生 `vim.pack`；不要改用 lazy.nvim。
- `nvim-pack-lock.json` 必须纳入 Git，不能手工编辑。
- 新插件在 `lua/plugins/init.lua` 注册，在独立
  `lua/plugins/<feature>.lua` 配置；所有插件 `require` 使用 `pcall` 防护。
- 保持加载顺序：主题最先，which-key 最后。其他顺序按依赖关系安排。
- LSP 使用原生 `vim.lsp.config()` + `vim.lsp.enable()`；不要引入
  nvim-lspconfig、mason.nvim 或 rustaceanvim。
- 新增 LSP server 时，新建 `lsp/<server_name>.lua`，并将同名 server 加入
  `lua/plugins/lsp.lua` 的 `vim.lsp.enable()`。
- 必须保留 `blink.get_lsp_capabilities()` 对 LSP capabilities 的注入。
- 静态分析继续由 clangd `--clang-tidy` 与 rust-analyzer clippy 提供，不引入
  独立 linter 中间层。
- C/C++ 与 Rust 调试继续共用 nvim-dap + codelldb。

## Treesitter 约束

- `nvim-treesitter` 和 textobjects 使用 `main` 分支。
- 不得使用已移除的 `nvim-treesitter.configs` 或旧版
  `ensure_installed` setup 选项。
- 高亮、折叠和缩进继续通过 `FileType` autocmd 显式启用。
- 不得在启动时调用 `ts.install()`；parser 仅由用户执行 `:TsEnsure` /
  `:TsUpdate` 管理。

## 格式化约束

- `vim.g.user_format_on_save` 启动值必须为 `false`。
- 保留显式 `BufWritePre` autocmd 与 `:FormatEnable` / `:FormatDisable`
  运行时切换。
- 不要改成固定的 `conform.setup({ format_on_save = ... })`。

## 路径与工具约束

- 配置路径使用 `vim.fs.joinpath()` / `vim.fn.stdpath()`，不要硬编码路径分隔符。
- 系统工具通过 `PATH` 发现，不写入个人机器绝对路径。

## 快捷键约束

- 新增或修改的自定义 keymap 必须提供 `desc`。
- 快捷键变化必须同步 `docs/keymaps/` 中对应的专题；只有分组或导航入口变化时
  才更新 [快捷键索引](docs/KEYMAPS.md)。
- 新增 `<leader>X` 字母前缀时，在 `lua/plugins/whichkey.lua` 注册 group；
  单键映射不注册 group。
- `<C-h/j/k/l>` 由 smart-splits 接管，不在 core 中重复绑定。
- `<C-f>/<C-b>/<C-d>/<C-u>` 由 neoscroll 接管，不在 core 中重复绑定。
- `s` / `S` 属于 Flash；mini.surround 保持 `gs*` 前缀。

## 文档约束

- 每类信息只保留一个详细来源：
  - 需求归 `docs/PROJECT.md`。
  - 架构和设计理由归 `docs/ARCHITECTURE.md`。
  - 生命周期状态归 `docs/STATUS.md`。
  - 键位详情归 `docs/keymaps/`。
  - 改进方案详情归 `docs/improvements/`。
  - 用户安装、维护和排错分别归对应文档。
- `README.md`、`docs/KEYMAPS.md` 和 `docs/IMPROVEMENTS.md` 只作为简洁入口，
  不复制详细内容。
- 功能状态变化时更新 `docs/STATUS.md`；计划项的详细论证更新
  `docs/improvements/`。
- 文档只记录有代码或验证证据支持的事实，不把“已适配”写成“已实机验证”。

## 编辑与验证

- `lua/core/options.lua` 使用按段分组的中文注释。
- 插件文件使用简短英文注释说明配置原因。
- 无需插件时优先使用 Neovim 0.12 原生 API。
- 实质性修改后按 [维护与验证](docs/MAINTENANCE.md#验证清单)执行与风险
  相称的检查，并确认保存格式化仍默认关闭。
