import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory

class tc_widen_random_seq(vfadd_base_seq):
    def __init__(self, agent):
        super().__init__(agent)

    @vsc.constraint
    def cfg(self):
        self.xaction_num == 1000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            t.uop_type.inside(vsc.rangelist(UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W))
            vsc.dist(t.funct3_type, [
                vsc.weight(Funct3Type.OPFVV, 50),
                vsc.weight(Funct3Type.OPFVF, 50),
            ])
            t.sew_type.inside(vsc.rangelist(SewType.FP16, SewType.BF16))
            t.is_legal == 1
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                # 仿照 sanity 的权重分布
                vsc.dist(t.fp_pairs[i].a.category, [
                    vsc.weight(FpCategory.NORMAL, 30),
                    vsc.weight(FpCategory.ZERO, 15),
                    vsc.weight(FpCategory.SUBNORMAL, 30),
                    vsc.weight(FpCategory.INFINITY, 20),
                    vsc.weight(FpCategory.NAN, 20),
                ])
                vsc.dist(t.fp_pairs[i].b.category, [
                    vsc.weight(FpCategory.NORMAL, 30),
                    vsc.weight(FpCategory.ZERO, 10),
                    vsc.weight(FpCategory.SUBNORMAL, 20),
                    vsc.weight(FpCategory.INFINITY, 5),
                    vsc.weight(FpCategory.NAN, 20),
                ])
            # 指数与尾数关系权重，参考 sanity
            from env.fp_xaction import ExpRelation, ManRelation
            with vsc.foreach(t.fp_pairs, idx=True) as j:
                 vsc.dist(t.fp_pairs[j].exp_relation, [
                     vsc.weight(ExpRelation.EQUAL, 10),
                     vsc.weight(ExpRelation.CLOSE, 40),
                     vsc.weight(ExpRelation.FAR, 40),
                     vsc.weight(ExpRelation.RANDOM, 10)
                 ])
            with vsc.foreach(t.fp_pairs, idx=True) as m:
                 vsc.dist(t.fp_pairs[m].man_relation, [
                     vsc.weight(ManRelation.EQUAL, 5),
                     vsc.weight(ManRelation.SMALL_DIFF, 45),
                     vsc.weight(ManRelation.LARGE_DIFF, 45),
                     vsc.weight(ManRelation.RANDOM, 5) 
                 ])
        tx.post_randomize()
        return tx

class TEST_Widen_Random(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_widen_random_seq(self.env.vfadd_master_agent)

@toffee_test.testcase
async def test_widen_random(vfadd_setup):
    test = TEST_Widen_Random(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
