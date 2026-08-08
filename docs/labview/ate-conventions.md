# LabVIEW ATE 约定

## 命名

- VI 使用 PascalCase，动词开头，如 `Test_Voltage_Accuracy.vi`。
- 库/类使用项目前缀，如 `ATE_Instrument.lvlib`。
- 常量与全局变量集中到 Config 库。

## 错误处理

- 顶层 VI 必须有 error in/error out 簇。
- 不吞错误；可选步骤失败需记录到报告。

## UI 约定

- 前面板保持单窗口主界面，禁止弹窗泛滥。
- 测试状态使用固定色标：运行/通过/失败/跳过。

## 文件组织

- 一个功能一个 lvlib，禁止散落 VI。
- 私有 VI 放在 lvlib 私有区，公共 VI 放公开区。
