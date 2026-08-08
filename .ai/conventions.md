# AI Engineering Conventions

## 1. Purpose

本文件属于 Convention Layer，承载工程约定、开发规范、Definition of Done 条件与 AI Execution Rules 细则。

规则来源关系：

```text
AGENTS.md
    ↓
conventions.md
    ↓
AI_REVIEW_RULES.md
    ↓
AI_QUALITY_GATE.md
```

规则归属：META-001、DOD-001、EXE-001 的本体细则由本文件承载；`AGENTS.md` 保留硬约束引用；Review 规则、Quality Gate 规则、Release 验收与 Session Closing 操作步骤由各自 Owner 文件承载，本文件不复制。

## 2. META-001 元数据维护流程

- `config/project.yaml` 是项目元数据唯一来源；`AGENTS.md` 与 `.ai/status.md` 不复制版本与 profile 作为独立来源。
- 禁止直接手工修改生成文件（如 `.ai/context-snapshot.md`、`build/last-build.json`、`build/last-test.json`）。
- 修改元数据后执行 `scripts/ai-context-update.ps1` 刷新快照。

## 3. 目录与模块约定

- `src/` 只放实现，按语言 profile 组织。
- `tests/` 与 `src/` 保持相同模块层级。
- `docs/` 只放长期知识（架构、决策、发布、专项规则），一次性任务状态归 `.ai/`。
- 新模块必须先登记 `docs/architecture.md` 模块边界。

## 4. 命名规范

- C/C++：snake_case 文件，PascalCase 类型，小写函数名。
- C#：PascalCase 类型与方法，camelCase 局部变量。
- Python：snake_case。
- LabVIEW：见 `docs/labview/`。

## 5. 错误处理规范

- 所有对外接口必须有明确失败语义。
- 返回值必须被检查，失败必须向调用方传播明确错误，禁止吞异常。
- 异常处理不得掩盖业务失败，失败原因必须可追溯。
- 硬件操作必须区分驱动错误和业务错误。

## 6. 测试规范

- 每个新功能至少一个测试。
- 硬件相关逻辑提供模拟模式或接口替身（Mock/Simulation）。
- 构建/测试结果写入 `build/last-build.json`、`build/last-test.json`；快照读取真实状态。

## 7. DOD-001 Definition of Done

任务完成必须同时满足以下条件：

- Spec 验收标准通过，或明确记录例外。
- 测试满足本文件测试规范。
- 模块边界变化时 `docs/architecture.md` 已更新。
- 重大设计有对应 ADR（引用 `AGENTS.md` 硬约束）。
- 收尾记录完成（引用 `.ai/prompts/_checklist.md`）。
- Quality Gate 证据满足（引用 `AI_QUALITY_GATE.md`）。

## 8. 提交规范

- 单次提交只做一件事。
- 提交信息：`<type>(<scope>): <summary>`，type 使用 feat/fix/docs/test/refactor/chore。

## 9. EXE-001 AI Execution Rules

1. 所有命令执行必须获得真实返回结果。
2. 禁止根据计划或者预期结果声称完成。
3. 修改文件后必须输出修改列表。
4. 测试完成必须提供测试结果。
5. 发布判断必须基于实际检查结果。
