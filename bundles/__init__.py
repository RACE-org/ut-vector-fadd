__all__ = ["LaneFAddBundle"]

from toffee.bundle import Bundle, Signals


class UopCtrlBundle(Bundle):
    lsrc_0, lsrc_1, ldest, vm, funct6, funct3 = Signals(6)
    illegal, lsrcVal_0, lsrcVal_1, lsrcVal_2, ldestVal, rdVal = Signals(6)
    load, store, arith, crossLane, alu, mul = Signals(6)
    fp, div, fixP, redu, mask, perm = Signals(6)
    vfadd, vfma, vfcvt, widen, widen2, narrow, narrow_to_1 = Signals(7)


class UopCsrBundle(Bundle):
    vstart, vl, vxrm, frm, vlmul, vsew, vill, ma, ta = Signals(9)


class UopBundle(Bundle):
    ctrl = UopCtrlBundle.from_prefix("ctrl_")
    csr = UopCsrBundle.from_prefix("csr_")
    robIdx_flag, robIdx_value = Signals(2)
    veewVd, uopIdx, uopEnd = Signals(3)
    lsrcUop_0, lsrcUop_1, lsrcValUop_0, lsrcValUop_1, lsrcValUop_2 = Signals(5)
    ldestUop, lmaskValUop, ldestValUop = Signals(3)


class InputPayloadBundle(Bundle):
    uop = UopBundle.from_prefix("uop_")
    vs1, vs2, vs3, rs1 = Signals(4)


class InputBundle(Bundle):
    valid = Signals(1)
    bits = InputPayloadBundle.from_prefix("bits_")


class SewInputBundle(Bundle):
    oneHot_0, oneHot_1, oneHot_2, oneHot_3 = Signals(4)


class OutputPayloadBundle(Bundle):
    uop = UopBundle.from_prefix("uop_")
    vd, fflags_0, fflags_1, fflags_2, fflags_3 = Signals(5)

class OutputBundle(Bundle):
    valid = Signals(1)
    bits = OutputPayloadBundle.from_prefix("bits_")


class RdBundle(Bundle):
    valid, bits = Signals(2)

class LaneFAddBundle(Bundle):
    input = InputBundle.from_prefix("in_")
    sewIn = SewInputBundle.from_prefix("sewIn_")
    output = OutputBundle.from_prefix("out_")
    rd = RdBundle.from_prefix("rd_")
