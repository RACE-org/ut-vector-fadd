# ut-vector-fadd

本仓库为 **向量浮点混合加法模块(LaneFAdd)** 的验证仓库。
## 任务详情/要求

请查阅仓库中的 [verification_spec.md](./doc/verification_spec.md)。

## 环境介绍

目前本仓库提供了一个基础的环境，包含以下内容：

```bash
.
├── bundles
├── doc
├── LaneFAdd
├── Makefile
├── pyproject.toml
├── README.md
├── requirements.txt
├── rtl
└── tests
```

- `bundles`：对端口引脚的封装。
- `doc`：存放各种文档，包含本次验证的任务详情。
- `LaneFAdd`：用 [picker](https://github.com/XS-MLVP/picker) 工具生成的 Python DUT，通过 `make dut` 命令产生。
- `Makefile`：包含DUT的构建和清理命令。
- `pyproject.toml`：项目的基本信息，包含依赖的包。
- `requirements.txt`：项目依赖的包。
- `rtl`：存放 RTL 设计，目前仓库只包含 `LaneFAdd.v`。
- `tests`：存放测试用例。

参与者可以根据自己的实际需求，对验证环境的结构进行改动。

> [!TIP]
> 参与者也可以通过 AI 驱动的 [UCAgent](https://github.com/XS-MLVP/UCAgent) 自动构建验证环境并生成测试用例，随后在此基础之上进行深入的开发和完善。

### 环境配置

参与者可以通过 `pip instsall -r requirements.txt` 安装依赖，对依赖有需要的话可自行维护。

> [!TIP]
> 如果熟悉 [uv](https://uv.oaix.tech/) 的话，更推荐用uv对项目的环境进行管理。

运行demo：执行 `pytest . -sv --toffee-report` 便会运行用例，运行报告会存放在 `reports` 文件夹中。

## 如何参与

参与本次验证任务需要完成以下步骤：

1. **填写[报名问卷](https://www.wjx.top/vm/wFU6suy.aspx#)**
2. **加入 LaneFAdd 验证交流群(qq: 1028824516)**
3. **完成验证工作**：基于 [ut-vector-fadd](https://github.com/RACE-org/ut-vector-fadd) 仓库提供的验证环境开展验证
4. **提交PR**：将验证结果通过Pull Request方式提交至该仓库

### 成果提交

请按以下流程提交您的验证成果：

1. **Fork仓库**：首先fork仓库 [ut-vector-fadd](https://github.com/RACE-org/ut-vector-fadd)
2. **完成开发**：在fork的仓库中完成验证代码的实现和验证报告的编写
3. **提交PR**：成果准备就绪后，请向原仓库发起Pull Request，提交您的验证成果

### Bug 报告

请直接在仓库中的issue反馈 bug。提交bug时，请在label中选择bug标签。

## 成果需求

任务需要提交以下成果：

1. 验证环境+API：验证环境和API是代码成果，是针对待验证对象（DUT）的数据职责（引脚）和行为职责（逻辑）的封装，需要提供特定的可复用的接口、测试套件、测试覆盖率等的定义。其中，搭建验证环境可以参考<a href="https://open-verify.cc/UnityChipForXiangShan/docs/03_add_test/02_build_env/" target="_blank">验证环境搭建教程</a>，测试覆盖率相关的文档可以参考这两篇：<a href="https://open-verify.cc/UnityChipForXiangShan/docs/03_add_test/04_cover_line/" target="_blank">行覆盖率</a>、<a href="https://open-verify.cc/UnityChipForXiangShan/docs/03_add_test/05_cover_func/" target="_blank">功能覆盖率</a>。
2. 测试用例：测试用例是代码成果，定义了用于测试的输入组合，以及预期的输出组合。构建测试用例可以参考<a href="https://open-verify.cc/UnityChipForXiangShan/docs/03_add_test/03_add_test/" target="_blank">测试用例添加教程</a>。
3. 验证报告：验证报告是文字成果，包括对环境、测试点和测试用例的介绍，复现代码所需的环境和指令，以及对测试覆盖率等衡量指标的报告。
    - 验证报告的书写可以参考这篇教程：<a href="https://open-verify.cc/mlvp/docs/basic/report/" target="_blank">验证报告教程</a>
4. 其他说明：如果运行您的项目需要其他的依赖，可在测试报告或PR中说明
