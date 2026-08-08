# ADR-0002: 模板发布前的质量加固

- 状态：已接受
- 日期：2026-08-08

## 背景

模板存在引用断裂与文档过期问题：Prompt 生命周期不完整、ADR-0002 被引用但不存在、README 仍指向旧元数据路径、CI 无法解析 profile。

## 决策

1. 引入 `AI_REVIEW_RULES.md` 与 `AI_QUALITY_GATE.md` 作为质量门。
2. 补齐生命周期 Prompt：08-debug、09-spec、10-documentation、11-integrate，并新增共享收尾清单 `_checklist.md`。
3. 建立 `spec/INDEX.md` 与 `docs/decisions/README.md`，使引用可校验。
4. CI 从 `config/project.yaml` 自动解析 `language_profile`，不再手工配置空 PROFILE。
5. README、config README、status 与元数据单一来源保持一致。

## 后果

- 优点：新 Chat 可恢复完整生命周期上下文，引用断裂可被健康检查发现。
- 代价：发布模板需要维护质量门文档。
- 后续：profile 深化、健康检查引用校验等 P2 建议另行排期。
