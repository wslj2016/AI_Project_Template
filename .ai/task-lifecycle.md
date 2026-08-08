# AI Task Lifecycle Governance Capability

## 1. Purpose

Task Lifecycle 是项目的 Cross-layer Governance Capability，不是第八个治理 Layer。

本文件是 Task Lifecycle 的唯一规则 Owner，承载 TASK-001 ~ TASK-004；其他文件只引用、不复制正文。

Task Lifecycle 横跨并引用以下现有 Layer：

- Entry Layer：`AGENTS.md` 上下文加载
- Convention Layer：`.ai/conventions.md`（DOD-001、EXE-001）
- Review Layer：`AI_REVIEW_RULES.md`（REV-001 ~ REV-006）
- Quality Gate Layer：`AI_QUALITY_GATE.md`（G-001 ~ G-006、EXC-001 ~ EXC-003）
- Execution Layer：`scripts/` 构建、测试、健康检查、治理检查
- Record Layer：`.ai/status.md`、`.ai/task-log.md`、`.ai/handoff.md`、`.ai/tasks/`
- Closing Layer：`.ai/prompts/_checklist.md`

## 2. Rule Ownership

| Rule ID | Rule Name | Owner |
| --- | --- | --- |
| TASK-001 | Lifecycle State Model | 本文件 |
| TASK-002 | Transition Rules | 本文件 |
| TASK-003 | Task Record Standard | 本文件 |
| TASK-004 | Prompt Binding | 本文件 |

## 3. TASK-001 Lifecycle State Model

定义：任务生命周期状态集合与状态定义。

| 状态 | 定义 | 关联 Layer |
| --- | --- | --- |
| New | 任务已登记，Task Instance Record 已创建 | Record |
| Planning | 上下文已加载，正在规划任务范围、Spec/ADR 引用与实施步骤 | Entry、Record |
| Implementing | 正在修改代码、文档或配置 | Execution、Convention |
| Verifying | 执行 build/test/health-check/governance-check 并收集证据 | Execution |
| Reviewing | 按 REV-004/REV-005 执行 Review-Repair 循环 | Review |
| Closing | 核验 DOD-001 与适用 G-xxx，执行 `_checklist.md` | Quality Gate、Closing |
| Completed | 终态：任务验收完成并归档 | Record、Closing |
| Blocked | 暂停态：阻塞、等待输入或外部依赖 | Record |
| Cancelled | 终态：任务被明确取消并记录原因 | Record |

状态机主路径：

```text
New → Planning → Implementing → Verifying → Reviewing → Closing → Completed
                      ↑                            │
                      └──────── Review 修复 ────────┘
任意状态 → Blocked → 原状态或后续状态
任意进行中状态 → Cancelled
```

## 4. TASK-002 Transition Rules

定义：允许的状态转移、进入/退出条件与 Evidence 要求。

| From | To | 条件 | Evidence |
| --- | --- | --- | --- |
| New | Planning | 上下文已按 AGENTS 顺序加载 | Task Instance Record 存在 |
| Planning | Implementing | 计划/设计完成，Spec/ADR 引用明确 | 计划记录、Spec/ADR 引用 |
| Implementing | Verifying | 修改完成 | 修改文件列表 |
| Verifying | Reviewing | build/test/health-check/governance-check 证据有效 | 真实命令输出或报告 |
| Reviewing | Implementing | Review 发现 P0/P1 需要修复 | REV 记录 |
| Reviewing | Closing | REV-005 满足 | Review 结论 |
| Closing | Completed | DOD-001 与适用 G-xxx 满足，收尾清单完成 | 收尾记录、health-check/governance-check 输出 |
| 任意状态 | Blocked | 阻塞、等待输入或外部依赖 | Blocked 原因与引用 |
| Blocked | 任意状态 | 阻塞解除或上下文恢复 | 解除原因与证据 |
| 任意进行中状态 | Cancelled | 明确取消并记录原因 | 取消原因与决策引用 |

原则：

- 只允许表中转移，其他转移视为非法。
- 每次转移必须更新 Task Instance Record 的 Transition Log。
- 不允许跳过 Closing 直接从 Reviewing 声明 Completed。
- Blocked 是暂停态，不是终态；Cancelled 和 Completed 是唯一终态。
- 终态判断必须基于真实命令输出或文件证据，引用 EXE-001。

## 5. TASK-003 Task Record Standard

定义：Task Instance Record 的命名、位置、字段与维护要求。

### Task Instance ID

- 格式：`TSK-####`，`####` 为四位序号，从 `TSK-0001` 递增，不重复使用。
- Task Instance ID 是任务实例身份，不是治理规则 ID，不登记 `.ai/governance-index.md`。
- 示例：`TSK-0001`。

### 文件位置

- 每个任务一个记录文件：`.ai/tasks/<TSK-####>.md`
- 模板：`.ai/tasks/_template.md`
- 新任务复制模板生成实例文件，不直接修改模板。

### 必需字段

- Instance ID
- Title
- Status（来自 TASK-001 状态集合）
- Created / Owner
- References（Spec / ADR / Prompt）
- Goal
- Evidence
- Transition Log
- Blockers / Exceptions

### 维护要求

- 任务生命周期内，状态变化时同步更新实例记录。
- `.ai/task-log.md` 每次会话追加记录，并引用 Task Instance ID。
- `.ai/status.md`、`.ai/handoff.md` 引用当前活跃 Task Instance ID。

## 6. TASK-004 Prompt Binding

定义：状态到 Prompt 的绑定关系。

| 状态 | 绑定 Prompt |
| --- | --- |
| New | `01-init` |
| Planning | `02-plan`、`09-spec` |
| Implementing | `03-implement`、`06-refactor`、`08-debug`、`10-documentation`、`11-integrate` |
| Verifying | `05-test` |
| Reviewing | `04-review` |
| Closing | `07-release`、`_checklist.md` |
| Completed / Blocked / Cancelled | 按需执行收尾或恢复 Prompt |

说明：

- Prompt 是执行工具，不承载规则正文。
- 绑定变化只修改本文件 TASK-004，不修改单个 Prompt。

## 7. Evidence Requirements

- 状态转移与终态判断必须以真实命令输出或文件证据为准（EXE-001）。
- 构建/测试证据：`build/last-build.json`、`build/last-test.json`
- 健康检查证据：`scripts/ai-health-check.ps1` 输出
- 治理检查证据：`scripts/governance-check.ps1` 输出
- 文档与上下文证据：`.ai/governance-index.md`、ADR、`.ai/status.md`、`.ai/handoff.md`、`.ai/context-snapshot.md`

## 8. References

- AGENTS.md
- .ai/conventions.md
- AI_REVIEW_RULES.md
- AI_QUALITY_GATE.md
- .ai/governance-index.md
- .ai/prompts/_checklist.md
- docs/decisions/0003-ai-governance-architecture.md
- docs/decisions/0004-task-lifecycle-framework.md
