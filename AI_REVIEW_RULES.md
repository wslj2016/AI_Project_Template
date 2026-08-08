# AI Review Governance Layer

## 1. Purpose

本文件属于 Review Layer。

职责：代码/文档/架构变更的自动检查与修复循环。

本文件承载 `REV-001` ~ `REV-006`，不承载工程开发规范（`.ai/conventions.md`）、发布验收条件（`AI_QUALITY_GATE.md`）与会话关闭步骤（`.ai/prompts/_checklist.md`）。

引用关系：

```text
conventions.md
        ↓
AI_REVIEW_RULES.md
        ↓
AI_QUALITY_GATE.md
```

## 2. REV-001 Review Scope

定义：Review 检查范围。

- `.ai/**/*.md`
- `.ai/task-lifecycle.md`（Task Lifecycle 规则）
- `.ai/tasks/`（Task Instance Record）
- `AGENTS.md`、`README.md`
- `config/`、`scripts/`、`.github/workflows/`
- `docs/`、`spec/`

范围变化时同步更新 `.ai/governance-index.md`。此处不增加开发规范。

## 3. REV-002 Severity Classification

定义：P0-P3 严重级别，包含定义、判断标准与示例。

| 级别 | 定义与判断标准 | 示例 |
| ---- | ---- | ---- |
| P0 | 阻断发布：核心知识库不可用或脚本不可运行 | AGENTS 入口失效、脚本语法错误 |
| P1 | 阻断一致性：引用断裂、文档与实现不一致、质量门无法执行 | 引用文件不存在、指向已删除路径、CI 无法解析 profile |
| P2 | 不阻断发布：结构或能力可改进 | profile 深度不足、健康检查未校验引用、缺少 docs 总索引 |
| P3 | 不阻断发布：优化建议或可选项 | task-log 机器可解析、自动漂移检测 |

## 4. REV-003 Auto Fix Boundary

定义：问题处理边界。

- P0：必须修复。
- P1：当前 Review 循环修复。
- P2/P3：只记录，不自动修改。

## 5. REV-004 Review Process

定义：完整 Review-Repair 循环。

1. 按照 `AGENTS.md` 恢复上下文。
2. 检查 Review Scope。
3. 发现问题并按 `REV-002` 分类。
4. 按照 `REV-003` 处理。
5. 重新 Review。
6. 直到无新增 P0/P1。
7. 引用 `AI_QUALITY_GATE.md` validation 进行验收：All applicable G-xxx gates passed。

## 6. REV-005 Completion Criteria

定义：Review 完成条件。

- 连续一次 Review 无新增 P0/P1。
- Quality Gate 满足（`AI_QUALITY_GATE.md` validation：All applicable G-xxx gates passed）。
- Review 结果记录到 task-log / handoff。

此处不复制 Quality Gate 细节。

## 7. REV-006 Scope Guard

定义：Review 循环不得扩大当前任务范围。

- Review 只处理 Review Scope 内与当前任务直接相关的问题。
- 发现范围外问题按 `REV-002` 分级并记录，不自动修改。
- 不新增复杂功能，不改变核心设计目标。

## 8. References

- `AGENTS.md`
- `.ai/conventions.md`
- `AI_QUALITY_GATE.md`
- `.ai/prompts/_checklist.md`
- `.ai/governance-index.md`
