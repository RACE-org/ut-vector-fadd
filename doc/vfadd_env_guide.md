# vfadd_env_guide

给出 VFAdd 验证环境的“怎么用/怎么扩展/怎么定位问题”的实用指南。

## 1. 设计哲学与核心思路

本验证环境的目标不只是“生成激励”，而是为了解决浮点验证里最难命中的 corner，将随机化也分层解耦

### 1.1 核心理念

- 意图优先（Intent-First）：通过引入高层抽象（指数关系、尾数差异、符号关系等），让验证人员能直接描述验证意图，由环境反向推导出满足条件的底层比特流。
- 分层解耦（Decoupling）：协议层（指令格式、控制信号）与数学层（浮点属性、数值关系）分离；`vfadd_xaction` 负责协议，`fp_xaction` 负责数学。
- 闭环验证（Closed-Loop）：用功能覆盖反向验证 corner 命中情况，并通过收紧约束填充覆盖盲区。

浮点加法验证的难点不在于“随机出两个数”，而在于**定向命中关键内部路径**（指数对齐边界、消去、混合精度 bias 等）。本环境采用“意图优先”的分层抽象：

- 协议层（指令/控制字段/SEW/form）：由 `vfadd_xaction` 负责
  - 文件：[vfadd_xaction.py](../env/vfadd_xaction.py)
- 数学层（浮点数属性与关系）：由 `FpElement/FpPair` 负责
  - 文件：[fp_xaction.py](../env/fp_xaction.py)

你在写用例时应尽量用高层 knob（如 `exp_relation/man_relation/sign_relation/category`）表达意图，再由环境把它反推到底层 bit pattern。

## 2. 关键痛点与对应解决方案（Knobs）

### 2.1 指数对齐边界难命中

- 问题：最容易出错的是指数差为 0/1 的 Close Path，以及移位/Sticky bit 相关边界；纯随机很难命中。
- 解决：引入 `exp_relation`。
  - `exp_relation == CLOSE`：强制指数差 ≤ 1
  - `exp_relation == FAR`：强制指数差 > 1

### 2.2 有效减法消去（Massive Cancellation）

- 问题：符号相反、指数相同、尾数极接近会产生大量前导零，依赖规格化/LZA 相关逻辑，是高危 bug 区域。
- 解决：引入 `man_relation` 与 `sign_relation`，可组合约束：
  - `sign_relation == OPPOSITE` + `exp_relation == EQUAL` + `man_relation == SMALL_DIFF`

### 2.3 混合精度（Widen / Widen2）验证复杂

- 问题：widen 指令涉及不同精度 bias，直接比较 raw exp 会产生误导。
- 解决：`FpElement` 内部引入 bias/真实指数概念，在生成 `exp_relation` 时以“真实指数”进行比较，确保 widen 条件下也能构造 CLOSE/FAR 等场景。

### 2.4 正向测试与错误注入统一

- 问题：既要测合法编码也要测非法编码，通常要两套环境。
- 解决：用 `is_legal` 作为统一开关：
  - `is_legal == 1`：强制高层意图与底层信号一致（正向）
  - `is_legal == 0`：解除/放宽约束（错误注入/鲁棒性）（目前该模块不包含异常处理中断，因此这里约束为1）

### 2.5 典型场景（示例约束）

| 场景名称             | 关键约束（Knobs）                                                                                             | 目的                       |
| -------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------------- |
| Alignment Boundary   | `exp_relation == CLOSE`                                                                                     | 覆盖 Close Path 对齐逻辑   |
| Massive Cancellation | `uop == VFSUB` + `exp_relation == EQUAL` + `man_relation == SMALL_DIFF` + `sign_relation == OPPOSITE` | 覆盖消去/规格化逻辑        |
| Widen Precision      | `uop == VFWADD`（或 widen2 族）                                                                             | 覆盖跨精度路径与 bias 处理 |
| NaN Propagation      | `fp_pairs[i].a.category == NAN`（或 b 为 NAN）                                                              | 覆盖 NaN 传播规则          |
| Illegal Instruction  | `is_legal == 0`                                                                                             | 覆盖 decoder 容错与鲁棒性  |

## 3. 总体架构与数据流

环境模块： [vfadd_env.py](../env/vfadd_env.py)

