# 状态

- 项目：AI_Project_Template（元数据以 `config/project.yaml` 为准）
- 语言 profile：待定，见 `config/project.yaml`
- 版本：见 `config/project.yaml`

## 当前里程碑

模板 v0.1.0 基线已发布（Git 首次提交 + tag v0.1.0）。

## 已完成

- 模板骨架与生命周期 Prompt。
- Git 仓库初始化与模板首次提交。
- 元数据单一来源 `config/project.yaml`。
- 构建/测试报告与上下文快照联动。
- handoff 与会话健康检查。
- Spec/ADR 索引与 CI profile 解析。
- 发布质量门：`AI_REVIEW_RULES.md`、`AI_QUALITY_GATE.md`。
- 质量门模板例外：`language_profile=TBD`、build/test skipped 允许存在。
- Release 记录：`docs/releases/v0.1.0.md`（tag v0.1.0）。
- 质量状态文档：`docs/quality-status.md`。
- 生命周期 Prompt 01-11 与共享收尾清单 `_checklist.md`。
- Phase 3.1/3.4：ADR-0003 治理架构、`governance-index.md` 规则索引、`AGENTS.md` 入口修正、Convention Layer 重构。
- Phase 3.5.1：Review Layer 重构为 AI Review Governance Layer（REV-001 ~ REV-005）。
- Phase 3.6.1：Quality Gate Layer 重构为 AI Engineering Release Quality Gate（G-001 ~ G-006）。
- Phase 3.7.1：治理一致性修复（REV-006、EXC 登记、质量门引用修正、AGENTS 加载顺序补齐）。
- Phase 3.8.2：Governance Validator 实现（`.ai/governance-checks.yaml` + `scripts/governance-check.ps1`，GOV-001 ~ GOV-006 本地 6/6 PASS）。
- Phase 3.8.3：Governance Check 接入 GitHub Actions（独立 `governance-check` job，push 分支补齐 `master`，AGENTS 命令入口与收尾清单同步）。
- Phase 4.1：AI Task Lifecycle Framework 实施（ADR-0004、TASK-001 ~ TASK-004、`.ai/task-lifecycle.md`、`.ai/tasks/` Task Instance Record）。
- CI governance-check 修复：GOV-003 不再把 `build/last-build.json`、`build/last-test.json` 视为死引用（生成物由 G-001 校验）。

## 进行中

无（CI governance-check 修复已推送；等待 GitHub Actions 结果）。

## 阻塞项

无

## 下一步

1. 确认 GitHub Actions governance-check PASS。
2. 为新项目设置 `config/project.yaml` 的 `language_profile` 并创建第一条 Spec。
3. TASK 规则生命周期稳定后扩展机器校验。
