# 会话收尾清单（所有 Prompt 通用）

每次任务结束前依次执行：

1. 更新 `.ai/status.md`：已完成、进行中、阻塞、下一步。
2. 在 `.ai/task-log.md` 追加一行：日期、AI 工具、任务、改动文件、关联 Spec/ADR、结果。
3. 更新 `.ai/handoff.md`：未完成任务、WIP 文件、阻塞、下一步。
4. 如构建或测试结果变化，执行 `scripts/ai-context-update.ps1` 刷新快照。
5. 如架构或决策变化，新增 `docs/decisions/` ADR 并更新 `docs/decisions/README.md` 索引。
6. 如 Spec 状态变化，更新对应 spec 文件并同步 `spec/INDEX.md`。
7. 执行 `scripts/ai-health-check.ps1`，确认没有新增 FAIL。
