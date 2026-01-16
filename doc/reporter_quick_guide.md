# prj_Reporter 使用指南（按当前实现）

本仓库的 Reporter 是一个 UVM 风格的单例日志/统计器，和 DUT 的仿真时钟绑定，输出统一的“Cycle/Time + 等级 + caller + 文本”格式，并在每个 pytest 用例内生成独立日志文件。

## 1. 设计要点（你当前的机制）

- 单例：全局只存在一个 `Reporter` 实例；重复调用 `get_reporter()` 只是拿同一个对象。
- 与 DUT 绑定：时间戳来自 `dut.xclock.clk`，输出形如 `Cycle: <clk> Time:<2*clk+1>`。
- 分级过滤：满足 `level <= verbosity` 才输出；`ERROR/FATAL` 等级是负值，永远不会被过滤。
- 双通道输出：始终打印到 stdout；如果创建时传入 `log_file_path`，同时写入该文件（自动去掉 ANSI 颜色码）。
- pytest 集成：每个测试用例都会 `Reporter.reset_instance()` 并重新创建带 `log_file_path` 的实例，保证“每用例一份日志”。

## 2. 在 pytest 测试里怎么工作（实际集成方式）

在 [conftest.py](file:///home/icvm/verify/ut-vector-fadd/tests/conftest.py) 的 `vfadd_setup` fixture 中，Reporter 的流程是：

- 解析 seed（来自参数化 / `--seed` / `SEED` 环境变量）
- 创建 DUT + 启动时钟
- `Reporter.reset_instance()`：避免跨 test 复用旧日志文件
- 生成日志路径：`./report_log/<pytest_node_name>_<seed>.log`
- `get_reporter(log_file_path=..., dut=dut)`：绑定 DUT + 让日志落盘
- 从环境变量 `REPORT_LEVEL` 读取日志等级（默认 `LOW`），并 `report_pre(test_name, seed)` 打印用例头信息

因此你在跑测试时，通常只需要关心两件事：

- `SEED=<seed>`：控制随机种子
- `REPORT_LEVEL=<level>`：控制输出量

## 3. 报告等级（ReportLevel）

当前 `ReportLevel`（见 [prj_reporter.py](file:///home/icvm/verify/ut-vector-fadd/env/common/prj_reporter.py)）是：

- `FATAL = -2`
- `ERROR = -1`
- `NONE  = 0`
- `LOW   = 100`
- `MEDIUM= 200`
- `HIGH  = 300`
- `FULL  = 400`
- `DEBUG = 500`

过滤规则：`level > verbosity` 会被过滤；因此 `DEBUG` 是最“吵”的级别，只有把 `verbosity` 设到 `DEBUG` 才会显示。

## 4. 常用 API（按当前实现）

### 4.1 获取实例

- 推荐：`from env.common.prj_reporter import get_reporter`
- fixture 内已经创建过实例时，业务代码直接 `get_reporter()` 取即可。

### 4.2 打印消息

- `report_msg(caller, message, level=ReportLevel.MEDIUM)`：常规日志
- `report_warning(caller, message)`：警告（内部会 +1 warning 计数，并以 HIGH 等级输出）
- `report_error(caller, message)`：错误（内部会 +1 error 计数）
- `report_fatal(caller, message, exit_code=1)`：同步 fatal，直接 `sys.exit`
- `report_fatal_async(...)`：异步 fatal，会先取消 asyncio tasks，再进入 report phase callback（如果设置过）

### 4.3 统计/摘要

- `print_summary()`：打印当前统计（message/warning/error）
- `has_errors()` / `get_error_count()` / `get_warning_count()`
- `clear_counters()`：清零计数

### 4.4 用例头信息

- `report_pre(case_name, seed)`：打印 TEST CASE START 块（fixture 已调用）
- `report_post()`：当前是 placeholder（不输出）

## 5. 推荐用法（在本项目里的写法）

### 5.1 在组件里保存引用

- 在类 `__init__` 里：`self.prj_reporter = get_reporter()`
- 日志 caller 统一用组件名，例如：`vfadd_rm` / `vfadd_master_agent` / `vfadd_xaction.reconstruct`

### 5.2 不要在业务代码里重建 Reporter

- 业务代码不要再 `Reporter.get_instance(...)` 传 `log_file_path`，避免抢占/覆盖 fixture 已经打开的日志文件。
- 需要“每用例一份日志”由 fixture 负责。

## 6. 运行与查看日志

### 6.1 pytest 单用例

```bash
SEED=1 REPORT_LEVEL=LOW python3 -m pytest -s -k test_sanity tests/
```

日志文件输出到：

- `./report_log/test_sanity_1.log`（文件名会包含 seed；pytest 参数化时 name 可能带 `[seed=...]`）

### 6.2 sim/Makefile 方式

`make -C sim run ...` 会设置 `SEED/REPORT_LEVEL` 并运行 pytest；Reporter 仍按 conftest 的逻辑把日志写到 `./report_log/`。

## 7. 常见问题（按当前实现的坑）

### 7.1 纯 Python 脚本里直接用 Reporter 会报错？

如果没有传入 `dut`，但又开启了 timestamp（默认开启），Reporter 会在取 `dut.xclock.clk` 时出错。

解决思路（任选其一）：

- 在仿真环境中使用（fixture 会传 `dut`）
- 或者用 `Reporter.get_instance(enable_timestamp=False, dut=None)`（需要你在脚本里显式这么创建）

### 7.2 为什么 `ERROR/FATAL` 永远会打印？

因为它们的 level 是负值，过滤条件是 `level > verbosity`，负值不会大于任何 verbosity。

## 8. 关键文件

- Reporter 实现：[prj_reporter.py](file:///home/icvm/verify/ut-vector-fadd/env/common/prj_reporter.py)
- pytest 集成（创建 per-test 日志）：[conftest.py](file:///home/icvm/verify/ut-vector-fadd/tests/conftest.py)
