# AI Engineering Release Quality Gate

## 1. Purpose

本文件属于 Quality Gate Layer。

职责：定义 Release 判断标准和 Evidence Mapping。

本文件承载 `G-001` ~ `G-006`；不承载 Coding 规范（`.ai/conventions.md`）、Review 流程（`AI_REVIEW_RULES.md`）与会话关闭步骤（`.ai/prompts/_checklist.md`）。

引用关系：

```text
AGENTS.md
↓
conventions.md
↓
Review Rules
↓
Quality Gate
```

## 2. Gate Definition

Release 必须满足：所有 G-xxx 通过。

每个 Gate 必须包含：

- Rule ID
- 判断条件
- Evidence
- Validation 方式

## 3. G-001 Build/Test Evidence

- Rule ID：`G-001`
- 判断条件：build/test 报告存在且状态有效；skipped 只能作为 Template Exception（`G-006`）
- Evidence：`build/last-build.json`、`build/last-test.json`
- Validation 方式：`scripts/build.ps1` 生成报告；health-check 读取报告状态

## 4. G-002 AI Health Check

- Rule ID：`G-002`
- 判断条件：exit code 为 0，failure 数量为 0
- Evidence：`scripts/ai-health-check.ps1` 输出
- Validation 方式：执行 health-check；warning 必须登记到 `G-006` 或由 Owner 记录，真实项目必须消除非豁免 warning

## 5. G-003 Documentation Integrity

- Rule ID：`G-003`
- 判断条件：governance-index、ADR、docs、references 完整且有效
- Evidence：`.ai/governance-index.md`、`docs/decisions/README.md`、引用解析结果
- Validation 方式：以索引和引用完整性为准，不硬编码大量文件列表；无指向已删除路径

## 6. G-004 Context Recoverability

- Rule ID：`G-004`
- 判断条件：context snapshot、status、handoff 可恢复当前现场
- Evidence：`.ai/context-snapshot.md`、`.ai/status.md`、`.ai/handoff.md`
- Validation 方式：快照必需字段完整；status 只声明真实内容（引用 `EXE-001`）

## 7. G-005 Tooling & CI Evidence

- Rule ID：`G-005`
- 判断条件：scripts、build、CI workflow 可执行且可产生证据
- Evidence：`scripts/read-project.ps1`、`scripts/build.ps1`、`scripts/ai-context-update.ps1`、`scripts/ai-health-check.ps1`、`.github/workflows/ci.yml`
- Validation 方式：脚本无错运行；CI 从 `config/project.yaml` 解析 `language_profile` 并执行 build/test

## 8. G-006 Exception Handling

- Rule ID：`G-006`
- 判断条件：所有 Warning 必须登记 Exception，每个 Exception 包含 ID、Reason、Impact、Owner、Remove Condition；Owner 固定为 `AI_QUALITY_GATE.md`
- Evidence：本文件 Exception 表
- Validation 方式：health-check 输出的 Warning 必须能在 Exception 表中找到；真实项目不得保留未移除的 Exception

### Template Exceptions

| Exception ID | 内容 | Reason | Impact | Owner | Remove Condition |
| --- | --- | --- | --- | --- | --- |
| EXC-001 | `language_profile=TBD` | 模板支持多语言，未绑定具体项目 | 无法执行 profile 专属构建/测试/CI | `AI_QUALITY_GATE.md` | 设置为实际语言 profile |
| EXC-002 | `build skipped` | 未配置语言 profile | 无构建证据 | `AI_QUALITY_GATE.md` | 配置 profile 后 build 产生有效报告 |
| EXC-003 | `test skipped` | 未配置测试目标 | 无测试证据 | `AI_QUALITY_GATE.md` | 配置 profile 后 test 产生有效报告 |

When copied to real project: all exceptions must be removed.

## 9. References

- `AGENTS.md`
- `.ai/conventions.md`
- `AI_REVIEW_RULES.md`
- `.ai/governance-index.md`
- `.ai/prompts/_checklist.md`
