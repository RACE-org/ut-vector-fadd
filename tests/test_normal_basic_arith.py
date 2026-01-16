import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory, ExpRelation, ManRelation


class tc_normal_basic_arith_seq(vfadd_base_seq):
    @vsc.constraint
    def cfg(self):
        self.xaction_num == 1000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            t.uop_type.inside(vsc.rangelist(UopType.VFADD, UopType.VFSUB, UopType.VFRSUB))
            t.sew_type.inside(vsc.rangelist(SewType.FP32, SewType.FP16, SewType.BF16))

            vsc.dist(t.funct3_type, [
                vsc.weight(Funct3Type.OPFVV, 60),
                vsc.weight(Funct3Type.OPFVF, 40),
            ])

            with vsc.foreach(t.fp_pairs, idx=True) as i:
                t.fp_pairs[i].a.category == FpCategory.NORMAL
                t.fp_pairs[i].b.category == FpCategory.NORMAL

            with vsc.foreach(t.fp_pairs, idx=True) as k:
                vsc.dist(t.fp_pairs[k].exp_relation, [
                    vsc.weight(ExpRelation.EQUAL, 10),
                    vsc.weight(ExpRelation.CLOSE, 40),
                    vsc.weight(ExpRelation.FAR, 40),
                    vsc.weight(ExpRelation.RANDOM, 10)
                ])
                vsc.dist(t.fp_pairs[k].man_relation, [
                    vsc.weight(ManRelation.EQUAL, 5),
                    vsc.weight(ManRelation.SMALL_DIFF, 45),
                    vsc.weight(ManRelation.LARGE_DIFF, 45),
                    vsc.weight(ManRelation.RANDOM, 5)
                ])
        return tx


class TEST_Normal_BasicArith(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_normal_basic_arith_seq(self.env.vfadd_master_agent)


@toffee_test.testcase
async def test_normal_basic_arith(vfadd_setup):
    test = TEST_Normal_BasicArith(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
