# 质量与维护改进

[返回改进索引](../IMPROVEMENTS.md) · [实现状态](../STATUS.md)

## 启动性能基准

### 缺口

`vim.pack` 不支持 lazy loading。插件增加后，需要可重复的启动耗时记录来判断
回归，而不是凭主观感觉优化。

### 建议

本地基准：

```bash
nvim --headless --startuptime startup.log +qa
```

- 在相同机器、相同工作目录和已安装插件状态下重复多次。
- 忽略首次 clone、parser 编译和网络操作。
- 比较新增插件前后的中位数，并查看耗时最高的模块。
- `startup.log` 作为临时产物，不提交仓库。

### 验收

- 文档记录可复现命令和测量条件。
- 新增明显影响启动的插件时有前后对比。
- 不为了微小数字引入复杂 lazy-loading 框架。

## CI 与 smoke test

### 缺口

项目目标包括 Linux / macOS 兼容，但目前没有自动验证配置能否启动和通过基础
语法检查。

### 建议

先提供本地 smoke 脚本，再决定是否加入 GitHub Actions：

- `nvim --headless +qa`。
- Lua 语法或加载检查。
- 可选 `stylua --check`。
- 校验 Markdown 相对链接。
- 核对 `vim.pack` 注册与锁文件插件集合。

CI 初期不需要安装 clangd、完整 Rust toolchain 或 codelldb；重点是配置加载与
文档结构。若做 Linux / macOS 矩阵，应使用隔离 HOME，避免 session、shada 和
日志权限干扰结果。

### 验收

- Linux、macOS job 的验证范围明确。
- 缺少可选系统工具只产生预期警告，不导致配置崩溃。
- 失败输出能定位到具体 Lua 文件或文档链接。

## 仓库清理

### 当前问题

根目录存在 `.neoconf.json`，但配置没有引入 `neoconf.nvim`。该文件目前没有
明确使用者。

### 建议

确认没有外部编辑器流程依赖后删除 `.neoconf.json`。不要仅为了保留该文件而
新增 neoconf.nvim。

同时保持以下清理规则：

- checkhealth、启动性能和调试日志不提交。
- 根目录只保留运行配置、README、AGENTS、锁文件、许可证及必要元数据；
  详细文档统一位于 `docs/`。
- 文档移动后清除旧路径链接和孤立入口。

### 验收

- 仓库搜索不到 `.neoconf.json` 的有效消费者时将其删除。
- `git status` 不再长期出现临时 health 或日志输出。
- 所有 Markdown 相对链接可解析。
