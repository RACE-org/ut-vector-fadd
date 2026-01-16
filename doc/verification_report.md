# 向量浮点混合加法模块（LaneFAdd）验证报告

作者：archX1597

## 验证对象

**DUT**：LaneFAdd（向量 Lane 内的浮点加法复用单元）**数据通路宽度**：64-bit（支持 2×FP32 或 4×FP16/BF16 元素并行）**支持数据类型**：FP32 / FP16 / BF16（不支持 FP64）**支持指令集合（基于复用加法器实现）**

- 基础算术：`vfadd / vfsub / vfrsub`
- widen 算术：`vfwadd / vfwsub / vfwadd.w / vfwsub.w`
- min/max：`vfmin / vfmax`
- 符号注入：`vfsgnj / vfsgnjn / vfsgnjx`
- 比较：`vmfeq / vmfne / vmflt / vmfle / vmfgt / vmfge`
- move：`vfmv / vfmv.f.s / vfmv.s.f`

接口定义与约束详见：[verification_spec.md](verification_spec.md)

## 验证方案与验证框架

### 方法学
基于CDV方法学验证，利用PyVSC库做随机化约束，在约束的层次上，IEEE754协议Corner细节非常多，因此验证环境采用高层次的约束来设计整个Transaction

- 用高层抽象描述验证意图（如指数关系/尾数差异/符号关系），再反向推导底层比特流，提升对关键内部路径的命中概率。
- 协议层与数学层解耦：
  - 协议层 transaction：`vfadd_xaction`
    - [vfadd_xaction.py](../env/vfadd_xaction.py)
  - 数学层 transaction：`FpElement / FpPair`
    - [fp_xaction.py](../env/fp_xaction.py)
- 覆盖闭环：通过功能覆盖模型反向验证 corner 命中情况，并通过收紧约束补齐盲区。

验证环境设计理念详见：[vfadd_env_guide.md](vfadd_env_guide.md)

### 验证框架（Toffee + UVM-like 分层）

整体结构为“TestCase / Env / Agent / Reference Model + Coverage”，数据流为：

- BaseTestCase 负责 reset、启动 env、运行序列、drain、停止 env
  - [base_test.py](../tests/base_test.py)
- `vfadd_env` 挂载：
  - `vfadd_master_agent`：驱动输入 + 采集输入事务
  - `vfadd_slave_agent`：采集输出（vd/rd）
  - `vfadd_rm`：参考模型比对、统计、采样功能覆盖
  - [vfadd_env.py](../env/vfadd_env.py)

环境使用指南（含 transaction 详细说明）：

- [vfadd_env_guide.md](vfadd_env_guide.md)

日志机制（每用例独立日志、仿真时钟时间戳、分级过滤）：

- [reporter_guide.md](reporter_guide.md)

### Common 组件：prj_Reporter

为便于回归定位与复现，本项目新增/集成了一个 UVM 风格的单例 Reporter 作为通用组件（`env/common`），用于统一日志输出与统计：

- 特性：
  - 绑定 DUT 时钟，日志带 `Cycle/Time` 时间戳
  - 分级过滤（`REPORT_LEVEL` 控制输出量），`ERROR/FATAL` 不会被过滤
  - 每个 pytest 用例自动生成独立日志文件：`./report_log/<test_name>_<seed>.log`
- 代码位置：[prj_reporter.py](../env/common/prj_reporter.py)
- 使用指南：[reporter_guide.md](reporter_guide.md)

## 功能点和测试点

功能点与测试点定义以任务文档为准（表 2-1）：
[verification_spec.md](verification_spec.md)

本项目按 6 大类功能点组织测试点：

- 1. 基础算术功能：1.1 vfadd、1.2 vfsub、1.3 vfrsub
- 2. widen 算术功能：2.1 vfwadd、2.2 vfwsub、2.3 vfwadd.wv/wf、2.4 vfwsub.wv/wf
- 3. 比较功能：3.1~3.6 六条 compare 指令
- 4. min/max 功能：4.1 vfmin、4.2 vfmax
- 5. 符号注入功能：5.1~5.3 三条 sgnj 指令
- 6. move 功能：6 vfmv（含 vfmv.f.s、vfmv.s.f）

测试点到测试用例与覆盖点的反标详见：
[verification_points.md](verification_points.md)

## 测试环境

### 软件环境

- Python：项目基于 `pyproject.toml` / `requirements.txt` 管理依赖
- 框架：Toffee + pytest
- 报告：pytest-html（Toffee Test Report），输出到 `reports/`

### 依赖安装

```bash
pip install -r requirements.txt
```

### 运行入口（pytest）

单用例：

```bash
SEED=<seed> REPORT_LEVEL=LOW python3 -m pytest -s -k <test_name> tests/
```

多 seed 回归（默认重复次数由参数控制）：

```bash
python3 -m pytest -s --regress tests/
```

按 tl 列表回归：

```bash
python3 -m pytest -s --tl tl/<xxx>.tl.lst tests/
```

### 运行产物

- pytest 报告：`../reports/report-*/report-*.html`
- 每用例日志：`../report_log/<test_name>_<seed>.log`
- 功能覆盖：由参考模型采样并在日志/终端输出摘要；覆盖点定义见 `VFAddCovWrap`

## 测试用例

测试用例入口均为 `tests/test_*.py` 的 `@toffee_test.testcase`：

- 基础算术：`test_basic_arith`、`test_normal_basic_arith`、`test_sanity`
- widen：`test_widen_random`、`test_normal_widen`、`test_directed`
- 比较：`test_cmp`
- min/max：`test_min_max`
- sgnj：`test_sign`
- move：`test_vfmv_v_f`、`test_vfmv_f_s`、`test_vfmv_s_f`
- 随机/压力：`test_all_random`、`test_eq_random`

用例设计说明、覆盖点反标与运行命令详见：
[verification_points.md](verification_points.md)

## 结果分析

### 回归概况

- pytest HTML 报告：
  - `../reports/report-20260114121905/report-20260114121905.html`
- 已完成用例回归：共 14 个用例

### 用例统计

- 通过（PASS）：7
- 失败（FAIL）：7

### 覆盖率汇总

- 功能覆盖：覆盖点已全部命中
- 行覆盖率：100%

覆盖模型与采样点定义见：

- `../tests/vfadd_cov_wrap.py`
- `../tests/funcov_global.py`

## 缺陷分析

缺陷仅列清单（部分问题已fix）：

- BUG-001：widen2 指令下，没有把操作数正确分配到对应加法器上
- BUG-002：widen2 指令下，NaN 判断没有正确传递
- BUG-003：比较指令下，func6 控制信号和数据信号没有对齐导致错误
- BUG-004：vfmv.f.s 指令下，io_out_rd_valid 与 io_out_valid 不同时拉高
- BUG-005：多指令序列后的保序与流水问题
- BUG-006：widen 情况下，NaN 判断逻辑有误（对 BUG-002 的增补）
- BUG-007：widen2 情况下，FP16→FP32 转换后移位标准错误导致精度损失
- BUG-008：VFMIN/MAX 指令在操作数来自 rs 情况下，选择输出错误

相关材料：`bug_list.pdf`

## 测试结论

- 已基于任务仓库提供的验证环境完成 LaneFAdd 的测试用例组织、环境文档与报告材料整理。
- 环境支持意图驱动的受限随机、directed 用例复现、功能覆盖采样与回归输出（日志 + HTML 报告）。
- 后续建议：浮点验证是一个比较难的问题，个人PC上难实现大规模大量的回归测试，希望能够基于本环境在服务器环境下进行大量的回归测试
