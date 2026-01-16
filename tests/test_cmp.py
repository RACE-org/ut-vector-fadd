import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType
from env.fp_xaction import FpCategory

class tc_cmp_seq(vfadd_base_seq):
    @vsc.constraint
    def cfg(self):
        self.xaction_num == 2000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            vsc.dist(t.uop_type, [
                vsc.weight(UopType.VMFEQ, 1),
                vsc.weight(UopType.VMFNE, 1),
                vsc.weight(UopType.VMFLT, 1),
                vsc.weight(UopType.VMFLE, 1),
                vsc.weight(UopType.VMFGE, 1),
                vsc.weight(UopType.VMFGT, 1),
            ])
            t.sew_type.inside(vsc.rangelist(SewType.FP32, SewType.FP16, SewType.BF16))
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                with vsc.if_then(i == 0):
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 55),
                        vsc.weight(FpCategory.ZERO, 12),
                        vsc.weight(FpCategory.INFINITY, 8),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 15)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 50),
                        vsc.weight(FpCategory.ZERO, 15),
                        vsc.weight(FpCategory.INFINITY, 10),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 15)
                    ])
                with vsc.else_if(i == 1):
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 45),
                        vsc.weight(FpCategory.ZERO, 18),
                        vsc.weight(FpCategory.INFINITY, 12),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 15)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 48),
                        vsc.weight(FpCategory.ZERO, 12),
                        vsc.weight(FpCategory.INFINITY, 10),
                        vsc.weight(FpCategory.NAN, 15),
                        vsc.weight(FpCategory.SUBNORMAL, 15)
                    ])
                with vsc.else_then():
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 52),
                        vsc.weight(FpCategory.ZERO, 10),
                        vsc.weight(FpCategory.INFINITY, 8),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 20)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 52),
                        vsc.weight(FpCategory.ZERO, 10),
                        vsc.weight(FpCategory.INFINITY, 8),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 20)
                    ])
                from env.fp_xaction import ExpRelation, ManRelation
                with vsc.foreach(t.fp_pairs, idx=True) as j:
                     vsc.dist(t.fp_pairs[j].exp_relation, [
                     vsc.weight(ExpRelation.EQUAL, 30),
                     vsc.weight(ExpRelation.CLOSE, 40),
                     vsc.weight(ExpRelation.FAR, 40),
                     vsc.weight(ExpRelation.RANDOM, 10)
                 ])
                with vsc.foreach(t.fp_pairs, idx=True) as m:
                 vsc.dist(t.fp_pairs[m].man_relation, [
                     vsc.weight(ManRelation.EQUAL, 30),
                     vsc.weight(ManRelation.SMALL_DIFF, 45),
                     vsc.weight(ManRelation.LARGE_DIFF, 45),
                     vsc.weight(ManRelation.RANDOM, 5) 
                 ])
        return tx

class TC_Compare_TestCase(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_cmp_seq(self.env.vfadd_master_agent)

@toffee_test.testcase
async def test_cmp(vfadd_setup):
    test = TC_Compare_TestCase(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