```text
pytest testcase (async)
  |
  v
BaseTestCase.run()
  |   reset -> instantiate env -> create seq -> run seq -> drain -> stop env
  v
vfadd_env
  +-- vfadd_master_agent  (drive in + monitor in)  ----->  DUT io.in / io.sewIn
  |
  +-- vfadd_slave_agent   (monitor out)            <-----  DUT io.out / io.rd
  |
  +-- vfadd_rm (reference model + checker + coverage)
       - 监听 master monitor 的输入事务
       - 监听 slave monitor 的输出 payload
       - 计算期望并比对，统计 pass/fail
       - sample 功能覆盖
```

关键文件索引：

- 测试基类（组织 reset/env/sequence 生命周期）：[base_test.py](../tests/base_test.py)
- 环境（挂载 agent 与 reference model）：[vfadd_env.py](../env/vfadd_env.py)
- 主 agent（驱动 in、监视 in）：[vfadd_master_agent.py](../env/vfadd_master_agent.py)
- 从 agent（监视 out/rd）：[vfadd_slave_agent.py](../env/vfadd_slave_agent.py)
- 参考模型/scoreboard/coverage： [vfadd_rm.py](../env/vfadd_rm.py)
- 序列基类（生成 tx 并发送给 master agent）：[vfadd_base_seq.py](../env/vfadd_base_seq.py)

## 4. Transaction 分层：从“意图”到“比特流”

### 4.1 vfadd_xaction（协议层）

`vfadd_xaction` 是用例编写的核心载体，包含：

- 高层选择：`uop_type / sew_type / funct3_type / is_legal`
- 数学桥接：`fp_pairs`（用于约束 elaboration）与 `fp_pairs_list`（post_randomize 后的实际对象列表）
- 低层 payload：`payload.vs1/vs2/vs3/rs1` + `payload.uop.*` + `sew.oneHot_*`

关键行为：

- `post_randomize()`：把高层 knobs decode 到低层信号，并把 `fp_pairs` 打包到 `vs1/vs2/rs1`
  - 入口位置：[vfadd_xaction.py](../env/vfadd_xaction.py)
- `decode_to_payload()`：根据 `uop_type/sew_type/funct3_type/is_legal` 设置 `uop.ctrl`/`sewIn` 等
  - 同文件
- `reconstruct()`：从 `payload.vs1/vs2/rs1` 反解 `FpPair` 列表，供 RM/覆盖/报告使用
  - 入口：`vfadd_xaction.reconstruct()`（见 [vfadd_xaction.py](../env/vfadd_xaction.py)）

### 4.2 fp_xaction（数学层）

数学层用于表达“浮点验证意图”：

- `FpElement`：`precision/category/sign/exp/man/...`
- `FpPair`：`exp_relation/man_relation/sign_relation` 等关系变量

典型意图 knob（建议）：

- 对齐边界：`exp_relation == CLOSE`（指数差 0/1）
- 大量消去：`sign_relation == OPPOSITE` + `exp_relation == EQUAL` + `man_relation == SMALL_DIFF`
- 混合精度 widen：通过 `bias` 做真实指数比较（避免 FP16/FP32 直接比 raw exp 造成误导）
- 正向/错误注入统一开关：`is_legal`
  - `is_legal == 1`：高层意图与底层信号一致（正向验证）
  - `is_legal == 0`：解除/放宽约束（错误注入/鲁棒性验证）

### 4.3 vfadd_xaction 关键字段说明（建议重点阅读）

`vfadd_xaction` 是整个环境里最复杂的部分：它既要承载“高层意图”，又要保证最终驱动的低层信号与协议一致。建议把它理解为三层信息：

#### 4.3.1 高层选择（你写用例时主要操作的字段）

- `uop_type`：指令类型（VFADD/VFSUB/…/VFMV_F_S 等），决定 `funct6`、widen 标志、特殊约束等
- `sew_type`：数据精度（FP32/FP16/BF16），最终会映射到 `io.sewIn.oneHot_*`
- `funct3_type`：操作数形式
  - `OPFVV`：vector-vector（每个 element 的 A 来自 `vs1`，B 来自 `vs2`）
  - `OPFVF`：vector-scalar（A 来自 `rs1` 并按 spec broadcast，B 来自 `vs2`）
