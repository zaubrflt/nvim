# Neovim 0.12 配置

一份模块化、跨平台（Linux / macOS / Windows）的 Neovim 配置，使用 Neovim 0.12 内置的 `vim.pack` 插件管理器。聚焦于 C++ 与 Rust 的 LSP / 调试 / 格式化 / 静态分析体验，搭配 Treesitter 高亮、`blink.cmp` 补全、Git 集成与文件树，以及一组日常生产力插件（fzf-lua / lualine / aerial / flash / mini.* / lazygit / friendly-snippets / guess-indent）。

> 主要在 Linux / macOS 使用，Windows 也已适配。

## 目录结构

```
nvim/
├── init.lua                    # 入口，仅设置 leader 并 require 各模块
├── lua/
│   ├── core/
│   │   ├── options.lua         # 通用选项（缩进、行号、剪贴板、folding 等）
│   │   ├── keymaps.lua         # 与插件无关的通用快捷键
│   │   └── autocmds.lua        # 通用 autocmd（高亮 yank、自动建目录等）
│   └── plugins/
│       ├── init.lua            # vim.pack.add 注册中心
│       ├── colorscheme.lua     # AlexvZyl/nordic.nvim
│       ├── treesitter.lua      # nvim-treesitter (main 分支)
│       ├── completion.lua      # blink.cmp（friendly-snippets 自动识别）
│       ├── lsp.lua             # 通用 LSP 设置 + LspAttach keymaps
│       ├── format.lua          # conform.nvim（默认不在保存时自动格式化）
│       ├── dap.lua             # nvim-dap + dap-ui + virtual-text
│       ├── git.lua             # gitsigns.nvim
│       ├── lazygit.lua         # lazygit.nvim（依赖系统 lazygit）
│       ├── filetree.lua        # nvim-tree.lua
│       ├── picker.lua          # fzf-lua（依赖系统 fzf）
│       ├── statusline.lua      # lualine.nvim
│       ├── editing.lua         # mini.pairs + mini.surround + guess-indent
│       ├── motion.lua          # flash.nvim（s / S 跳转）
│       ├── outline.lua         # aerial.nvim（<leader>O 切换）
│       └── whichkey.lua        # which-key.nvim（leader 快捷键导航弹窗）
├── lsp/
│   ├── clangd.lua              # clangd（启用 clang-tidy）
│   └── rust_analyzer.lua       # rust-analyzer（check.command = clippy）
├── nvim-pack-lock.json         # vim.pack 锁文件，首次启动后自动生成
└── README.md
```

## 依赖

### Neovim 本体

需要 **Neovim ≥ 0.12**（依赖 `vim.pack`、`vim.lsp.config` / `vim.lsp.enable`、`vim.diagnostic.jump`）。

### 系统级工具

| 工具 | 用途 | 必需 |
| --- | --- | --- |
| `git` | `vim.pack` 拉取插件 | 是 |
| `clangd` | C/C++ LSP（含 clang-tidy） | C++ 需要 |
| `clang-format` | C/C++ 格式化 | C++ 需要 |
| `rustup`（含 `rust-analyzer`、`rustfmt`、`clippy` 组件） | Rust LSP / 格式化 / 静态分析 | Rust 需要 |
| `codelldb` | C/C++/Rust 调试器 | 调试需要 |
| `tree-sitter` CLI（≥ 0.26.1） | nvim-treesitter `main` 分支编译解析器；可用 `cargo install --locked tree-sitter-cli` 或 `sudo npm install -g tree-sitter-cli` 或下载二进制 | Treesitter 高亮需要 |
| `fzf` | fzf-lua 模糊查找的后端二进制 | 模糊查找需要 |
| `ripgrep`（`rg`） | fzf-lua live grep 的后端 | 模糊查找需要 |
| `lazygit` | `<leader>gg` 调起的 git TUI | Git 复杂操作需要（不装则相关 keymap 静默跳过） |
| `stylua` | Lua 格式化（可选） | 否 |
| C 编译器 / `zig` | 编译 treesitter 解析器 | Treesitter 需要 |

