# Profile: C# 工具

## 适用场景

上位机工具、协议分析、数据处理、CLI 工具。

## 目录映射

- `src/<ToolName>/`：主程序
- `src/<ToolName>.Core/`：核心库
- `tests/<ToolName>.Tests/`：单元测试

## 构建与测试

- 工具链：.NET SDK
- 构建：`dotnet build`
- 测试：`dotnet test`

## 专项约定

- 使用依赖注入组织依赖，保持可测试。
- 与硬件通信的组件定义接口，便于模拟。
