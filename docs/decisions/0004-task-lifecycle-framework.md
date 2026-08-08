# ADR-0004 AI Task Lifecycle Framework

## Status

Accepted

## Context

- ADR-0003 定义了七层治理模型。
- 现有生命周期 Prompt 01-11 与 `_checklist.md` 已存在，但缺少状态机、任务记录标准与规则归属。
- 任务状态分散在 `.ai/status.md`、`.ai/task-log.md`、`.ai/handoff.md`，缺少统一 Task Instance Record。
- Task Lifecycle 横跨 Entry、Convention、Review、Quality Gate、Execution、Record、Closing 各层，不适合作为新增第八层。

## Decision

将 Task Lifecycle 定义为 Cross-layer Governance Capability，而不是新增 Layer：

1. ADR-0003 七层模型保持不变，不修改 ADR-0003。
2. 新增规则族 `TASK-001` ~ `TASK-004`，唯一 Owner 为 `.ai/task-lifecycle.md`：
   - TASK-001 Lifecycle State Model
   - TASK-002 Transition Rules
   - TASK-003 Task Record Standard
   - TASK-004 Prompt Binding
3. TASK Rule ID 是治理规则 ID，登记到 `.ai/governance-index.md`。
4. Task Instance ID 使用 `TSK-####` 命名空间（从 `TSK-0001` 递增），记录文件为 `.ai/tasks/TSK-####.md`；Instance ID 不是治理规则，不登记 governance-index。
5. 生命周期引用现有 DOD-001、REV-001 ~ REV-006、G-001 ~ G-006、EXC-001 ~ EXC-003，不复制这些规则正文。
6. Phase 4.1 不新增 GOV-007/GOV-008，不修改 `scripts/governance-check.ps1`；TASK 规则的机器校验延期至生命周期稳定后。

## Consequences

优点：

- 保持七层模型稳定，生命周期作为跨层能力编排现有规则。
- TASK Rule ID 与 Task Instance ID 分离，规则与实例互不混淆。
- 任务状态、转移、记录与 Prompt 绑定有唯一归属。

缺点：

- TASK 规则在稳定前依赖 Review 与收尾清单保证一致性，机器校验滞后。
- 需要维护 Task Instance Record 与 status/task-log/handoff 的多点一致。

## References

- ADR-0003
- AGENTS.md
- `.ai/task-lifecycle.md`
- `.ai/governance-index.md`
- `.ai/prompts/_checklist.md`
