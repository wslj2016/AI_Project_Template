# ADR-0003 AI Governance Architecture

## Status

Accepted

## Context

当前规则分散在：

- `AGENTS.md`
- `.ai/conventions.md`
- `AI_REVIEW_RULES.md`
- `AI_QUALITY_GATE.md`

存在：

- 重复定义：执行纪律、DoD、ADR 与状态更新规则在多处复述。
- 规则漂移：同一规则多处声明，修改单点后容易产生不一致。
- 无唯一归属：规则没有唯一 ID 与归属表，无法确定修改入口。
- 无机器校验能力：健康检查只校验文件存在与报告状态，无法发现规则重复或归属冲突。

## Decision

采用七层治理模型：

1. Entry Layer：`AGENTS.md` 负责上下文引导、命令地图与硬约束。
2. Convention Layer：`.ai/conventions.md` 负责工程约定与开发规范。
3. Review Layer：`AI_REVIEW_RULES.md` 负责问题分级与 Review-Repair 循环。
4. Quality Gate Layer：`AI_QUALITY_GATE.md` 负责发布验收与模板例外。
5. Execution Layer：`scripts/` 负责构建、测试、上下文刷新与健康检查，产生可验证证据。
6. Record Layer：`.ai/status.md`、`.ai/task-log.md`、`.ai/handoff.md`、`docs/decisions/` 负责状态与决策历史。
7. Closing Layer：`.ai/prompts/_checklist.md` 负责会话收尾操作序列。

各层只承担单一职责，高层规则可以被低层引用，但低层不得反向定义高层职责。

## Rule Ownership Principle

单规则单归属。

每条规则只能有一个规范文件作为唯一来源，其他文件只引用、不重复定义；规则新增、修改或废止时必须更新归属记录，并通过 ADR 记录变更。

## Consequences

优点：

- AI 行为一致：所有会话从同一规则入口获得稳定行为。
- 人机协作可追踪：规则归属与变更历史可审计。
- 可自动检查：规则归属、引用完整性与执行证据可由脚本校验。

缺点：

- 初期需要整理规则：现有重复定义需要迁移到唯一归属，迁移期间需要人工核对一致性。
- 需要维护新增的规则归属记录，规则变更成本略有上升。

后续落地包括：新增规则归属索引、建立规则 ID 体系、扩展健康检查校验能力，并补充 `AGENTS.md` 命令地图中的健康检查入口。
