# Task Instance Record

> 模板：新任务复制本文件为 `.ai/tasks/TSK-####.md`，不要直接修改模板。

## Identity

- Instance ID: TSK-0000
- Title: <任务标题>
- Status: New
- Created: YYYY-MM-DD
- Owner: <Codex / 人工>

## References

- Spec: <spec 路径或 "-">
- ADR: <ADR 编号或 "-">
- Prompt: <绑定 Prompt>

## Goal

<任务目标>

## Evidence

| Type | Evidence | Result |
| --- | --- | --- |
| health-check | scripts/ai-health-check.ps1 | 待执行 |
| governance-check | scripts/governance-check.ps1 | 待执行 |
| build | build/last-build.json | 待执行 |
| test | build/last-test.json | 待执行 |

## Transition Log

| Date | From | To | Evidence | Notes |
| --- | --- | --- | --- | --- |
| YYYY-MM-DD | New | Planning | <上下文加载证据> | <备注> |

## Blockers / Exceptions

- <阻塞原因或 EXC 引用；无则 "-">
