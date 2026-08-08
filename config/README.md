# config

存放项目元数据、工具链、环境与参数模板：

- `project.yaml`：项目元数据唯一来源，供 scripts 与 CI 读取。
- `toolchain/`：各语言工具链说明与版本锁定。
- `env/`：环境变量模板，不上传敏感值。

具体文件按语言 profile 创建。
