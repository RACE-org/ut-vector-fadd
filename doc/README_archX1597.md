# archX1597 版本说明

本文件用于说明本 fork（archX1597）在原仓库基础上的新增内容与推荐使用方式，便于复现与审阅。

## 与上游的关系

- 上游仓库：`RACE-org/ut-vector-fadd`
- 本仓库：在上游提供的基础验证环境之上，补充了可直接运行的验证环境实现、随机化/约束回归能力，以及更完整的文档与用例集合。

## 快速开始

安装依赖：

```bash
pip install -r requirements.txt
```

生成 DUT（如果需要重新生成）：

```bash
make dut
```

> 用途说明：根目录下的 `Makefile` 用于 DUT 生成与清理。其中 `make dut` 会调用 `picker` 根据 `rtl/LaneFAdd.sv` 生成 Python DUT（LaneFAdd 目录），并可在仿真中产生 VCD。

运行全部用例并生成 HTML 报告：

```bash
pytest -sv --toffee-report
```

运行单个用例（推荐同时设置 seed 与日志等级）：

```bash
SEED=1 REPORT_LEVEL=LOW python3 -m pytest -s -k test_sanity tests/
```

多 seed 回归（自动为每个用例展开多次运行）：

```bash
python3 -m pytest -s --regress --count 5 tests/
```

按 tl 列表回归（`tl/<xxx>.tl.lst` 中可指定次数与可选 wave 标记）：

```bash
python3 -m pytest -s --tl tl/<xxx>.tl.lst tests/
```

输出说明：

- 每用例日志：`./report_log/<test_name>_<seed>.log`
- HTML 报告：`./reports/report-*/report-*.html`

## 目录结构补充

相较上游，本 fork 主要增加了以下目录/能力：

- `env/`：验证环境实现（agent/rm/transaction/common 组件等）。
- `report_log/`：运行后生成的每用例独立日志输出目录（文件名包含 test_name 与 seed）。
- `reports/`：运行后生成的 pytest HTML 报告输出目录（`--toffee-report` 生成）。
- `tl/`：回归列表（支持指定次数与可选 wave 标记）。
- `sim/`：单用例运行与 Verdi 打开波形的便捷入口（Makefile/rcfile 等）。

## 文档入口

- 任务规格： [verification_spec.md](./verification_spec.md)
- 验证点/用例与覆盖反标： [verification_points.md](./verification_points.md)
- 验证环境指南（含 transaction 重点说明）： [vfadd_env_guide.md](./vfadd_env_guide.md)
- Reporter 机制说明： [reporter_guide.md](./reporter_guide.md)
- 总验证报告： [verification_report.md](./verification_report.md)
- 缺陷清单： [bug_list.pdf](./bug_list.pdf)

## RTL 说明与 Verdi 使用

- RTL 目录包含两个版本：
  - `LaneFAdd.sv`：最新版本，供 `picker` 导出 Python DUT 与后续仿真使用。
  - `LaneFAdd.v`：兼容版本。
- `TOP.v`：用于封装顶层接口，便于 Verdi 正确识别信号层次与波形浏览。
- 打开 Verdi 的推荐流程：
  1. 在 `sim/` 目录运行用例并启用波形转换（默认 `wave=on`，需要系统安装 `vcd2fsdb(Verdi自带工具)`）：
     ```bash
     cd sim
     make run tc=test_sanity seed=1
     ```
  2. 通过 `make verdi` 打开生成的 FSDB 波形（`sim/Makefile` 会使用默认的 `rcfile/novas.rc` 等配置）：
     ```bash
     make verdi tc=test_sanity seed=1
     ```
  3. 如果需要调整 Verdi 加载的 RTL 文件列表，请修改 `sim/rtl.lst`。
