import vsc
import toffee_test
from tests.base_test import BaseTestCase
from env.vfadd_pkg import vfadd_base_seq
from env.vfadd_xaction import vfadd_xaction, SewType, UopType, Funct3Type
from env.fp_xaction import FpCategory, ExpRelation, ManRelation


class tc_basic_arith_seq(vfadd_base_seq):
    @vsc.constraint
    def tc_cfg(self):
        self.xaction_num == 2000

    def gen_xaction(self):
        tx = vfadd_xaction()
        with tx.randomize_with() as t:
            t.is_legal == 1
            t.uop_type.inside(vsc.rangelist(UopType.VFADD, UopType.VFSUB, UopType.VFRSUB))
            t.sew_type.inside(vsc.rangelist(SewType.FP32, SewType.FP16, SewType.BF16))
            
            vsc.dist(t.funct3_type, [   
                vsc.weight(Funct3Type.OPFVV, 60),  # FVV
                vsc.weight(Funct3Type.OPFVF, 40),  # FVR (scalar)
            ])
            
            ##约束func3t type 权重
            with vsc.foreach(t.fp_pairs, idx=True) as i:
                # 不同元素赋予不同偏好，避免整组高度同质
                with vsc.if_then(i == 0):
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 30),
                        vsc.weight(FpCategory.ZERO, 25),
                        vsc.weight(FpCategory.INFINITY, 20),
                        vsc.weight(FpCategory.NAN, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 10)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 35),
                        vsc.weight(FpCategory.ZERO, 25),
                        vsc.weight(FpCategory.INFINITY, 20),
                        vsc.weight(FpCategory.NAN, 20),
                        vsc.weight(FpCategory.SUBNORMAL, 10)
                    ])
                with vsc.else_if(i == 1):
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 38),
                        vsc.weight(FpCategory.INFINITY, 30),
                        vsc.weight(FpCategory.NAN, 20),
                        vsc.weight(FpCategory.ZERO, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 5)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 32),
                        vsc.weight(FpCategory.INFINITY, 30),
                        vsc.weight(FpCategory.NAN, 20),
                        vsc.weight(FpCategory.ZERO, 10),
                        vsc.weight(FpCategory.SUBNORMAL, 5)
                    ])
                with vsc.else_then():
                    vsc.dist(t.fp_pairs[i].a.category, [
                        vsc.weight(FpCategory.NORMAL, 35),
                        vsc.weight(FpCategory.SUBNORMAL, 30),
                        vsc.weight(FpCategory.ZERO, 15),
                        vsc.weight(FpCategory.INFINITY, 10),
                        vsc.weight(FpCategory.NAN, 20)
                    ])
                    vsc.dist(t.fp_pairs[i].b.category, [
                        vsc.weight(FpCategory.NORMAL, 35),
                        vsc.weight(FpCategory.SUBNORMAL, 30),
                        vsc.weight(FpCategory.ZERO, 15),
                        vsc.weight(FpCategory.INFINITY, 10),
                        vsc.weight(FpCategory.NAN, 21)
                    ])
                    
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
                    ##约束FP Pair内部关系权重
                    
        return tx


class TEST_BasicArith_TestCase(BaseTestCase):
    def create_sequence(self):
        self.seq = tc_basic_arith_seq(self.env.vfadd_master_agent)


@toffee_test.testcase
async def test_basic_arith(vfadd_setup):
    test = TEST_BasicArith_TestCase(vfadd_setup)
    await test.run()
    assert test.env.vfadd_rm.fail_count == 0
