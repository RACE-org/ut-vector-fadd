import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory

class tc_min_max_seq(vfadd_base_seq):
    def __init__(self, agent):
        super().__init__(agent)

    @vsc.constraint
    def cfg(self):
        self.xaction_num == 1000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.uop_type.inside(vsc.rangelist(UopType.VFMIN, UopType.VFMAX))
            t.funct3_type.inside(vsc.rangelist(Funct3Type.OPFVV, Funct3Type.OPFVF))
            t.sew_type.inside(vsc.rangelist(SewType.FP16, SewType.FP32, SewType.BF16))
            t.is_legal == 1
            with vsc.foreach(t.fp_pairs, idx=True) as i:
               vsc.dist(t.fp_pairs[i].a.category, [
                   vsc.weight(FpCategory.NORMAL, 70),
                   vsc.weight(FpCategory.ZERO, 35),
                   vsc.weight(FpCategory.INFINITY, 5),
                   vsc.weight(FpCategory.NAN, 10),
                   vsc.weight(FpCategory.SUBNORMAL, 10)
               ])
               vsc.dist(t.fp_pairs[i].b.category, [
                   vsc.weight(FpCategory.NORMAL, 35),
                   vsc.weight(FpCategory.ZERO, 8),
                   vsc.weight(FpCategory.INFINITY, 10),
                   vsc.weight(FpCategory.NAN, 20),
                   vsc.weight(FpCategory.SUBNORMAL, 10)
               ])
        return tx

class TEST_MinMax(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_min_max_seq(self.env.vfadd_master_agent)

@toffee_test.testcase
async def test_min_max(vfadd_setup):
    test = TEST_MinMax(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
