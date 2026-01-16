import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory

class tc_vfmv_f_s_seq(vfadd_base_seq):
    def __init__(self, agent):
        super().__init__(agent)

    @vsc.constraint
    def cfg(self):
        self.xaction_num == 300

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.uop_type == UopType.VFMV_F_S
            t.sew_type.inside(vsc.rangelist(SewType.FP16, SewType.FP32,SewType.BF16))
            t.is_legal == 1
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                t.fp_pairs[i].b.category.inside(vsc.rangelist(FpCategory.NORMAL, FpCategory.SUBNORMAL, FpCategory.ZERO))
        return tx

class TEST_VFMV_F_S(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_vfmv_f_s_seq(self.env.vfadd_master_agent)

@toffee_test.testcase
async def test_vfmv_f_s(vfadd_setup):
    test = TEST_VFMV_F_S(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
