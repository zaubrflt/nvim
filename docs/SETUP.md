# 安装与依赖

[返回 README](../README.md) · [维护与验证](MAINTENANCE.md) ·
[故障排查](TROUBLESHOOTING.md)

## Neovim

需要 **Neovim ≥ 0.12**。配置依赖以下原生 API：

- `vim.pack`
- `vim.lsp.config()` / `vim.lsp.enable()`
- `vim.diagnostic.jump()`
- `vim.treesitter`

## 系统工具

| 工具 | 用途 | 何时需要 |
| --- | --- | --- |
| `git` | `vim.pack` 拉取插件 | 必需 |
| `clangd` | C/C++ LSP 与 clang-tidy | C/C++ |
| `clang-format` | C/C++ 格式化 | C/C++ |
| `rustup`、`rust-analyzer`、`rustfmt`、`clippy` | Rust 工具链 | Rust |
| `codelldb` | C/C++/Rust 调试 | 调试 |
| `tree-sitter` CLI ≥ 0.26.1 | 编译 Treesitter parser | Treesitter |
| C 编译器或 `zig` | 编译 Treesitter parser | Treesitter |
| `fzf` | fzf-lua 后端 | 模糊查找 |
| `ripgrep`（`rg`） | live grep 后端 | 内容搜索 |
| `lazygit` | 仓库级 Git TUI | Lazygit 快捷键 |
| `stylua` | Lua 格式化 | 可选 |
| `xclip` 或 `wl-clipboard` | 系统剪贴板 | Linux |

缺少 `lazygit` 时只会跳过相关快捷键，不影响其他功能。

## 平台安装

### Debian / Ubuntu

```bash
sudo apt update
sudo apt install -y git build-essential clangd clang-format clang-tidy \
                    fzf ripgrep xclip wl-clipboard

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer rustfmt clippy
cargo install --locked tree-sitter-cli
```

从 [codelldb releases](https://github.com/vadimcn/codelldb/releases) 下载
codelldb 并加入 `PATH`。Debian/Ubuntu 仓库中的 lazygit 可能较旧，可从
[lazygit releases](https://github.com/jesseduffield/lazygit/releases)
安装。

### Arch Linux

```bash
sudo pacman -S --needed git base-devel clang llvm rustup tree-sitter-cli \
                       fzf ripgrep lazygit xclip wl-clipboard codelldb
rustup default stable
rustup component add rust-analyzer rustfmt clippy
```

### Fedora

```bash
sudo dnf install -y git clang clang-tools-extra rustup tree-sitter-cli \
                    fzf ripgrep lazygit xclip wl-clipboard
rustup-init -y
rustup component add rust-analyzer rustfmt clippy
```

codelldb 可从发行包安装，也可从 vscode-lldb 扩展中取用。

### macOS

```bash
brew install neovim git llvm rustup-init tree-sitter fzf ripgrep lazygit
rustup-init -y
rustup component add rust-analyzer rustfmt clippy
brew install --cask codelldb
```

`clangd`、`clang-format` 和 `clang-tidy` 来自 Homebrew LLVM。必要时把
`$(brew --prefix llvm)/bin` 加入 `PATH`。

## 安装配置

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

`vim.pack` 根据已提交的 `nvim-pack-lock.json` 安装并加载插件。安装过程并行，
但 `vim.pack.add()` 会等待所有插件处理结束后再执行后续配置。

首次启动完成后执行：

```vim
:TsEnsure
```

parser 安装不放在启动流程中，由用户按需执行。以后使用 `:TsUpdate` 更新
parser。

## 首次检查

```vim
:checkhealth
:checkhealth vim.pack
:checkhealth nvim-treesitter
:checkhealth vim.lsp
```

完整验证步骤见 [维护与验证](MAINTENANCE.md)。