- `is_legal`：正向/错误注入开关（env_spec 的统一旋钮）
- `valid`：是否对 DUT 拉高 `io.in.valid`（默认软约束为 1）
- `delay`：发完一次事务后插入的空拍数（默认软约束偏向 0~3）

#### 4.3.2 数学桥接（用来“反推比特”的关键）

- `fp_pairs`：`vsc.randsz_list_t(FpPair)`，用于约束 elaboration（在 `randomize_with` 里写约束）
- `fp_pairs_list`：`post_randomize()`/`reconstruct()` 后的 Python list，RM/覆盖/报告用它做分析与打印

关系变量通常挂在 `FpPair` 上（例如 `exp_relation/man_relation/sign_relation`），你在用例里收紧这些关系，就能更稳定地命中 DUT 的关键内部路径（对齐、消去、sticky 等）。

#### 4.3.3 低层 payload（真正被 master agent 驱动到 DUT 的内容）

- `payload.vs1/vs2/vs3/rs1`：64-bit 操作数输入（最终走到 `io.in.bits.*`）
- `payload.uop.*`：所有 uop 字段（其中少数是 DUT 真正用到的控制信号，其余多为透传）
- `sew.oneHot_*`：SEW onehot（最终走到 `io.sewIn.*`）

对于 LaneFAdd 来说，最“影响功能”的通常是：

- `payload.uop.ctrl.funct6`：指令编码（决定走 add/sub/minmax/compare/sgnj/move 等路径）
- `payload.uop.ctrl.funct3`：OPFVV/OPFVF（决定 vector-scalar 语义）
- widen 类：`payload.uop.ctrl.widen / widen2` 与 `payload.uop.uopIdx`

其余 uop 字段在本环境中主要用于“透明传输一致性检查”（RM 会对照输入与输出的 uop 透传字段）。

### 4.4 从“意图”到“比特流”：transaction 的生命周期

通常有两条路径：

#### 4.4.1 受限随机（推荐）

1) 你在 `randomize_with()` 中约束：`uop_type/sew_type/funct3_type` + `fp_pairs[i].*`
2) `post_randomize()` 内部会：
   - 调 `decode_to_payload()`：把高层选择映射成 `uop.ctrl/sewIn` 等字段
   - 调 `pack_to_bits()`：把 `fp_pairs` 打包到 `payload.vs1/vs2/rs1`

这种写法的优势是：**约束表达意图最清晰**，且更容易做覆盖闭环（改 knob 即可补覆盖）。

#### 4.4.2 定向（directed）/混合式（常用于复现 corner）

典型做法是：

- 先用 `randomize_with()` 把结构性字段随机出一个“合法骨架”（例如 uop/sew/form）
- 再手工覆写部分 `FpPair` 或直接改 payload（例如固定某个 exp/man）
- 最后显式调用一次 `post_randomize()`（或至少保证 `decode_to_payload()`+`pack_to_bits()` 重新生效）

仓库中的混合式定向用例参考： [test_directed.py](../tests/test_directed.py)

### 4.5 容易踩坑的点（transaction 相关）

- 只改了 `fp_pairs` 但没重新触发打包：会导致 `payload.vs1/vs2/rs1` 仍是旧值
- 只改了 `payload.vs1/vs2/rs1` 但没更新 `uop.ctrl/sewIn`：会出现“数据像是 FP32，但 sewIn 却是 FP16”一类不一致
- OPFVF 的语义：标量端来自 `rs1` 且会 broadcast；因此如果你想定向 scalar，优先设置 `rs1` 或约束 `fp_pairs[i].a` 一致性
- widen/widen2 + `uopIdx`：16-bit 输入时会选择高/低 32-bit 半字，定向 case 要明确 `uopIdx` 才能稳定复现

## 5. 驱动/监视/比对：事务如何在环境中流动

### 5.1 Sequence 如何发事务

序列基类 [vfadd_base_seq.py](../env/vfadd_base_seq.py) 的核心流程：

- `add_xaction(xaction_num)`：生成 N 条 tx，分配 `transaction_id`，塞入本地队列（末尾塞一个 `None` 作为结束标记）
- `send_xaction()`：逐条 `await self.agent.drive(tx)`

