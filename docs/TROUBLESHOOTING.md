# 日志与故障排查

[返回 README](../README.md) · [安装与依赖](SETUP.md) ·
[维护与验证](MAINTENANCE.md)

## 排查顺序

先执行：

```vim
:messages
:checkhealth
:checkhealth vim.pack
:checkhealth nvim-treesitter
:checkhealth vim.lsp
```

当前 buffer 的 LSP client：

```vim
:lua =vim.lsp.get_clients({ bufnr = 0 })
```

绝大多数启动、工具链和 parser 问题可以在这些输出中定位。

## 日志位置

使用 `:echo stdpath('log')` 和 `:echo stdpath('cache')` 查询当前平台的实际
目录。

| 日志 | 路径 | 打开方式 |
| --- | --- | --- |
| Neovim | `stdpath('log')/log` | `:lua vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath('log'), 'log'))` |
| LSP | `vim.lsp.get_log_path()` | `:lua vim.cmd.edit(vim.lsp.get_log_path())` |
| DAP | `stdpath('cache')/dap.log` | `:lua vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath('cache'), 'dap.log'))` |
| vim.pack | `stdpath('log')/nvim-pack.log` | `:lua vim.cmd.edit(vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log'))` |
| Treesitter 编译 | `:messages` | `:messages` |

常见默认位置：

- Linux / macOS：state 通常位于 `~/.local/state/nvim/`，cache 位于
  `~/.cache/nvim/`。
- Windows：通常位于 `%LOCALAPPDATA%\nvim-data\` 或 Neovim 返回的
  `stdpath()` 目录。

## 提高日志详细度

```vim
" LSP
:lua vim.lsp.set_log_level('debug')

" DAP
:lua require('dap').set_log_level('DEBUG')
```

完成排查后把 LSP 日志级别恢复为 `warn`，避免日志持续增长。

## 插件与 vim.pack

### 提示 `module 'xxx' not found`

1. 查看 `:messages` 中对应插件的 clone/load 错误。
2. 执行 `:checkhealth vim.pack`。
3. 确认 Git 和网络可用。
4. 插件成功安装后重启 Neovim。

`vim.pack.add()` 的安装任务彼此并行，但函数会等待任务结束；问题不应简单归因
于“异步尚未完成”。

### 锁文件异常

`nvim-pack-lock.json` 应由 `vim.pack` 维护并纳入 Git。不要手工修订 revision。
使用 `:checkhealth vim.pack` 和 `nvim-pack.log` 查找损坏或下载错误。

## Treesitter

### 高亮未生效

1. 执行 `:TsEnsure`。
2. 执行 `:checkhealth nvim-treesitter`。
3. 打开目标文件，用 `:Inspect` 查看 capture。

### Windows 出现 `EPERM` 或 `Could not rename temp`

Defender、杀毒软件或 Explorer 索引器可能锁住 `%TEMP%\nvim\`：

1. 退出所有 Neovim 实例。
2. 执行：

   ```powershell
   Remove-Item -Recurse -Force "$env:TEMP\nvim"
   ```

3. 重新运行 `:TsEnsure`。
4. 仍失败时，考虑把 Neovim data 目录加入 Defender 排除项。

### tree-sitter CLI 版本过旧

`nvim-treesitter` `main` 分支要求 tree-sitter CLI ≥ 0.26.1。发行版仓库版本
可能落后，可选一种方式升级：

```bash
# npm
sudo npm install -g tree-sitter-cli@latest

# cargo
cargo install --locked tree-sitter-cli
```

也可以从
[tree-sitter releases](https://github.com/tree-sitter/tree-sitter/releases)
下载平台对应的预编译二进制。

若系统中同时存在 `/usr/local/sbin/tree-sitter`、
`/usr/local/bin/tree-sitter` 和 `~/.cargo/bin/tree-sitter`，先用
`which tree-sitter` 与 `tree-sitter --version` 确认 PATH 实际命中的版本。
升级后执行 `:TsUpdate` 重新编译 parser。

### parser 编译失败

确认同时存在：

- tree-sitter CLI ≥ 0.26.1。
- C 编译器（Linux/macOS）或 MSVC/zig（Windows）。

详细缺项由 `:checkhealth nvim-treesitter` 给出。

## LSP 与补全

### clangd 找不到头文件

在项目根提供 `compile_commands.json`、`compile_flags.txt` 或 `.clangd`。
CMake 项目通常使用：

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

必要时把生成的 `compile_commands.json` 链接或复制到项目根。

### C++ / Rust LSP 未启动

按顺序检查：

1. 二进制是否在 PATH：

   ```vim
   :lua =vim.fn.exepath('clangd')
   :lua =vim.fn.exepath('rust-analyzer')
   ```

2. 当前 buffer 是否附着 client：

   ```vim
   :lua =vim.lsp.get_clients({ bufnr = 0 })
   ```

3. 项目 root marker 是否存在：
   - clangd：`compile_commands.json`、`.clangd`、`.git` 等。
   - rust-analyzer：`Cargo.toml`、`rust-project.json` 或 `.git`。
4. blink.cmp 是否加载：

   ```vim
   :lua =package.loaded['blink.cmp'] ~= nil
   ```

5. 开启 debug 日志，重新打开文件后检查 LSP 日志。

孤立的 `.cpp` 或 `.rs` 文件不一定满足 root marker，优先在真实项目中验证。

### `clangd is not executable`

表示 `clangd` 不在当前 Neovim 进程的 PATH。Windows 使用 winget 安装 LLVM
后需要重启终端或桌面应用，使新 PATH 生效。

### rust-analyzer shim 报 `Unknown binary`

`~/.cargo/bin/rust-analyzer` 可能只是 rustup shim。安装组件：

```bash
rustup component add rust-analyzer rustfmt clippy
```

并确认当前 toolchain 正确。可用 `cargo new test-rs` 创建最小项目验证。

## 调试

### codelldb 启动失败

- 先运行 `:lua =vim.fn.exepath('codelldb')`。
- Windows 把 codelldb 发行包的 `extension/adapter/` 加入 PATH。
- 开启 DAP DEBUG 日志，重试后检查 `stdpath('cache')/dap.log`。

当前配置启动 C/C++ 与 Rust 程序时仍可能要求手动输入 executable 路径。

## 格式化

`<leader>fm` 无响应时执行：

```vim
:checkhealth conform
```

确认 C/C++ 有 `clang-format`，Rust 有 `rustfmt`。保存格式化默认关闭是预期
行为；只有显式执行 `:FormatEnable` 后才会在保存时运行。

## fzf-lua 与 Lazygit

- fzf-lua 文件查找需要 `fzf`；live grep 还需要 `rg`。
- lazygit 快捷键不可用时运行 `:lua =vim.fn.exepath('lazygit')`。缺少二进制
  时配置会跳过这些映射并发出警告。
