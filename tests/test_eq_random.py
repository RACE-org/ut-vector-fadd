import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory, ExpRelation, ManRelation, SignRelation


class tc_eq_random_seq(vfadd_base_seq):
    @vsc.constraint
    def cfg(self):
        self.xaction_num == 1000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            vsc.dist(t.uop_type, [
                vsc.weight(UopType.VFADD, 10),
                vsc.weight(UopType.VFSUB, 10),
                vsc.weight(UopType.VFRSUB, 6),
                vsc.weight(UopType.VFWADD, 8),
                vsc.weight(UopType.VFWSUB, 8),
                vsc.weight(UopType.VFMIN, 6),
                vsc.weight(UopType.VFMAX, 6),
                vsc.weight(UopType.VFSGNJ, 6),
                vsc.weight(UopType.VFSGNJN, 6),
                vsc.weight(UopType.VFSGNJX, 6),
                vsc.weight(UopType.VMFEQ, 6),
                vsc.weight(UopType.VMFNE, 6),
                vsc.weight(UopType.VMFLT, 6),
                vsc.weight(UopType.VMFLE, 6),
                vsc.weight(UopType.VMFGT, 6),
                vsc.weight(UopType.VMFGE, 6),
                vsc.weight(UopType.VFMV, 4),
                vsc.weight(UopType.VFMV_F_S, 2),
                vsc.weight(UopType.VFMV_S_F, 2),
            ])
            vsc.dist(t.funct3_type, [
                vsc.weight(Funct3Type.OPFVV, 60),
                vsc.weight(Funct3Type.OPFVF, 40),
            ])
            vsc.dist(t.sew_type, [
                vsc.weight(SewType.FP16, 45),
                vsc.weight(SewType.BF16, 35),
                vsc.weight(SewType.FP32, 20),
            ])

            with vsc.foreach(t.fp_pairs, idx=True) as i:
                vsc.dist(t.fp_pairs[i].a.category, [
                    vsc.weight(FpCategory.NORMAL, 45),
                    vsc.weight(FpCategory.ZERO, 10),
                    vsc.weight(FpCategory.SUBNORMAL, 20),
                    vsc.weight(FpCategory.INFINITY, 10),
                    vsc.weight(FpCategory.NAN, 15),
                ])
                t.fp_pairs[i].b.category == t.fp_pairs[i].a.category

                t.fp_pairs[i].sign_relation == SignRelation.SAME
                t.fp_pairs[i].exp_relation == ExpRelation.EQUAL
                t.fp_pairs[i].man_relation == ManRelation.EQUAL

                t.fp_pairs[i].b.sign == t.fp_pairs[i].a.sign
                t.fp_pairs[i].b.exp == t.fp_pairs[i].a.exp
                t.fp_pairs[i].b.man == t.fp_pairs[i].a.man

        return tx


class TEST_EqRandom(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_eq_random_seq(self.env.vfadd_master_agent)


@toffee_test.testcase
async def test_eq_random(vfadd_setup):
    test = TEST_EqRandom(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