用例通常通过覆写 `gen_xaction()` 来定义“本用例要产生什么 transaction”。

补充说明（建议理解清楚这三个函数的分工）：

- `gen_xaction()`：定义“生成一条事务”的策略（纯随机 / 受限随机 / 定向）。通常你会在这里对 `vfadd_xaction` 做 `randomize_with()`，把约束写在“高层意图”上（`uop_type/sew_type/fp_pairs[*].exp_relation/...`），让 `post_randomize()` 自动把意图下翻到底层 `payload`。
- `add_xaction(xaction_num)`：循环调用 `gen_xaction()` 生成 N 条事务并入队，同时给每条事务分配 `transaction_id`；末尾会塞入一个 `None` 作为结束哨兵。
- `send_xaction()`：从本地队列取事务并 `await self.agent.drive(tx)` 发送给 master agent；遇到 `None` 结束。

一个典型写法（与仓库用例保持一致）：

```python
class tc_demo_seq(vfadd_base_seq):
    @vsc.constraint
    def tc_demo_seq_c(self):
        vsc.soft(self.xaction_num == 50)

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            t.uop_type == UopType.VFADD
            t.sew_type == SewType.FP16
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                t.fp_pairs[i].exp_relation == ExpRelation.CLOSE
        return tx
```

当你在 `randomize_with()` 之后又手工修改了 `fp_pairs` 或 `uop_type/sew_type` 时，记得重新触发一次 `tx.post_randomize()`（否则 `payload.vs1/vs2/rs1` 可能仍是旧值）。

### 5.2 Master Agent 如何驱动 DUT

`vfadd_master_agent.drive()` 负责把 `vfadd_xaction` 的低层 payload 写进 DUT 输入端口，并打 `valid`，随后拉低并插入 `delay` 空拍。
文件：[vfadd_master_agent.py](../env/vfadd_master_agent.py)

`vfadd_master_agent.monitor_in()` 在 `io.in.valid` 为 1 时抓取输入，并重构为 `vfadd_xaction` 交给 reference model。

### 5.3 Slave Agent 如何采集输出

`vfadd_slave_agent.monitor_out()` 在 `io.out.valid` 或 `io.rd.valid` 为 1 时采集输出 payload（vd/fflags/uop 透传 + rd 写回）。
文件：[vfadd_slave_agent.py](../env/vfadd_slave_agent.py)

### 5.4 Reference Model / Scoreboard / Coverage

`vfadd_rm` 同时监听 master 输入与 slave 输出：

- 输入侧：`input_tx.reconstruct()` 后按 `uop_type` 选择预测函数（add/sub/minmax/sgn/compare/move）
- 输出侧：按 `transaction_id` 对齐期望与实测，然后 `_compare()` 报错/统计
- 覆盖：`self.cov.sample(input_tx)`（基于输入事务采样）

文件：[vfadd_rm.py](../env/vfadd_rm.py)

## 6. 如何新增/扩展一个用例（推荐写法）

最推荐的扩展方式是遵循现有用例结构：

1) 新建 `tests/test_xxx.py`
2) 定义一个 `vfadd_base_seq` 子类，覆写 `gen_xaction()`，用约束或直接赋值表达意图
3) 定义一个 `BaseTestCase` 子类，把 `self.seq = your_seq(self.env.vfadd_master_agent)`
4) 暴露一个 `@toffee_test.testcase` 的 pytest 入口函数

可参考现有用例：

- 基础算术随机： [test_basic_arith.py](../tests/test_basic_arith.py)
- widen 随机： [test_widen_random.py](../tests/test_widen_random.py)
- compare 随机： [test_cmp.py](../tests/test_cmp.py)
- 定向（directed）示例： [test_directed.py](../tests/test_directed.py)

## 7. 运行入口与日志/覆盖

### 7.1 pytest 入口

每个 `tests/test_*.py` 里的 `@toffee_test.testcase` 函数都是 pytest 入口；fixture 会负责：

- 设置 `SEED`
- 初始化 Reporter（每用例一份 `./report_log/<name>_<seed>.log`）
- 注册功能覆盖组

fixture： [conftest.py](../tests/conftest.py)

### 7.1.1 Seed 决策优先级（非常重要）

