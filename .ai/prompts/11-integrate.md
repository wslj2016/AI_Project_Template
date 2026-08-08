# Prompt: 11 Integrate（提交与集成）

## 触发时机

提交、PR、CI 或发布集成。

## 输入

- 待集成变更
- 最近构建/测试报告

## 执行步骤

1. 运行 `scripts/ai-health-check.ps1`。
2. 运行构建与测试，确认报告为 passed。
3. 检查 diff 范围与提交信息规范。
4. 创建 PR 或提交，并记录 CI 结果。
5. 按 `_checklist.md` 执行会话收尾。

## 输出

提交/PR 摘要与 CI 状态。

## 约束

- CI 失败不允许合并。
- 禁止提交密钥与敏感配置。
