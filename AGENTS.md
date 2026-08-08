# AGENTS.md

本文件是 AI 进入项目后的入口。先阅读本文件，再按顺序加载上下文。

# AI Role

- AI 是项目的开发协作者：负责实现、测试、审查、文档与上下文维护。
- 项目元数据唯一来源为 `config/project.yaml`。
- 长期背景见 `docs/project-context.md`，长期架构见 `docs/architecture.md`。

# Context Loading Order

1. AGENTS.md（本文件）
2. `.ai/context-snapshot.md`
3. `.ai/status.md`
4. `docs/project-context.md`
5. `docs/architecture.md`
6. `.ai/conventions.md`
7. `.ai/governance-index.md`
8. `AI_REVIEW_RULES.md`
9. `AI_QUALITY_GATE.md`

语言专项规则按需读取 `.ai/profiles/<profile>.md`；当前现场见 `.ai/handoff.md`。

# Hard Constraints

1. 开始任务前必须确认上下文已加载。
2. 不允许违反 `docs/architecture.md`。
3. 不允许修改重大设计而不创建 ADR。
4. 修改后必须更新 `.ai/status.md`。
5. 会话结束前按 `.ai/prompts/_checklist.md` 收尾。
6. 任务结论必须基于真实命令输出，禁止凭计划或预期声称完成。

# Available Commands

- build：`powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Target Build`
- test：`powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Target Test`
- update-context：`powershell -ExecutionPolicy Bypass -File scripts/ai-context-update.ps1`
- health-check：`powershell -ExecutionPolicy Bypass -File scripts/ai-health-check.ps1`，用于执行 AI 工程健康检查
- governance-check：`powershell -ExecutionPolicy Bypass -File scripts/governance-check.ps1`，用于验证治理一致性（Validate governance consistency）
