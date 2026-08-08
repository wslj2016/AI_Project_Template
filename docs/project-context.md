# Project Information

> 本文件是项目长期上下文模板，由 AI 与人工长期共同维护。只填写稳定事实，不记录一次性任务状态；任务状态见 `.ai/status.md` 与 `.ai/handoff.md`。

| 字段 | 内容 |
| ---- | ---- |
| 项目名称 | `<项目名称>` |
| 项目类型 | `<C/C++ 嵌入式 | C# 工具 | LabVIEW ATE | Python 自动化>` |
| 版本 | `<版本号，与 config/project.yaml 保持一致>` |

# Project Goal

- <项目最终目标>
- <成功标准或衡量指标>

# Background

- <为什么启动该项目>
- <要解决的业务或技术问题>
- <历史背景、前序系统或相关项目>

# Scope

## 包含什么

- <功能范围 1>
- <功能范围 2>
- <接口或集成范围>

## 不包含什么

- <明确排除的范围 1>
- <明确排除的范围 2>
- <后续阶段再纳入的范围>

# Technology Stack

- 语言：`<C / C++ / C# / LabVIEW / Python>`
- 框架：`<CMake / .NET / TestStand / pytest 等>`
- 工具链：`<编译器、SDK、LabVIEW 版本、包管理器及版本锁定方式>`
- 运行平台：`<操作系统、目标板、仪器、运行环境>`

# Domain Knowledge

- 行业知识：`<ATE、嵌入式、自动测试、仪器控制等行业背景>`
- 专业术语：`<术语统一登记在 docs/glossary.md，新增术语先补充登记>`

# System Overview

- <系统总体说明，用 1-2 段描述系统组成与工作方式>
- 模块级细节见 `docs/architecture.md`，本文档只描述长期稳定的总体认知。

# Architecture Principle

- <原则 1：如分层设计、依赖单向>
- <原则 2：如硬件抽象、可模拟测试>
- <原则 3：如单一数据源、接口稳定>
- <原则 4：如按 Spec 驱动开发>

# Important Constraints

- 硬件/仪器限制：`<型号、通道数、时序、量程等>`
- 性能限制：`<实时性、吞吐量、内存上限等>`
- 兼容性限制：`<OS 版本、运行时版本、驱动版本等>`
- 安全与合规限制：`<数据合规、权限、保密要求等>`

# External Dependencies

| 依赖 | 用途 | 版本或约束 |
| ---- | ---- | ---- |
| `<SDK / 库 / 仪器驱动>` | `<用途>` | `<版本或约束>` |

- 元数据与工具链版本以 `config/project.yaml` 为唯一来源。
- 包管理锁文件：`<pyproject.lock / CMakePresets.json / packages.lock.json 等>`。

# Future Direction

- <未来规划 1>
- <未来规划 2>
- <预留的扩展方向或重构计划>
