# Verification Plan Details

详细验证点计划

## 1、覆盖组定义（Coverage Groups）

核心点来自对于一条指令而言，有指令本身的功能点，也有数据特性的功能点，因此我将覆盖组分为了COMMON级别、指令级别、element级别。

* COMMON的：比如sew、form（FVF或者FVV）这属于共有的特点，对每个transaction都采样
* Element级别：这个会采样到具体到每一个lane的数据，用来cross他们之间的关系
* 指令级别：根据指令分类，不同指令进入不同采样组进行采样

覆盖点来自功能覆盖封装 `VFAddCovWrap`，按 group 分类如下：

| Group                                        | 覆盖点（Point）                                                                                                                                                                                                                                                                                                                                  |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| COMMON（公用）                               | `COMMON.sew`、`COMMON.form`、`COMMON.input_nan`                                                                                                                                                                                                                                                                                            |
| ELEMENT（element 级，按 lane_idx/pair 采样） | `ELEMENT.lane`、`ELEMENT.a_category`、`ELEMENT.b_category`、`ELEMENT.ab_category_cross`、`ELEMENT.lane_ab_category_cross`、`ELEMENT.exp_relation`、`ELEMENT.man_relation`、`ELEMENT.sign_relation`、`ELEMENT.sign_combo`、`ELEMENT.prec_pair`、`ELEMENT.cmp_nan_in_pair`、`ELEMENT.cmp_result`、`ELEMENT.cmp_relation` |
| FADD_SUB（指令级）                           | `FADD_SUB.uop`、`FADD_SUB.sew`、`FADD_SUB.form`、`FADD_SUB.uop_sew`、`FADD_SUB.form_sew`                                                                                                                                                                                                                                               |
| WIDEN（指令级）                              | `WIDEN.uop`、`WIDEN.sew`、`WIDEN.form`、`WIDEN.widen_flags`、`WIDEN.uopIdx`                                                                                                                                                                                                                                                            |
| FCMP（指令 级）                              | `FCMP.uop`、`FCMP.sew`、`FCMP.form`                                                                                                                                                                                                                                                                                                        |
| MINMAX（指令级）                             | `MINMAX.uop`、`MINMAX.sew`、`MINMAX.form`                                                                                                                                                                                                                                                                                                  |
| SIGN（指令级）                               | `SIGN.uop`、`SIGN.sew`、`SIGN.form`                                                                                                                                                                                                                                                                                                        |
| FMV（指令级）                                | `FMV.uop`、`FMV.sew`、`FMV.form`、`FMV.src_category`                                                                                                                                                                                                                                                                                     |

## 2 、运行方法（Run）

- 单用例（pytest）：

  - `SEED=<seed> python3 -m pytest -s -k <test_name> tests/`
- 单用例（sim/Makefile，生成报告目录）：

  - `make -C sim run tc=<test_name> seed=<seed> wave=off`
- 多 seed 回归（默认：tests 下所有 case，每个跑 5 次）：

  - `python3 -m pytest -s --regress tests/`
- 按 tl 列表回归（用例 + 次数 + 可选 wave 标记）：

  - `python3 -m pytest -s --tl tl/<xxx>.tl.lst tests/`

## 3、测试用例说明

总共分为六大类，由于实现的时候部分指令做了细分，因此分类上不直接符合之前的分类

### 直接测试用例说明

该小节仅用于说明“如何写 directed case”，这里直接引用仓库中已经存在的一个定向用例作为示例（不贴代码）。

**示例用例**

- `tests/test_directed.py::test_directed`

**用例要点**

