# 会话收尾清单（所有 Prompt 通用）

每次任务结束前依次执行：

1. 更新 `.ai/status.md`：已完成、进行中、阻塞、下一步。
2. 在 `.ai/task-log.md` 追加一行：日期、AI 工具、任务、改动文件、关联 Spec/ADR、结果，并引用 Task Instance ID。
3. 更新当前 Task Instance Record（位于 `.ai/tasks/`，文件名按 TASK-003 的 TSK ID）：状态、Transition Log、Evidence 与真实结果一致。
4. 更新 `.ai/handoff.md`：未完成任务、WIP 文件、阻塞、下一步。
5. 如构建或测试结果变化，执行 `scripts/ai-context-update.ps1` 刷新快照。
6. 如架构或决策变化，新增 `docs/decisions/` ADR 并更新 `docs/decisions/README.md` 索引。
7. 如 Spec 状态变化，更新对应 spec 文件并同步 `spec/INDEX.md`。
8. 执行 `scripts/ai-health-check.ps1`，确认没有新增 FAIL。
9. 执行 `scripts/governance-check.ps1`，确认 GOV-001 ~ GOV-006 PASS。