### 安装命令

#### Linux（Debian / Ubuntu）

```bash
sudo apt update
sudo apt install -y git build-essential clangd clang-format clang-tidy \
                    fzf ripgrep \
                    xclip wl-clipboard
# Rust：
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer rustfmt clippy
# tree-sitter CLI：
cargo install --locked tree-sitter-cli
# codelldb：从 https://github.com/vadimcn/codelldb/releases 下载，解压后把 codelldb 加入 PATH。
# lazygit：Debian/Ubuntu 仓库版本旧，建议从 https://github.com/jesseduffield/lazygit/releases 下载二进制。
```

#### Linux（Arch / Fedora）

```bash
# Arch
sudo pacman -S --needed git base-devel clang llvm rustup tree-sitter-cli \
                       fzf ripgrep lazygit \
                       xclip wl-clipboard codelldb
rustup default stable
rustup component add rust-analyzer rustfmt clippy

# Fedora
sudo dnf install -y git clang clang-tools-extra rustup tree-sitter-cli \
                    fzf ripgrep lazygit \
                    xclip wl-clipboard
rustup-init -y
rustup component add rust-analyzer rustfmt clippy
# codelldb：从 https://github.com/vadimcn/codelldb/releases 下载或装 vscode-lldb 扩展取用。
```

#### macOS（Homebrew）

```bash
brew install neovim git llvm rustup-init tree-sitter fzf ripgrep lazygit
rustup-init -y
rustup component add rust-analyzer rustfmt clippy
# codelldb：
brew install --cask codelldb
# 或者下载发行包：https://github.com/vadimcn/codelldb/releases
```

> macOS 下 `clangd` / `clang-format` / `clang-tidy` 来自 `brew install llvm`；可能需要把 `$(brew --prefix llvm)/bin` 加入 `PATH`。

#### Windows（建议使用 winget 或 Scoop）

```powershell
winget install Git.Git
winget install LLVM.LLVM                       # 提供 clangd / clang-format / clang-tidy
winget install Rustlang.Rustup
winget install junegunn.fzf                    # fzf 二进制
winget install BurntSushi.ripgrep.MSVC         # ripgrep for live grep
winget install JesseDuffield.lazygit
rustup component add rust-analyzer rustfmt clippy
# tree-sitter CLI：
cargo install --locked tree-sitter-cli
# codelldb：从 https://github.com/vadimcn/codelldb/releases 下载 codelldb-*-windows-x64.zip
#          解压并把 extension/adapter 目录加到 PATH（其中包含 codelldb.exe / codelldb.cmd）。
```

> Windows 下 `clipboard = 'unnamedplus'` 默认即可工作；Linux 需要 `xclip`（X11）或 `wl-clipboard`（Wayland）。

## 安装这份配置

### Linux / macOS

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

### Windows

```powershell
git clone <this-repo> $env:LOCALAPPDATA\nvim
nvim
```

