import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory, FpPrecision, ExpRelation, ManRelation, SignRelation

class tc_directed_seq(vfadd_base_seq):
    def __init__(self, agent):
        super().__init__(agent)
        # self.case_idx = 0  <-- Removed
        # self.total_cases = 6 <-- Removed

    @vsc.constraint
    def tc_cfg(self):
        # Repeat the same directed transaction 100 times
        self.xaction_num == 100

    def gen_xaction(self):
        tx = vfadd_xaction()
        # 1. 先进行基础随机化，确保结构合法
        # 此时只约束指令类型等控制字段，数据字段保持随机
        with tx.randomize_with() as t:
            t.uop_type.inside(vsc.rangelist(UopType.VFWADD_W, UopType.VFWSUB_W))
            t.sew_type == SewType.FP16
            t.funct3_type == Funct3Type.OPFVV
            t.is_legal == 1
            
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                t.fp_pairs[i].a.category == FpCategory.SUBNORMAL
                t.fp_pairs[i].b.category == FpCategory.NORMAL
                t.fp_pairs[i].b.exp.inside(vsc.rangelist(105, 104))
        
        for pair in tx.fp_pairs:
            pair.b.man = 0x003
            
        # 3. 重新调用 post_randomize 以更新 val_bits 和 payload
        tx.post_randomize()
        
        return tx


class TEST_Directed_TestCase(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_directed_seq(self.env.vfadd_master_agent)


@toffee_test.testcase
async def test_directed(vfadd_setup):
    test = TEST_Directed_TestCase(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
