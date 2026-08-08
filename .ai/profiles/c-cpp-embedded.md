# Profile: C/C++ 嵌入式

## 适用场景

MCU/RTOS 固件、驱动、通信协议、HIL 相关组件。

## 目录映射

- `src/modules/<module>/`：功能模块独立目录
- `src/platform/`：芯片/板级平台层
- `src/drivers/`：外设驱动
- `tests/unit/`：单元测试
- `tests/hil/`：硬件在环测试

## 构建与测试

- 工具链：CMake + 交叉编译器（按芯片填写）
- 构建：`scripts/build.ps1 -Target Build`
- 测试：主机侧单元测试优先，HIL 单独标记

## 专项约定

- 驱动与业务分层，业务代码禁止直接操作寄存器。
- 错误码统一使用 enum 并配说明文档。
- 全局状态必须在 `docs/architecture.md` 中登记。