- 定向约束 `uop_type`：`VFWADD_W / VFWSUB_W`（widen2 类指令）
- 固定 `sew_type=FP16`、`funct3_type=OPFVV`
- 强制输入类别组合（例如 `A=SUBNORMAL, B=NORMAL`），并对 `B.exp/B.man` 做定向范围/定值，便于稳定复现特定 corner
- 事务数较小（循环重复同一类构造），用于快速定位/复现问题

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k test_directed tests/`
- `make -C sim run tc=test_directed seed=<seed> wave=off`

### 3.1 测试用例1: 基础算术测试

该用例是验证 LaneFAdd 模块核心加减法功能，重点验证其在不同数据格式下的计算精度，以及对浮点标准中特殊值的处理能力。

**pytest入口（对应仓库 tests/）**

- `test_sanity`：小规模 sanity
- `test_normal_basic_arith`：仅 NORMAL 覆盖（排除特殊值干扰）
- `test_basic_arith`：覆盖特殊值 + 关系分布

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k "test_sanity or test_normal_basic_arith or test_basic_arith" tests/`
- `make -C sim run tc=test_basic_arith seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- COMMON：`COMMON.sew`、`COMMON.form`、`COMMON.input_nan`
- FADD_SUB：`FADD_SUB.uop`、`FADD_SUB.sew`、`FADD_SUB.form`、`FADD_SUB.uop_sew`、`FADD_SUB.form_sew`
- ELEMENT：`ELEMENT.a_category`、`ELEMENT.b_category`、`ELEMENT.ab_category_cross`、`ELEMENT.lane_ab_category_cross`、`ELEMENT.exp_relation`、`ELEMENT.man_relation`、`ELEMENT.sign_relation`、`ELEMENT.sign_combo`

**用例说明**

- 遍历 `vfadd/vfsub/vfrsub` 与 `FP32/FP16/BF16`
- 遍历 `funct3` 数据来源（`OPFVV/OPFVF`）
- 覆盖普通数值与特殊值：`±0/±INF/QNaN/Denormal`

**预期结果**

- 测试点1.1/1.2/1.3：结果与参考模型一致

### 3.2 测试用例2: Widen算术测试

该用例专注于验证Widen指令（如 vfwadd）的正确性，核心是验证16位操作数到32位操作数的选择、扩展和计算逻辑。

**pytest入口**

- `test_widen_random`：随机 widen/widen2
- `test_normal_widen`：仅 NORMAL widen/widen2
- `test_directed`：定向 widen2（`VFWADD_W/VFWSUB_W`）

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k "test_widen_random or test_normal_widen or test_directed" tests/`
- `make -C sim run tc=test_widen_random seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- COMMON：`COMMON.sew`、`COMMON.form`、`COMMON.input_nan`
- WIDEN：`WIDEN.uop`、`WIDEN.sew`、`WIDEN.form`、`WIDEN.widen_flags`、`WIDEN.uopIdx`
- ELEMENT：`ELEMENT.prec_pair`、`ELEMENT.lane`、`ELEMENT.exp_relation`、`ELEMENT.man_relation`

**用例说明**

- 覆盖 `vfwadd/vfwsub/vfwadd.w/vfwsub.w`，确保 `widen/widen2` 生效
- 普通 widen：输入 FP16/BF16；widen2：存在 FP32 端（由 pair precision 体现）
- 遍历 `uopIdx`（0/1）验证高低 32-bit 选择
- 遍历 `funct3`（`OPFVV/OPFVF`）

**预期结果**

- 测试点2.1/2.2/2.3/2.4：结果与参考模型一致

### 3.3 测试用例3: 比较功能测试

该用例为比较功能测试，用于测试6条向量浮点compare指令。

**pytest入口**

- `test_cmp`

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k test_cmp tests/`
- `make -C sim run tc=test_cmp seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- FCMP：`FCMP.uop`、`FCMP.sew`、`FCMP.form`
- ELEMENT（比较结果）：`ELEMENT.cmp_nan_in_pair`、`ELEMENT.cmp_relation`、`ELEMENT.cmp_result`
- COMMON：`COMMON.input_nan`

**用例说明**

- 遍历 `vmfeq/vmfne/vmflt/vmfle/vmfgt/vmfge`
- 遍历 `SEW=FP16/BF16/FP32`
- 构造 true/false/NaN 等场景，覆盖 UNORDERED
- 遍历 `funct3`（`OPFVV/OPFVF`）

**预期结果**

- `io.out.bits.vd` 产生正确 mask；与 NaN 比较除 `vmfne` 外结果为 0

### 3.4 测试用例4: Min/max选择功能

该用例测试最大最小值选择功能。

**pytest入口**

- `test_min_max`

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k test_min_max tests/`
- `make -C sim run tc=test_min_max seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- MINMAX：`MINMAX.uop`、`MINMAX.sew`、`MINMAX.form`
- ELEMENT：`ELEMENT.a_category`、`ELEMENT.b_category`、`ELEMENT.ab_category_cross`

**用例说明**

- 遍历 `vfmin/vfmax`
- 遍历 `SEW=BF16/FP16/FP32`
- 遍历 `funct3`（`OPFVV/OPFVF`）

**预期结果**

- 测试点4.1/4.2：结果与参考模型一致

### 3.5 测试用例5: 符号注入与move测试

该用例验证与数值计算无关的数据处理类指令，包括符号位操作和寄存器间的数据移动。

**pytest入口**

- SIGN：`test_sign`
- FMV：`test_vfmv_v_f`、`test_vfmv_f_s`、`test_vfmv_s_f`

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k "test_sign or test_vfmv_v_f or test_vfmv_f_s or test_vfmv_s_f" tests/`
- `make -C sim run tc=test_sign seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- SIGN：`SIGN.uop`、`SIGN.sew`、`SIGN.form`
- FMV：`FMV.uop`、`FMV.sew`、`FMV.form`、`FMV.src_category`
- ELEMENT（符号相关）：`ELEMENT.sign_combo`、`ELEMENT.sign_relation`

**用例说明**

- 遍历 `vfsgnj/vfsgnjn/vfsgnjx`，覆盖四种符号组合（+/+、+/-、-/+、-/-）
- 覆盖 `vfmv`、`vfmv.f.s`、`vfmv.s.f`，并覆盖源类别（NaN/非NaN 等）

**预期结果**

- sgnj/sgnjn/sgnjx：符号位符合规则，指数/尾数保持
- move：目标元素等于源值（或标量 rs1）

### 3.6 测试用例6: 随机压力测试

该用例通过长时间、大规模的随机激励，对 LaneFAdd 进行全面的压力测试

**pytest入口**

- `test_all_random`：全指令随机（不含 compare）
- `test_eq_random`：强制 A==B（强化 EQUAL 路径与等值传播）

**运行方法**

- `SEED=<seed> python3 -m pytest -s -k "test_all_random or test_eq_random" tests/`
- `make -C sim run tc=test_all_random seed=<seed> wave=off`

**覆盖点反标（按覆盖组）**

- `test_all_random`：COMMON、ELEMENT、FADD_SUB、WIDEN、MINMAX、SIGN、FMV、FCMP
- `test_eq_random`：强化 ELEMENT 的 `exp_relation=EQUAL`、`man_relation=EQUAL`、`sign_relation=SAME`；同时覆盖多个 transaction group（包含 FCMP）

**用例说明**

- 长时间、大规模随机事务
- 随机选择指令 + sew（FP32/FP16/BF16）
- 随机生成 vs1/vs2/rs1，按概率覆盖 NaN/INF/Zero/Denormal

**预期结果**

- 与参考模型一致
