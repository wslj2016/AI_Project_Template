# Profile: Python 自动化

## 适用场景

脚本工具、数据自动化、测试夹具、配置生成。

## 目录映射

- `src/<pkg>/`：主包
- `tests/`：pytest 测试

## 构建与测试

- 工具链：uv + Python 3.x
- 依赖：`pyproject.toml`
- 测试：`pytest`

## 专项约定

- 类型标注加简短 docstring。
- 配置优先使用 dataclass/pydantic 模型，不裸读字典。
- 日志统一使用 logging。
