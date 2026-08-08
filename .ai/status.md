# 状态

- 项目：AI_Project_Template（元数据以 `config/project.yaml` 为准）
- 语言 profile：待定，见 `config/project.yaml`
- 版本：见 `config/project.yaml`

## 当前里程碑

模板已达到可发布版本基线，并已固化 Git 首次提交。

## 已完成

- 模板骨架与生命周期 Prompt。
- Git 仓库初始化与模板首次提交。
- 元数据单一来源 `config/project.yaml`。
- 构建/测试报告与上下文快照联动。
- handoff 与会话健康检查。
- Spec/ADR 索引与 CI profile 解析。
- 发布质量门：`AI_REVIEW_RULES.md`、`AI_QUALITY_GATE.md`。
- 生命周期 Prompt 01-11 与共享收尾清单 `_checklist.md`。

## 进行中

无

## 阻塞项

无

## 下一步

1. 为新项目设置 `config/project.yaml` 的 `language_profile`。
2. 创建第一条 Spec。
3. 执行 `scripts/ai-health-check.ps1` 验收知识库完整性。
