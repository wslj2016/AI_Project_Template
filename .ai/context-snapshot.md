# Project

- 项目名称: AI_Project_Template
- 当前版本: 0.1.0

# Environment

- 开发环境: TBD
- 工具链: TBD

# Git Status

- Branch: master
- Commit: 9b3afce
- Last Update: 2026-08-08 11:15:39

# Build Status

- Status: Not Configured
- Result: skipped
- Last Build Time: 2026-08-08 10:41:01
- Details: No language profile configured.
- Reason: No language profile configured.

# Test Status

- Status: Not Configured
- Result: skipped
- Last Test Time: 2026-08-08 10:41:01
- Details: No test target configured.
- Reason: No test target configured.

# Current Milestone

模板已达到可发布版本基线，并已固化 Git 首次提交。

# Completed Tasks

- 模板骨架与生命周期 Prompt。; - Git 仓库初始化与模板首次提交。; - 元数据单一来源 `config/project.yaml`。; - 构建/测试报告与上下文快照联动。; - handoff 与会话健康检查。

# Current Tasks

无

# Blocked Issues

无

# Recent Changes

| 2026-08-08 | Codex | 发布前 Review-Repair 循环 | AI_REVIEW_RULES.md、AI_QUALITY_GATE.md、.ai/prompts/、spec/INDEX.md、docs/decisions/、.github/workflows/、README.md、config/README.md | ADR-0002 | 完成 | || | 2026-08-08 | Codex | 初始化 Git 基线 | 全仓库（首次提交） | ADR-0001 | 完成 |

# Important Decisions

0001 | 通用骨架 + 语言 Profile + AI 记忆区 | Accepted | 2026-08-08 |; 0002 | 模板发布前的质量加固 | Accepted | 2026-08-08 |

# Files Changed Recently

 M .ai/context-snapshot.md

# Next Actions

1. 为新项目设置 `config/project.yaml` 的 `language_profile`。; 2. 创建第一条 Spec。; 3. 执行 `scripts/ai-health-check.ps1` 验收知识库完整性。

# AI Instructions

- Read AGENTS.md first, then this snapshot and .ai/status.md.
- Keep long-term design details in docs/, not here.
- Refresh this file with scripts/ai-context-update.ps1 at session end.
- Follow .ai/prompts/_checklist.md when closing a session.
