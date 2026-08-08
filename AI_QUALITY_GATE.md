# AI Quality Gate

发布前必须全部通过。

## Template Project Exception

以下 Warning 允许存在：

- language_profile=TBD
- build skipped
- test skipped

原因：当前项目为模板，不是实际软件项目。

When copied to real project:

These warnings must be resolved.

## G1 质量策略

- `AI_REVIEW_RULES.md` 存在。
- `AI_QUALITY_GATE.md` 存在。
- 两者被 `README.md` 或 `AGENTS.md` 引用。

## G2 脚本可运行

- `scripts/read-project.ps1`、`build.ps1`、`ai-context-update.ps1`、`ai-health-check.ps1` 可无错运行。
- `ai-health-check.ps1` 退出码为 0 且无 FAIL。

## G3 引用完整

- `AGENTS.md` 引用的文件存在：`config/project.yaml`、`.ai/status.md`、`.ai/context-snapshot.md`、`.ai/handoff.md`、`spec/INDEX.md`、`.ai/profiles/`、`.ai/prompts/_checklist.md`。
- `task-log.md`、`handoff.md` 引用的 ADR 存在。
- 无指向已删除路径（`config/version.txt`）的文档。

## G4 上下文可恢复

- 快照包含 Project、Language Profile、Git Commit、Branch、Version、Last Update、Build/Test Status。
- `status.md` 的“已完成”只声明真实存在的内容。

## G5 生命周期完整

- `.ai/prompts/` 包含 01-11 与 `_checklist.md`。
- 01-07 均引用 `_checklist.md`。

## G6 CI 有效

- `ci.yml` 能从 `config/project.yaml` 解析 `language_profile` 并传递给 build/test。

## G7 不越界

- 本循环未新增复杂功能。
- 核心设计目标未改变。
