# Profile: LabVIEW ATE

## 适用场景

测试系统、仪器控制、DUT 测试序列、数据采集与报表。

## 目录映射

- `src/<Lib>.lvlib/`：共享库
- `src/<App>.lvproj/`：工程
- `src/Steps/`：测试步骤 VI
- `src/Drivers/`：仪器驱动封装
- `tests/`：测试序列 VI 与自检 VI

## 构建与测试

- LabVIEW 工程通过 VI Scripting 或构建规范构建。
- 专项规则见 `docs/labview/`。

## 专项约定

- 所有 VI 必须携带 error in/out 簇。
- 仪器访问统一走硬件抽象层。
- 禁止在 UI VI 中直接调用仪器驱动。
