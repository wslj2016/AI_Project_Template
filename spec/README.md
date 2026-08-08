# Spec 驱动开发

## 生命周期

需求 → Spec 评审 → 任务拆分 → 实现 → 验证 → 归档

## Spec 文件要求

- 位于 `spec/`，编号递增：`0001-<name>.md`。
- 必须包含：背景、需求、验收标准、范围。
- 状态变更：Draft → Review → Approved → Implemented → Archived。

## 规则

- Spec 未 Approved 前不开始实现。
- 验收标准必须可验证。
- 实现完成后回到 Spec 标记状态并记录结果。
