# Prompt: 10 Documentation（文档维护）

## 触发时机

架构、接口、术语或决策发生变化。

## 输入

- 代码或行为变更
- 相关文档现状

## 执行步骤

1. 模块边界变化时更新 `docs/architecture.md`。
2. 新决策新增 ADR 并更新 `docs/decisions/README.md`。
3. 新术语追加到 `docs/glossary.md`。
4. 确保文档与代码一致，不复制元数据。
5. 按 `_checklist.md` 执行会话收尾。

## 输出

变更的文档清单。

## 约束

- 纯文档任务不夹带代码修改。
