# ADR-0001: 模板采用通用骨架 + 语言 Profile + AI 记忆区

- 状态：已接受
- 日期：2026-08-08

## 背景

模板需要服务 C/C++、C#、LabVIEW、Python 四类项目，同时让 AI 在新会话中快速恢复上下文。

## 决策

1. 目录骨架完全统一，语言差异收敛到 `.ai/profiles/`。
2. AI 工作记忆集中在 `.ai/`，按 status / task-log / snapshot 分层。
3. 长期知识放在 `docs/`，通过 `AGENTS.md` 固定读取顺序。
4. LabVIEW 专项规则独立放在 `docs/labview/`。
5. 开发由 `spec/` 驱动，Spec 未通过不实现。

## 后果

- 优点：新项目迁移成本低，AI 上下文恢复路径固定。
- 代价：每类语言需要维护 profile 文档。
- 后续：profile 内容随实际项目持续沉淀。
