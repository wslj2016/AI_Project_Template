# AI Review Rules

本文件定义自动 Review-Repair 循环的规则。

## 问题分级

| 级别 | 定义 | 示例 | 处置 |
| ---- | ---- | ---- | ---- |
| P0 | 阻断发布：核心知识库不可用或脚本不可运行 | AGENTS 入口失效、脚本语法错误 | 立即修复 |
| P1 | 引用断裂、文档与实现不一致、质量门无法执行 | 引用文件不存在、指向已删除路径、CI 无法解析 profile | 本循环自动修复 |
| P2 | 结构或能力可改进，但不阻断发布 | profile 深度不足、健康检查未校验引用、缺少 docs 总索引 | 只记录，不修改 |
| P3 | 优化建议或可选项 | task-log 机器可解析、自动漂移检测 | 只记录，不修改 |

## Review 范围

- `.ai/**/*.md`
- `AGENTS.md`、`README.md`
- `config/`、`scripts/`、`.github/workflows/`
- `docs/`、`spec/`

## 循环流程

1. 读取 `.ai/*.md` 与配套文件。
2. 按本规则分级。
3. 只修复 P0/P1。
4. 重新 Review，直到连续一次无新 P0/P1。
5. 执行 `AI_QUALITY_GATE.md` 验收。

## 结束条件

- `AI_QUALITY_GATE.md` 全部通过。
- 连续一次 Review 无新 P0/P1。
- 不新增复杂功能。
- 不改变核心设计目标：通用骨架 + AI 记忆区 + 语言 profile + Spec 驱动。
