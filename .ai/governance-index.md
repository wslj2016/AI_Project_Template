# Governance Rule Index

本文件是 AI 工程治理规则的唯一索引框架。它只记录规则 ID 与归属，不复制规则正文。

## Rule ID Convention

格式：

- `META-xxx`
- `EXE-xxx`
- `DOD-xxx`
- `REV-xxx`
- `G-xxx`
- `EXC-xxx`
- `TASK-xxx`
- `ADR-xxx`

说明：

- `META`：项目元数据规则
- `EXE`：AI 执行规则
- `DOD`：Definition of Done
- `REV`：Review 规则
- `G`：Quality Gate 规则
- `EXC`：Exception 规则（Template Exception）
- `TASK`：Task Lifecycle 规则（Cross-layer Governance Capability）
- `ADR`：架构决策规则；治理规则编号，与 `docs/decisions/` 的 ADR 文档编号相互独立

编号从三位序号 `001` 开始递增，不重复使用已废止编号。

## Rule Ownership Table

| Rule ID | Rule Name | Owner File | Validation |
| ------- | --------- | ---------- | ---------- |
| META-001 | 元数据单一来源与维护流程 | `.ai/conventions.md` | `config/project.yaml` 存在且字段可解析；维护流程见 `.ai/conventions.md`；快照由 `ai-context-update.ps1` 刷新 |
| EXE-001 | 真实执行规则 | `.ai/conventions.md` | 任务结论基于真实命令输出，禁止凭计划或预期声称完成 |
| ADR-001 | 重大设计 ADR 规则 | `AGENTS.md` | 重大设计变更存在对应 `docs/decisions/` 文档并登记索引 |
| DOD-001 | 任务完成定义 | `.ai/conventions.md` | 条件列表见 `.ai/conventions.md`；按 `_checklist.md` 收尾；Quality Gate 证据满足 |
| REV-001 | Review Scope | `AI_REVIEW_RULES.md` | Review 范围与 governance-index 保持一致 |
| REV-002 | Severity Classification | `AI_REVIEW_RULES.md` | P0-P3 定义、判断标准与示例完整 |
| REV-003 | Auto Fix Boundary | `AI_REVIEW_RULES.md` | P0 必改、P1 循环修复、P2/P3 只记录 |
| REV-004 | Review Process | `AI_REVIEW_RULES.md` | 循环按 AGENTS 上下文、REV-002、REV-003 执行；验收按 `AI_QUALITY_GATE.md` validation |
| REV-005 | Completion Criteria | `AI_REVIEW_RULES.md` | 连续一次无新增 P0/P1；`AI_QUALITY_GATE.md` validation 满足；结果已记录 |
| REV-006 | Scope Guard | `AI_REVIEW_RULES.md` | Review 循环不得扩大任务范围；范围外问题只记录不自动修复 |
| G-001 | Build/Test Evidence | `AI_QUALITY_GATE.md` | build/test 报告存在且状态有效；skipped 仅允许 Template Exception |
| G-002 | AI Health Check | `AI_QUALITY_GATE.md` | `ai-health-check.ps1` 退出码为 0 且无 FAIL；warning 已登记 |
| G-003 | Documentation Integrity | `AI_QUALITY_GATE.md` | governance-index、ADR、docs、references 完整有效 |
| G-004 | Context Recoverability | `AI_QUALITY_GATE.md` | snapshot、status、handoff 可恢复现场且内容真实 |
| G-005 | Tooling & CI Evidence | `AI_QUALITY_GATE.md` | 脚本无错运行；CI 解析 profile 并执行 build/test |
| G-006 | Exception Handling | `AI_QUALITY_GATE.md` | Warning 均有 Exception 记录；真实项目无未移除例外 |
| EXC-001 | Template Exception language_profile=TBD | `AI_QUALITY_GATE.md` | Warning 已登记；真实项目必须设置语言 profile |
| EXC-002 | Template Exception build skipped | `AI_QUALITY_GATE.md` | Warning 已登记；真实项目必须产生 build 证据 |
| EXC-003 | Template Exception test skipped | `AI_QUALITY_GATE.md` | Warning 已登记；真实项目必须产生 test 证据 |
| TASK-001 | Lifecycle State Model | `.ai/task-lifecycle.md` | 状态集合与状态定义见 `.ai/task-lifecycle.md`；机器校验待生命周期稳定后扩展 |
| TASK-002 | Transition Rules | `.ai/task-lifecycle.md` | 允许转移、进入/退出条件与 Evidence 要求见 `.ai/task-lifecycle.md` |
| TASK-003 | Task Record Standard | `.ai/task-lifecycle.md` | Task Instance ID 使用 `TSK-####`，记录文件位于 `.ai/tasks/`，模板 `.ai/tasks/_template.md` |
| TASK-004 | Prompt Binding | `.ai/task-lifecycle.md` | 状态到 Prompt 01-11 与 `_checklist.md` 的绑定见 `.ai/task-lifecycle.md` |

## Ownership Notes

- `META-001`：维护流程本体位于 `.ai/conventions.md`；`AGENTS.md` 仅保留“元数据唯一来源”硬约束引用。
- `DOD-001`：条件列表位于 `.ai/conventions.md`；执行步骤由 `.ai/prompts/_checklist.md` 承载。
- `EXE-001`：细则位于 `.ai/conventions.md`；`AGENTS.md` 仅保留一行真实执行硬约束。
- `REV-001` ~ `REV-006` 归属 `AI_REVIEW_RULES.md`；`G-001` ~ `G-006` 与 `EXC-001` ~ `EXC-003` 归属 `AI_QUALITY_GATE.md`；`ADR-001` 归属保持不变。
- `TASK-001` ~ `TASK-004` 归属 `.ai/task-lifecycle.md`；规则正文见该文件，AGENTS 只加载规则文件，不自动加载 `.ai/tasks/`。

## Rule Lifecycle

- 新增规则：在 Owner File 定义规则正文，在本表登记新 ID，必要时创建 ADR。
- 修改规则：只修改 Owner File，本表更新规则名称或校验说明。
- 废止规则：保留历史行并标记 `deprecated`，不删除编号。

当前阶段只建立框架，不迁移现有规则正文；后续按 ADR-0003 逐项收敛重复定义，并扩展机器校验能力。
TASK 规则机器校验延期至生命周期稳定后。