首次启动时 `vim.pack` 会自动从 GitHub 拉取所有插件到 `stdpath('data')/site/pack/core/opt/`。**拉取完成后请手动执行 `:TsEnsure` 一次**，nvim-treesitter 会编译 `ensure_installed` 列出的解析器（C / C++ / Rust / Lua / …）。这一步不放进启动流程，是为了避免 Windows 上杀软偶发握住临时目录导致的 `EPERM` 报错；详见 [故障排查](#故障排查)。

### 常用维护命令

| 命令 | 作用 |
| --- | --- |
| `:checkhealth` | 全面体检（Neovim、LSP、treesitter、provider 等） |
| `:checkhealth vim.pack` | 查看插件管理状态 |
| `:lua vim.pack.update()` | 更新所有插件 |
| `:lua vim.pack.del({ 'name' })` | 卸载某插件 |
| `:TsEnsure` | 安装 `ensure_installed` 中尚缺失的 treesitter 解析器 |
| `:TsUpdate` | 把 `ensure_installed` 中的解析器升级到最新 |
| `:checkhealth vim.lsp` | 查看 LSP 客户端连接情况（0.12 原生，**不用** `:LspInfo`，那是 nvim-lspconfig 的命令） |
| `:lua =vim.lsp.get_clients({ bufnr = 0 })` | 查看当前 buffer 上挂着哪些 LSP client |
| `:messages` | 查看最近的消息 / 错误 / `vim.notify` 输出 |

## 关闭自动格式化（需求 10）

**默认不在保存时自动格式化**。请使用 `<leader>fm` 手动触发。

如需临时启用：

```vim
:FormatEnable     " 当前会话保存时自动格式化
:FormatDisable    " 关闭
```

也可以设置 `vim.g.user_format_on_save = true` 持久化（写到 `lua/core/options.lua`）。

## 快捷键速查

完整速查表见 **[KEYMAPS.md](KEYMAPS.md)**。`<leader>` = `Space`，所有快捷键都在源文件中以 `desc =` 标注，按下 `<leader>` 后停顿约 200ms 即弹出 `which-key.nvim` 的导航弹窗。

只看 Leader 分组总览的话：

| 前缀 | 含义 | 文档章节 |
| --- | --- | --- |
| `<leader>b` | Buffer | [通用 / 窗口](KEYMAPS.md#通用--窗口) |
| `<leader>c` | Code / Diagnostics | [LSP](KEYMAPS.md#lspbuffer-级) / [诊断](KEYMAPS.md#诊断全局) |
| `<leader>d` | Debug | [调试](KEYMAPS.md#调试nvim-dap) |
| `<leader>f` | File / Find / Format | [模糊查找](KEYMAPS.md#模糊查找fzf-lua) / [文件树](KEYMAPS.md#文件树nvim-tree) / [格式化](KEYMAPS.md#代码格式化conformnvim) |
| `<leader>g` | Git | [Git](KEYMAPS.md#gitgitsignsnvim) / [Lazygit](KEYMAPS.md#lazygitkdheepaklazygitnvim) |
| `<leader>r` | Refactor | [LSP](KEYMAPS.md#lspbuffer-级) |
| `<leader>O` | Outline (单键 toggle) | [aerial](KEYMAPS.md#代码大纲aerialnvim) |
| `s` / `S` | Flash 跳转 | [跳转动作](KEYMAPS.md#跳转动作flashnvim) |
| `gs*` | mini.surround | [编辑增强](KEYMAPS.md#编辑增强minipairs--minisurround--guess-indent) |

## 查看日志 / 排错

排查 Neovim 与插件问题时按下面顺序看，绝大多数问题在前两步就能定位：

### 1. 当下消息

| 命令 | 看什么 |
| --- | --- |
| `:messages` | 最近的所有 `:echo` / `vim.notify` / 报错（含启动期一闪而过的） |
| `:checkhealth` | 全局体检；包含 Neovim 本体、provider、所有插件健康状态 |
| `:checkhealth vim.pack` | 插件拉取状态、锁文件状态 |
| `:checkhealth nvim-treesitter` | parser 编译器、tree-sitter CLI、已装解析器列表 |
| `:checkhealth vim.lsp` | LSP 全局体检：每个 client 的 root、cmd、capabilities、attached buffers |
| `:lua =vim.lsp.get_clients({ bufnr = 0 })` | 当前 buffer 上挂着哪些 client（空表 = 没挂上） |

### 2. 各类持久日志文件

Neovim 把日志统一放到 `stdpath('log')` 与 `stdpath('cache')` 下：

| 名字 | 路径（用 `:echo stdpath('log')` 等查询） | 怎么打开 |
| --- | --- | --- |
| Neovim 本体日志 | `stdpath('log')/log` | `:exe 'edit ' .. stdpath('log') .. '/log'` |
| LSP 日志 | `vim.lsp.get_log_path()`（一般在 `stdpath('log')/lsp.log`） | `:lua vim.cmd.edit(vim.lsp.get_log_path())` |
| DAP 日志 | `stdpath('cache')/dap.log` | `:lua vim.cmd.edit(vim.fn.stdpath('cache')..'/dap.log')` |
| Treesitter 编译日志 | 直接打印在 `:messages` | `:messages` |
| `vim.pack` 拉取日志 | 直接打印在 `:messages` 与 `:checkhealth vim.pack` | 同上 |

参考路径（Windows 默认）：
- `stdpath('log')` → `%LOCALAPPDATA%\nvim-data\log\`
- `stdpath('cache')` → `%LOCALAPPDATA%\nvim-data\`（早期版本）或 `%LOCALAPPDATA%\Temp\nvim.<user>\`

参考路径（Linux/macOS 默认）：
- `stdpath('log')` → `~/.local/state/nvim/`
- `stdpath('cache')` → `~/.cache/nvim/`

### 3. 提高日志详细度

默认日志级别比较安静，要复现 bug 时先调高再操作：

```vim
" LSP：debug 会很啰嗦，定位完记得调回 warn
:lua vim.lsp.set_log_level('debug')

" DAP：可选 'TRACE' / 'DEBUG' / 'INFO' / 'WARN' / 'ERROR'
:lua require('dap').set_log_level('DEBUG')
```

### 4. 看 LSP server 自身的标准错误

clangd / rust-analyzer 自己的 stderr 会汇聚到 LSP 日志。如果 server 启不来，通常是 PATH 找不到二进制；用 `:lua print(vim.fn.exepath('clangd'))` 验证。

## 故障排查

- **首次启动报 `module 'xxx' not found`**：`vim.pack.add` 是异步的，重启一次 Neovim 即可。
- **Treesitter 高亮没生效**：先 `:TsEnsure` 把缺失的解析器装上；再 `:checkhealth nvim-treesitter` 看 parser 是否已存在。
- **`:TsEnsure` 报 `EPERM: operation not permitted` 或 `Could not rename temp` (Windows)**：杀软 / Defender / Explorer 索引器握住了 `%TEMP%\nvim\`。退出全部 nvim 实例 → `Remove-Item -Recurse -Force "$env:TEMP\nvim"` → 再 `:TsEnsure` 重试。仍失败就把 `%LOCALAPPDATA%\nvim-data` 加进 Windows Defender 排除项。
- **`:checkhealth nvim-treesitter` 报 `tree-sitter-cli v0.26.x is required`**：nvim-treesitter `main` 分支硬要求 CLI ≥ 0.26.1，发行版仓库（apt / dnf）通常落后。三条升级路径任选其一：

  ```bash
  # 方案 A：预编译二进制（不依赖任何 toolchain，最稳）
  TS_VERSION=v0.26.8
  GH_URL="https://github.com/tree-sitter/tree-sitter/releases/download/${TS_VERSION}/tree-sitter-linux-x64.gz"
  curl -fL "${GH_URL}" | gunzip > /tmp/tree-sitter      # 直连
  # 国内 / 受限网络，直连失败时挑一个 GitHub 镜像换 prefix:
  #   https://gh-proxy.com/$GH_URL
  #   https://ghfast.top/$GH_URL
  #   https://hub.gitmirror.com/$GH_URL
  chmod +x /tmp/tree-sitter
  file /tmp/tree-sitter                  # 必须是 "ELF 64-bit LSB executable"
  sudo install -m 755 /tmp/tree-sitter /usr/local/bin/tree-sitter
  rm /tmp/tree-sitter

  # 方案 B：npm 全局包（npm 的 tree-sitter-cli 内部也是同一份 Rust 二进制）
  # 注意：install 阶段会从 GitHub release 拉二进制，受限网络下也会卡
  sudo npm install -g tree-sitter-cli@latest

  # 方案 C：cargo（需要 Rust toolchain，装到 ~/.cargo/bin/）
  cargo install --locked tree-sitter-cli
  ```

  **PATH 优先级陷阱**：如果 `/usr/local/sbin/tree-sitter`、`/usr/local/bin/tree-sitter`、`~/.cargo/bin/tree-sitter` 共存，`which tree-sitter` 会先解析到 `sbin` 那个；升级了 bin 或 cargo 路径下的版本但 sbin 还有旧版二进制时，nvim 仍然在用旧版。用 `sudo rm` 删掉旧路径上的二进制即可。

  升级 CLI 后跑一次 `:TsUpdate` 把已装解析器用新 ABI 重新编译。
- **Treesitter 解析器编译失败**：检查 `tree-sitter` CLI 与 C 编译器（Linux 需 `build-essential` / `gcc`，Windows 需 MSVC 或 zig）；`:checkhealth nvim-treesitter` 会列出缺什么。
- **clangd 找不到头文件**：在项目根放置 `compile_commands.json`（CMake 用 `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`）或 `.clangd`。
- **C++ / Rust 自动补全没出现**：按以下顺序排查
  1. server 是否在 PATH：`:lua =vim.fn.exepath('clangd')` / `:lua =vim.fn.exepath('rust-analyzer')`，空字符串说明没装或没在 PATH
  2. server 是否挂上了：在 `.cpp` / `.rs` 文件内执行 `:lua =vim.lsp.get_clients({ bufnr = 0 })`，空表说明没挂上
  3. root marker 是否找到：clangd 需要 `compile_commands.json` / `.clangd` / `.git` 之一；rust-analyzer 需要 `Cargo.toml` 或 `.git`。直接打开孤立文件（不在任何项目里）通常不会启动 server
  4. blink.cmp 是否加载：`:lua =package.loaded['blink.cmp'] ~= nil`，false 说明没加载
  5. 还看不出问题 → `:lua vim.lsp.set_log_level('debug')` → 重新打开文件 → `:lua vim.cmd.edit(vim.lsp.get_log_path())` 看具体错
- **LSP 日志里 `invalid "clangd" config: ... cmd: ... got table ... clangd is not executable`**：误导性文案，真实含义是 `clangd` 不在 PATH。Windows 上跑 `winget install LLVM.LLVM` 后**重启终端**（winget 不刷新当前会话 PATH），或手动把 `C:\Program Files\LLVM\bin` 加进系统 PATH。
- **LSP 日志里 `error: Unknown binary 'rust-analyzer.exe' in official toolchain 'stable-x86_64-pc-windows-msvc'`**：rustup 的 shim 在喊"组件没装"。`~/.cargo/bin/rust-analyzer.exe` 只是个代理，需要跑 `rustup component add rust-analyzer` 把真正的 server 装进当前 toolchain。`rustfmt` 和 `clippy` 同理。
- **rust-analyzer 未启动**：常见原因是不在 `Cargo.toml` 项目里；用 `cargo new test-rs` 建个 demo 工程验证；详细错误见 LSP 日志。
- **codelldb 启动失败 (Windows)**：把 `codelldb-*\extension\adapter` 加入 `PATH`，或修改 `lua/plugins/dap.lua` 中的 `executable.command` 改为绝对路径；`:lua require('dap').set_log_level('DEBUG')` 后再启动一次，错误会写进 `stdpath('cache')/dap.log`。
- **`<leader>fm` 没有反应**：`:checkhealth conform` 查看格式化器是否被找到。

## 后续可扩展项（未默认开启）

详细规划见 [`AGENTS.md`](AGENTS.md) 的「未来扩展项」一节。第 1 批（fzf-lua / lualine / mini.pairs / mini.surround / flash / aerial / guess-indent / friendly-snippets / lazygit）**已落地**，下面是后续批次的概览：

- **第 2 批（编辑增强）**：trouble.nvim（诊断列表）+ mini.ai + treesitter-textobjects + todo-comments + treesitter-context + smart-splits
- **第 3 批（视觉 / 会话）**：mini.indentscope + resession.nvim（branch-scoped 会话）+ bufferline.nvim（可选）
- **第 4 批（按需工具）**：harpoon v2 + render-markdown + toggleterm
- 注释：Neovim 0.10+ 已内置 `gc` / `gcc`，无需插件
