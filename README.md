# AI_Project_Template

通用 AI 辅助软件开发项目模板，适用于 C/C++ 嵌入式、C# 工具、LabVIEW ATE、Python 自动化四类项目。

## 使用方式

1. 复制本模板到新项目目录。
2. 在 `config/project.yaml` 填写项目名称、语言 profile、版本、工具链与硬件。
3. 运行 `scripts/build.ps1 -Target All` 生成构建/测试报告。
4. 运行 `scripts/ai-context-update.ps1` 刷新上下文快照。
5. 按 `spec/README.md` 建立第一条 Spec。
6. 让 AI 从 `AGENTS.md` 开始恢复上下文，并用 `scripts/ai-health-check.ps1` 验收。

## 文档索引

- AI 入口：`AGENTS.md`
- 质量规则：`AI_REVIEW_RULES.md`
- 质量门：`AI_QUALITY_GATE.md`
- 架构：`docs/architecture.md`
- 决策记录：`docs/decisions/`
- LabVIEW ATE 规则：`docs/labview/`
- Spec：`spec/`
- AI Prompt 模板：`.ai/prompts/`

## 目录结构

```text
AGENTS.md / README.md / .gitignore / .editorconfig
.github/workflows/       CI 模板
.ai/                     AI 工作记忆区与语言 profile
docs/                    长期知识库
spec/                    Spec 驱动开发
src/ tests/ scripts/     代码、测试、构建脚本
config/ tools/ third_party/ build/
```
