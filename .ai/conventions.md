# 约定

## 元数据

- 项目元数据唯一来源为 `config/project.yaml`；`AGENTS.md`、`status.md` 不得复制版本与 profile。
- 修改元数据只改该文件，然后执行 `scripts/ai-context-update.ps1` 刷新快照。

## 目录约定

- `src/` 只放实现，按语言 profile 组织。
- `tests/` 与 `src/` 保持相同模块层级。
- 新模块必须先在 `docs/architecture.md` 登记边界。

## 命名

- C/C++：snake_case 文件，PascalCase 类型，小写函数名。
- C#：PascalCase 类型与方法，camelCase 局部变量。
- Python：snake_case。
- LabVIEW：见 `docs/labview/`。

## 错误处理

- 所有对外接口必须有明确失败语义，禁止吞异常。
- 硬件操作必须区分驱动错误和业务错误。

## 测试要求

- 每个新功能至少一个测试。
- 硬件相关逻辑提供模拟模式或接口替身。
- 构建/测试结果写入 `build/last-build.json`、`build/last-test.json`，快照读取真实状态。

## Definition of Done

任务完成必须同时满足：

1. 对应 Spec 验收标准通过，或明确记录例外。
2. `scripts/build.ps1` 的构建与测试报告状态为 passed。
3. 新代码有测试覆盖。
4. 模块边界变化时 `docs/architecture.md` 已更新。
5. 架构决策有对应 ADR。
6. `task-log.md` 追加、`status.md` 更新、`handoff.md` 更新。
7. `scripts/ai-health-check.ps1` 无 FAIL。

## 提交规范

- 单次提交只做一件事。
- 提交信息：`<type>(<scope>): <summary>`，type 使用 feat/fix/docs/test/refactor/chore。

## AI Execution Rules

1. 所有命令执行必须获得真实返回结果。
2. 禁止根据计划或者预期结果声称完成。
3. 修改文件后必须输出修改列表。
4. 测试完成必须提供测试结果。
5. 发布判断必须基于实际检查结果。