`vfadd_setup` 会在用例开始前决定本次运行的 seed，并确保 Python 的 `random` 与环境变量保持一致：

1. 回归/参数化提供的 seed：`pytest_generate_tests()` 通过参数化把 `seed` 注入 `vfadd_setup`（`request.param["seed"]`）
2. 命令行指定：`--seed <N>`
3. 环境变量：`SEED=<N>`
4. 默认值：0

随后会执行：

- `os.environ["SEED"] = str(seed)`：确保后续子模块/日志能读到本次 seed
- `random.seed(seed)`：确保 Python 侧随机行为可复现

关键实现位置与作用摘要：

- `pytest_addoption(parser)`：注册 `--seed/--tl/--reg-seed/--regress/--count` 命令行参数（方便统一控制）
- `_get_reg_seed(config)`：确定“回归基种子”（base seed），支持显式指定 `--reg-seed` 或随机生成并打印；在分布式（xdist）下广播给各 worker，保证多进程一致
- `_det_seed(base, nodeid, idx)`：把 base seed 与“测试用例标识 + 迭代序号”组合做哈希，得到确定性的 per-iteration seed（保证同一 base 下的不同用例/不同迭代稳定复现）
- `pytest_generate_tests(metafunc)`：在回归或 tl 模式下展开参数化，把每次迭代的 `seed/wave/iter` 注入到 `vfadd_setup` fixture
- `vfadd_setup(toffee_request, request)`：最终落地 seed 的地方；从参数/命令行/环境变量决定 seed，设置 `os.environ["SEED"]` 与 `random.seed()`，并初始化 DUT、Reporter、覆盖等

### 7.1.2 回归模式的 base seed（--regress/--count/--reg-seed）

回归模式的目标是：**同一个用例在多次迭代里使用不同 seed，但整个回归集合在同一个 base seed 下保持确定性**。

关键函数（在 [conftest.py](../tests/conftest.py)）：

- `pytest_addoption()`：注册 `--regress/--count/--reg-seed`
- `_get_reg_seed(config)`：
  - 优先使用 `--reg-seed`（用于固定回归集合）
  - 否则用 `random.SystemRandom().getrandbits(32)` 生成随机 base seed（并打印出来，便于复现）
  - 在 xdist 场景下通过 `pytest_configure_node()` 广播给各 worker，保证所有 worker 使用同一个 base seed
- `_det_seed(base, nodeid, idx)`：
  - 以 `(base_seed | test_nodeid | iter_idx)` 做 sha256
  - 取低 32-bit 作为本次迭代的 seed
  - 这样同一个 base seed 下，不同测试/不同迭代的 seed 都是确定且分散的

### 7.1.3 TL 列表模式（--tl）

TL 列表用于“按清单挑选用例 + 指定每个用例跑几次（可附带 wave 标记）”。

- 解析函数：`_parse_tl(path)`
- 选择逻辑：`pytest_generate_tests()` 会用 tl 的 `name` 去匹配 `metafunc.definition.nodeid`
- 过滤逻辑：`pytest_collection_modifyitems()` 会根据 tl 里出现的 `name` 过滤用例集合

tl 文件格式（每行）：

```text
<name_substring>,<count>,wave=on|wave=off
```

其中 `wave=on/off` 目前在 `vfadd_setup` 里不会改变 pytest 跑法，但会作为参数保留，便于你后续在用例/环境中扩展成“是否启用波形/FSDB”的开关。

### 7.2 Reporter

Reporter 在 fixture 中绑定 DUT，并输出 `Cycle/Time` 时间戳；具体机制见：

- guide： [reporter_guide.md](./reporter_guide.md)
- 实现： [prj_reporter.py](../env/common/prj_reporter.py)

### 7.3 功能覆盖（Closed-Loop）

覆盖采样点来自 `VFAddCovWrap`，采样输入事务 `input_tx`。你可以用覆盖结果反推“还缺哪些组合”，再通过收紧 `fp_pairs` 的关系约束来补齐。

相关文件：

- 覆盖封装： [vfadd_cov_wrap.py](../tests/vfadd_cov_wrap.py)
- 覆盖组注册： [funcov_global.py](../tests/funcov_global.py)（由 conftest 统一注册）
