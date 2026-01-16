import asyncio
import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType
from env.fp_xaction import ExpRelation, ManRelation, FpCategory

# 1. 定义特定的 Sequence
class tc_sanity_seq(vfadd_base_seq):
    @vsc.constraint
    def tc_sanity_seq_c(self):
        vsc.soft(self.xaction_num == 50)
    
    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            t.uop_type.inside(vsc.rangelist(UopType.VFADD, UopType.VFSUB))
            t.sew_type.inside(vsc.rangelist(SewType.FP32, SewType.FP16,SewType.BF16))

            # --- 1. 基础分布 (保持不变) ---
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                vsc.dist(t.fp_pairs[i].exp_relation, [
                    vsc.weight(ExpRelation.EQUAL, 10),
                    vsc.weight(ExpRelation.CLOSE, 40),
                    vsc.weight(ExpRelation.FAR, 40),
                    vsc.weight(ExpRelation.RANDOM, 10)
                ])
            
            with vsc.foreach(t.fp_pairs, idx=True) as j:
                 vsc.dist(t.fp_pairs[j].man_relation, [
                     vsc.weight(ManRelation.EQUAL, 5),
                     vsc.weight(ManRelation.SMALL_DIFF, 45),
                     vsc.weight(ManRelation.LARGE_DIFF, 45),
                     vsc.weight(ManRelation.RANDOM, 5) 
                 ])

            with vsc.foreach(t.fp_pairs, idx=True) as m:
                # ... (Category 分布保持不变) ...
                vsc.dist(t.fp_pairs[m].a.category, [
                    vsc.weight(FpCategory.NORMAL, 20), vsc.weight(FpCategory.ZERO, 0),
                    vsc.weight(FpCategory.SUBNORMAL, 0), vsc.weight(FpCategory.INFINITY, 0),
                    vsc.weight(FpCategory.NAN, 0)
                ])
                vsc.dist(t.fp_pairs[m].b.category, [
                    vsc.weight(FpCategory.NORMAL, 20), vsc.weight(FpCategory.ZERO, 0),
                    vsc.weight(FpCategory.SUBNORMAL, 0), vsc.weight(FpCategory.INFINITY, 0),
                    vsc.weight(FpCategory.NAN, 0)
                ])  
        return tx

# 2. 定义测试类
class SanityTestCase(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_sanity_seq(self.env.vfadd_master_agent)

# 3. Pytest 入口函数
@toffee_test.testcase
async def test_sanity(vfadd_setup):
    """Test entry point wrapper."""
    test_instance = SanityTestCase(vfadd_setup)
    await test_instance.run()
    assert test_instance.fail_count == 0
