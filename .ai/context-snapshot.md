# Project

- 项目名称: AI_Project_Template
- 当前版本: 0.1.0

# Environment

- 开发环境: TBD
- 工具链: TBD

# Git Status

- Branch: master
- Commit: 364f5cd
- Last Update: 2026-08-08 14:47:30

# Current Milestone

模板 v0.1.0 基线已发布（Git 首次提交 + tag v0.1.0）。

# Completed Tasks

- 模板骨架与生命周期 Prompt。; - Git 仓库初始化与模板首次提交。; - 元数据单一来源 `config/project.yaml`。; - 构建/测试报告与上下文快照联动。; - handoff 与会话健康检查。

# Current Tasks

Phase 3 AI Engineering Governance（Phase 3.7.1 完成；health-check 规则校验扩展与提交待做，暂不启动 Phase 3.8）。

# Blocked Issues

无

# Recent Changes

| 2026-08-08 | Codex | Phase 3.6.1 Quality Gate Layer 重构 | AI_QUALITY_GATE.md、.ai/governance-index.md、.ai/status.md、.ai/task-log.md、.ai/handoff.md、.ai/context-snapshot.md | ADR-0003 | 完成 | || | 2026-08-08 | Codex | Phase 3.7.1 Governance Issue Resolution | AI_REVIEW_RULES.md、AI_QUALITY_GATE.md、.ai/governance-index.md、AGENTS.md、.ai/status.md、.ai/task-log.md、.ai/handoff.md、.ai/context-snapshot.md | ADR-0003 | 完成 |

# Important Decisions

0001 | 通用骨架 + 语言 Profile + AI 记忆区 | Accepted | 2026-08-08 |; 0002 | 模板发布前的质量加固 | Accepted | 2026-08-08 |; 0003 | AI Governance Architecture | Accepted | 2026-08-08 |

# Files Changed Recently

 M .ai/context-snapshot.md;  M .ai/conventions.md;  M .ai/handoff.md;  M .ai/status.md;  M .ai/task-log.md;  M AGENTS.md;  M AI_QUALITY_GATE.md;  M AI_REVIEW_RULES.md;  M docs/decisions/README.md; ?? .ai/governance-index.md

# Next Actions

1. 扩展 `scripts/ai-health-check.ps1`，增加 governance-index 与 G/REV/EXC 规则校验（health-check 逻辑尚未修改）。; 2. 提交当前 Phase 3 治理变更。; 3. 为新项目设置 `config/project.yaml` 的 `language_profile` 并创建第一条 Spec。

# AI Instructions

- Read AGENTS.md first, then this snapshot and .ai/status.md.
- Keep long-term design details in docs/, not here.
- Refresh this file with scripts/ai-context-update.ps1 at session end.
- Follow .ai/prompts/_checklist.md when closing a session.
