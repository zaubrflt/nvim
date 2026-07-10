-- 通用编辑器选项。在所有插件加载之前生效。
-- 完整文档参见 :help option-list 或 https://neovim.io/doc/user/options.html

local opt = vim.opt

-- ─────────────────────────────────────────────────────────────────────────────
-- 缩进相关（需求 1：默认空格缩进）
-- ─────────────────────────────────────────────────────────────────────────────
opt.expandtab    = true   -- 按 <Tab> 时插入空格而不是制表符
opt.shiftwidth   = 4      -- 自动缩进 / >> << 时的缩进宽度（空格数）
opt.tabstop      = 4      -- 文件中真实 <Tab> 字符显示为几个空格的宽度
opt.softtabstop  = 4      -- 编辑时 <Tab> / <BS> 视觉上对齐的空格数
opt.smartindent  = true   -- 根据语法智能推断下一行缩进（C/C++ 友好）
opt.autoindent   = true   -- 新行复用上一行的缩进
opt.shiftround   = true   -- >> << 时把缩进对齐到 shiftwidth 的整数倍

-- ─────────────────────────────────────────────────────────────────────────────
-- 视觉 / 行号 / 滚动
-- ─────────────────────────────────────────────────────────────────────────────
opt.number         = true    -- 显示绝对行号
opt.relativenumber = true    -- 同时显示相对行号（便于 5j / 12k 这类跳转）
opt.signcolumn     = 'yes'   -- 始终显示 sign 列，避免 LSP 诊断 / git 标记导致行号跳动
opt.cursorline     = true    -- 高亮光标所在行
opt.wrap           = false   -- 不自动折行（长行水平滚动）
opt.linebreak      = true    -- 若开启 wrap 时按单词边界折行而不是从中间断开
opt.scrolloff      = 8       -- 上下滚动时光标距离窗口边缘至少保留 8 行
opt.sidescrolloff  = 8       -- 水平滚动时光标距离左右边缘至少保留 8 列
opt.colorcolumn    = '100'   -- 在第 100 列画一条参考线，提示行宽

-- ─────────────────────────────────────────────────────────────────────────────
-- 搜索
-- ─────────────────────────────────────────────────────────────────────────────
opt.ignorecase = true   -- 搜索时忽略大小写
opt.smartcase  = true   -- 但若搜索词包含大写字母则恢复区分大小写
opt.incsearch  = true   -- 边输入边高亮匹配
opt.hlsearch   = true   -- 搜索完成后保留高亮（用 <esc> 清除，见 keymaps.lua）

-- ─────────────────────────────────────────────────────────────────────────────
-- 通用 UI / 窗口行为
-- ─────────────────────────────────────────────────────────────────────────────
opt.termguicolors = true            -- 启用 24-bit 真彩色，主题才能正确渲染
opt.mouse         = 'a'             -- 在所有模式下启用鼠标
opt.clipboard     = 'unnamedplus'   -- 与系统剪贴板同步（Linux 需 xclip / wl-clipboard）
opt.showmode      = false           -- 不在最后一行显示 -- INSERT --（statusline 已展示）
opt.laststatus    = 3               -- 全局状态栏（多窗口时只有一条状态栏）
opt.cmdheight     = 1               -- 命令行高度
opt.splitright    = true            -- 垂直分屏新窗口出现在右侧
opt.splitbelow    = true            -- 水平分屏新窗口出现在下方
opt.fillchars     = { eob = ' ', fold = ' ' }                       -- 隐藏 buffer 末尾的 ~ 与折叠填充字符
opt.list          = true                                            -- 显示不可见字符
opt.listchars     = { tab = '» ', trail = '·', nbsp = '␣' }         -- 制表符 / 行尾空格 / 不间断空格的展示样式

-- ─────────────────────────────────────────────────────────────────────────────
-- 文件 / 持久化 / 性能
-- ─────────────────────────────────────────────────────────────────────────────
opt.undofile    = true   -- 持久化 undo 历史，重启后仍可撤销
opt.swapfile    = false  -- 不生成 .swp 文件
opt.backup      = false  -- 不生成备份文件
opt.updatetime  = 250    -- CursorHold 触发延迟（毫秒），影响 LSP / gitsigns 响应速度
opt.timeoutlen  = 400    -- 等待映射后续按键的时长（毫秒）

-- ─────────────────────────────────────────────────────────────────────────────
-- 内置补全菜单（blink.cmp 也会读取这些值）
-- ─────────────────────────────────────────────────────────────────────────────
opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy' }  -- 始终弹菜单 / 不预选 / 启用模糊匹配
opt.pumheight   = 12                                          -- 补全菜单最多显示 12 项
opt.confirm     = true                                        -- 退出未保存 buffer 时弹确认而不是直接报错

-- ─────────────────────────────────────────────────────────────────────────────
-- 折叠（基于 treesitter，foldexpr 由 plugins/treesitter.lua 在 FileType 时再确认）
-- ─────────────────────────────────────────────────────────────────────────────
opt.foldmethod     = 'expr'                              -- 使用表达式驱动的折叠
opt.foldexpr       = 'v:lua.vim.treesitter.foldexpr()'   -- 由 treesitter 计算折叠层级
opt.foldlevel      = 99                                  -- 默认全部展开（数值越大折叠越少）
opt.foldlevelstart = 99                                  -- 打开新文件时同样默认全部展开
opt.foldenable     = true                                -- 启用折叠功能本身

-- ─────────────────────────────────────────────────────────────────────────────
-- 禁用未使用的语言 provider，去掉 :checkhealth 里的 Perl/Ruby/Node/Python
-- 噪音警告。这些 provider 仅在写对应语言的 :perl/:ruby/:py 命令或
-- 远程插件时才需要，本仓库的所有插件都用纯 Lua/VimScript 实现。
-- ─────────────────────────────────────────────────────────────────────────────
vim.g.loaded_perl_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider   = 0
