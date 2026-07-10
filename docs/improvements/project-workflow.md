# 项目工作流改进

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md)

## DAP 启动体验

### 缺口

当前 codelldb 配置可以调试 C、C++ 与 Rust，但 launch 主要依赖用户输入
executable 路径。Rust 输入框只把 `target/debug/` 作为默认目录，没有自动
识别实际 target。

### 建议

分阶段改进：

1. 增加“重新运行上一次调试配置”快捷键。
2. Rust 使用 `cargo metadata` 和构建产物信息列出可执行 target。
3. C/C++ 在 `build/`、`cmake-build-*` 和 `compile_commands.json` 周边
   搜索可执行文件，并通过 `vim.ui.select()` 选择。
4. 使用 nvim-dap 的 VSCode 扩展读取 `.vscode/launch.json`，映射
   `lldb` / `cppdbg` 等类型到 codelldb。

保持以下边界：

- C/C++ 与 Rust 继续共用 codelldb。
- 不引入 mason.nvim 或 rustaceanvim。
- 路径必须使用跨平台 API；Windows 需要兼容 `.exe`。
- 自动发现失败时保留手动输入回退。

### 验收

- 常规 Cargo 与 CMake debug build 可以少于两次交互启动。
- 多个 executable 时显示明确的选择列表。
- `.vscode/launch.json` 不存在或格式不支持时不会阻断手动调试。
- 附加进程仍正常工作。

## 项目任务入口

### 缺口

配置已有 DAP 与 toggleterm，但没有统一的 build、test 和 run 入口。

### 建议

先使用原生命令和 toggleterm，不立即引入任务框架：

- `<leader>Tb`：build。
- `<leader>Tt`：test。
- `<leader>Tr`：run。
- Rust 项目根据 `Cargo.toml` 使用 `cargo build`、`cargo test`、
  `cargo run`。
- CMake 项目根据 `CMakeLists.txt` 使用 `cmake --build build`，并允许
  用户选择或配置 build 目录。
- 在 which-key 注册 `<leader>T` 任务分组。

只有出现任务历史、并发、依赖图或状态列表的真实需求后，再评估
`stevearc/overseer.nvim`。

### 验收

- 命令在项目根执行，退出码和完整输出可见。
- 重复运行不会无意创建大量终端实例。
- Linux、macOS 和 Windows shell quoting 正确。
- 不影响现有 `<leader>t` 终端分组。
