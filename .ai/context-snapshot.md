# Project

- 项目名称: AI_Project_Template
- 当前版本: 0.1.0

# Environment

- 开发环境: TBD
- 工具链: TBD

# Git Status

- Branch: master
- Commit: 6a0ec6b
- Last Update: 2026-08-08 15:32:31

# Current Milestone

模板 v0.1.0 基线已发布（Git 首次提交 + tag v0.1.0）。

# Completed Tasks

- 模板骨架与生命周期 Prompt。; - Git 仓库初始化与模板首次提交。; - 元数据单一来源 `config/project.yaml`。; - 构建/测试报告与上下文快照联动。; - handoff 与会话健康检查。

# Current Tasks

无（Phase 4.1.2 已完成；提交待做）。

# Blocked Issues

无

# Recent Changes

| 2026-08-08 | Codex | Phase 3.8.3 CI Governance Check Integration | .github/workflows/ci.yml、AGENTS.md、.ai/prompts/_checklist.md、.ai/status.md、.ai/task-log.md、.ai/handoff.md | ADR-0003 | 完成 | || | 2026-08-08 | Codex | Phase 4.1.2 Task Lifecycle Framework Implementation | docs/decisions/0004-task-lifecycle-framework.md、.ai/task-lifecycle.md、.ai/tasks/_template.md、.ai/tasks/TSK-0001.md、.ai/governance-index.md、AGENTS.md、AI_REVIEW_RULES.md、.ai/prompts/_checklist.md、docs/decisions/README.md、.ai/status.md、.ai/task-log.md、.ai/handoff.md、.ai/context-snapshot.md | ADR-0004 | 完成 |

# Important Decisions

0002 | 模板发布前的质量加固 | Accepted | 2026-08-08 |; 0003 | AI Governance Architecture | Accepted | 2026-08-08 |; 0004 | AI Task Lifecycle Framework | Accepted | 2026-08-08 |

# Files Changed Recently

 M .ai/governance-index.md;  M .ai/handoff.md;  M .ai/prompts/_checklist.md;  M .ai/status.md;  M .ai/task-log.md;  M AGENTS.md;  M AI_REVIEW_RULES.md;  M docs/decisions/README.md; ?? .ai/task-lifecycle.md; ?? .ai/tasks/

# Next Actions

1. 提交 Phase 3/4.1 治理变更。; 2. 为新项目设置 `config/project.yaml` 的 `language_profile` 并创建第一条 Spec。; 3. TASK 规则生命周期稳定后扩展机器校验。

# AI Instructions

- Read AGENTS.md first, then this snapshot and .ai/status.md.
- Keep long-term design details in docs/, not here.
- Refresh this file with scripts/ai-context-update.ps1 at session end.
- Follow .ai/prompts/_checklist.md when closing a session.
