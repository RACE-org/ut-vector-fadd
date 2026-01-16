# prj_Reporter Guide

本项目使用 UVM 风格的单例 Reporter 作为统一日志与统计机制，核心目标是：**每个 pytest 用例一份独立日志**，并且日志带仿真时钟时间戳，方便定位波形与事务。

## 1. 机制总览

- 单例：全局只有一个 `Reporter` 实例；多次 `get_reporter()` 只会返回同一个对象。
- 仿真时间戳：输出的 `Cycle/Time` 来自 `dut.xclock.clk`（因此 Reporter 需要绑定 DUT）。
- 分级过滤：当 `level > verbosity` 时消息被过滤；`ERROR/FATAL` 为负值，不会被过滤。
- 双通道输出：始终输出到 stdout；如果创建时传入 `log_file_path`，同时写入日志文件（写文件时会去掉 ANSI 颜色码）。

实现入口：
- Reporter 实现：[prj_reporter.py](file:///home/icvm/verify/ut-vector-fadd/env/common/prj_reporter.py)

## 2. pytest 集成方式（实际运行时你需要知道的）

Reporter 的创建与绑定在 fixture 中完成： [conftest.py](file:///home/icvm/verify/ut-vector-fadd/tests/conftest.py)

每个 pytest 用例执行 `vfadd_setup` 时会：

- 生成/确定 `SEED`（来自参数化/`--seed`/环境变量）
- 创建 DUT 并启动时钟
- `Reporter.reset_instance()`，保证每个用例使用全新的 Reporter（避免日志文件复用）
- 生成日志路径：`./report_log/<test_name>_<seed>.log`
- `get_reporter(log_file_path=..., dut=dut)`，绑定 DUT 并开启落盘
- 从 `REPORT_LEVEL` 读取 verbosity 并 `report_pre(test_name, seed)` 打印用例头

因此：**业务代码不要再负责创建 Reporter**，只需要 `get_reporter()` 取实例即可。

## 3. 运行与环境变量

常用环境变量：

- `SEED`：随机种子（每个用例会被写回到环境变量中，便于日志记录）
- `REPORT_LEVEL`：日志等级阈值，默认 `LOW`

示例：

```bash
SEED=1 REPORT_LEVEL=LOW python3 -m pytest -s -k test_sanity tests/
```

日志输出位置：

- `./report_log/<pytest_node_name>_<seed>.log`

## 4. 日志等级（ReportLevel）

当前枚举值（按实现）：

- `FATAL = -2`
- `ERROR = -1`
- `NONE  = 0`
- `LOW   = 100`
- `MEDIUM= 200`
- `HIGH  = 300`
- `FULL  = 400`
- `DEBUG = 500`

过滤规则：`level > verbosity` 会被过滤，所以想看 `DEBUG` 需要把 `REPORT_LEVEL=DEBUG`。

## 5. 常用 API（推荐用法）

推荐导入：

- `from env.common.prj_reporter import get_reporter, ReportLevel`

常用调用：

- `report_msg(caller, message, level=ReportLevel.MEDIUM)`：常规日志
- `report_warning(caller, message)`：警告（计数 +1，按 HIGH 输出）
- `report_error(caller, message)`：错误（计数 +1，永不被过滤）
- `print_summary()`：打印 message/warning/error 统计
- `has_errors()`：判断是否发生错误

caller 命名建议：

- 用组件/模块名做 caller：`vfadd_rm`、`vfadd_master_agent`、`vfadd_xaction.reconstruct` 等

## 6. 常见坑与建议

### 6.1 纯 Python 脚本里直接用 Reporter

Reporter 默认会输出仿真时间戳；如果没有绑定 `dut`，会在访问 `dut.xclock` 时失败。

建议：

- 在 pytest/仿真环境里使用（fixture 会传 `dut`），或
- 在脚本里显式创建时关闭时间戳（仅用于脱离仿真环境的脚本场景）

### 6.2 为什么 ERROR/FATAL 不受 REPORT_LEVEL 影响？

因为它们是负值等级，过滤条件是 `level > verbosity`，负值不会大于任何 verbosity。

### 6.3 回归输出太多怎么办？

用 `REPORT_LEVEL=HIGH` 或 `REPORT_LEVEL=MEDIUM` 降低输出量；错误仍会完整输出。

