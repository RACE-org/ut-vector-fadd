"""
VFAdd Transaction Definition (Version 2).

Refactored to use PyVSC directly for randomization, flattening the structure
for ease of constraint writing, while maintaining full compatibility with
the DUT interface specification.
"""

import vsc
from enum import IntEnum, auto
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple
from tabulate import tabulate
from env.common.prj_reporter import get_reporter, ReportLevel
from env.fp_xaction import FpPair, FpPrecision, ExpRelation, ManRelation, FpCategory, SignRelation

__all__ = [
    "vfadd_xaction",
    "UopType",
    "SewType",
    "Funct3Type",
    "UopCtrl",
    "UopCsr",
    "Uop",
    "InputPayload",
    "SewInput",
    "OutputPayload",
]

# ==============================================================================
# 1. Enumerations & Constants
# ==============================================================================

class SewType(IntEnum):
    """Standard Element Width (SEW) types."""
    BF16 = 0
    FP16 = 1
    FP32 = 2
    # FP64 = 3 (Not supported)

class Funct3Type(IntEnum):
    """Funct3 field values."""
    OPIVV = 0b000
    OPFVV = 0b001
    OPMVV = 0b010
    OPIVI = 0b011
    OPIVX = 0b100
    OPFVF = 0b101
    OPMVX = 0b110
    OPCFG = 0b111

class UopType(IntEnum):
    """Enumeration of all supported Micro-ops."""
    VFADD    = 0
    VFSUB    = 1
    VFRSUB   = 2
    VFWADD   = 3
    VFWSUB   = 4
    VFWADD_W = 5
    VFWSUB_W = 6
    VFMIN    = 7
    VFMAX    = 8
    VFSGNJ   = 9
    VFSGNJN  = 10
    VFSGNJX  = 11
    VMFEQ    = 12
    VMFNE    = 13
    VMFLT    = 14
    VMFLE    = 15
    VMFGT    = 16
    VMFGE    = 17
    VFMV     = 18
    VFMV_F_S = 19
    VFMV_S_F = 20

# Mapping from UopType to Funct6
UOP_FUNCT6_MAP = {
    UopType.VFADD:    0b000000,
    UopType.VFSUB:    0b000010,
    UopType.VFRSUB:   0b100111,
    UopType.VFWADD:   0b110000,
    UopType.VFWSUB:   0b110010,
    UopType.VFWADD_W: 0b110100,
    UopType.VFWSUB_W: 0b110110,
    UopType.VFMIN:    0b000100,
    UopType.VFMAX:    0b000110,
    UopType.VFSGNJ:   0b001000,
    UopType.VFSGNJN:  0b001001,
    UopType.VFSGNJX:  0b001010,
    UopType.VMFEQ:    0b011000,
    UopType.VMFNE:    0b011100,
    UopType.VMFLT:    0b011011,
    UopType.VMFLE:    0b011001,
    UopType.VMFGT:    0b011101,
    UopType.VMFGE:    0b011111,
    UopType.VFMV:     0b010111,
    UopType.VFMV_F_S: 0b010000,
    UopType.VFMV_S_F: 0b010000,
}

# Reverse Mapping from Funct6 to UopType
# Note: VFMV_F_S and VFMV_S_F share the same funct6 (0b010000).
# They are distinguished by funct3 (OPFVV vs OPFVF).
FUNCT6_UOP_MAP = {}
for k, v in UOP_FUNCT6_MAP.items():
    if v not in FUNCT6_UOP_MAP:
        FUNCT6_UOP_MAP[v] = []
    FUNCT6_UOP_MAP[v].append(k)

UOP_NAME_MAP = {k: k.name.lower() for k in UopType}

# Groupings for constraints
WIDEN_OPS = [UopType.VFWADD, UopType.VFWSUB]
WIDEN2_OPS = [UopType.VFWADD_W, UopType.VFWSUB_W]
COMPARE_OPS = [UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGT, UopType.VMFGE]

# ==============================================================================
# 2. Payload Data Structures (vsc.randobj)
# ==============================================================================

@vsc.randobj
class UopCtrl:
    def __init__(self):
        self.lsrc_0 = vsc.rand_bit_t(5)
        self.lsrc_1 = vsc.rand_bit_t(5)
        self.ldest = vsc.rand_bit_t(5)
        self.vm = vsc.rand_bit_t(1)
        self.funct6 = vsc.rand_bit_t(6)
        self.funct3 = vsc.rand_bit_t(3)
        self.illegal = vsc.rand_bit_t(1)
        self.lsrcVal_0 = vsc.rand_bit_t(1)
        self.lsrcVal_1 = vsc.rand_bit_t(1)
        self.lsrcVal_2 = vsc.rand_bit_t(1)
        self.ldestVal = vsc.rand_bit_t(1)
        self.rdVal = vsc.rand_bit_t(1)
        self.load = vsc.rand_bit_t(1)
        self.store = vsc.rand_bit_t(1)
        self.arith = vsc.rand_bit_t(1)
        self.crossLane = vsc.rand_bit_t(1)
        self.alu = vsc.rand_bit_t(1)
        self.mul = vsc.rand_bit_t(1)
        self.fp = vsc.rand_bit_t(1)
        self.div = vsc.rand_bit_t(1)
        self.fixP = vsc.rand_bit_t(1)
        self.redu = vsc.rand_bit_t(1)
        self.mask = vsc.rand_bit_t(1)
        self.perm = vsc.rand_bit_t(1)
        self.vfadd = vsc.rand_bit_t(1)
        self.vfma = vsc.rand_bit_t(1)
        self.vfcvt = vsc.rand_bit_t(1)
        self.widen = vsc.rand_bit_t(1)
        self.widen2 = vsc.rand_bit_t(1)
        self.narrow = vsc.rand_bit_t(1)
        self.narrow_to_1 = vsc.rand_bit_t(1)

@vsc.randobj
class UopCsr:
    def __init__(self):
        self.vstart = vsc.rand_bit_t(9)
        self.vl = vsc.rand_bit_t(10)
        self.vxrm = vsc.rand_bit_t(2)
        self.frm = vsc.rand_bit_t(3)
        self.vlmul = vsc.rand_bit_t(3)
        self.vsew = vsc.rand_bit_t(3)
        self.vill = vsc.rand_bit_t(1)
        self.ma = vsc.rand_bit_t(1)
        self.ta = vsc.rand_bit_t(1)

@vsc.randobj
class Uop:
    def __init__(self):
        self.ctrl = vsc.rand_attr(UopCtrl())
        self.csr = vsc.rand_attr(UopCsr())
        self.robIdx_flag = vsc.rand_bit_t(1)
        self.robIdx_value = vsc.rand_bit_t(8)
        self.veewVd = vsc.rand_bit_t(3)
        self.uopIdx = vsc.rand_bit_t(3)
        self.uopEnd = vsc.rand_bit_t(1)
        self.lsrcUop_0 = vsc.rand_bit_t(5)
        self.lsrcUop_1 = vsc.rand_bit_t(5)
        self.lsrcValUop_0 = vsc.rand_bit_t(1)
        self.lsrcValUop_1 = vsc.rand_bit_t(1)
        self.lsrcValUop_2 = vsc.rand_bit_t(1)
        self.ldestUop = vsc.rand_bit_t(5)
        self.lmaskValUop = vsc.rand_bit_t(1)
        self.ldestValUop = vsc.rand_bit_t(1)

@vsc.randobj
class InputPayload:
    def __init__(self):
        self.uop = vsc.rand_attr(Uop())
        self.vs1 = vsc.rand_bit_t(64)
        self.vs2 = vsc.rand_bit_t(64)
        self.vs3 = vsc.rand_bit_t(64)
        self.rs1 = vsc.rand_bit_t(64)

@vsc.randobj
class SewInput:
    def __init__(self):
        self.oneHot_0 = vsc.rand_bit_t(1)
        self.oneHot_1 = vsc.rand_bit_t(1)
        self.oneHot_2 = vsc.rand_bit_t(1)
        self.oneHot_3 = vsc.rand_bit_t(1)

@vsc.randobj
class OutputPayload:
    def __init__(self):
        self.vd = vsc.rand_bit_t(64)
        self.fflags_0 = vsc.rand_bit_t(5)
        self.fflags_1 = vsc.rand_bit_t(5)
        self.fflags_2 = vsc.rand_bit_t(5)
        self.fflags_3 = vsc.rand_bit_t(5)
        self.rd_valid = vsc.rand_bit_t(1)
        self.rd_bits = vsc.rand_bit_t(64)
        self.uop = vsc.rand_attr(Uop())
        self.transaction_id = 0

# ==============================================================================
# 3. Transaction Class
# ==============================================================================

@vsc.randobj
class vfadd_xaction:
    """
    Main transaction class for VFAdd.
    """
    def __init__(self):
        self.transaction_id = 0
        self.reporter = get_reporter()
        
        # --- Random Variables (High Level) ---
        self.uop_type = vsc.rand_enum_t(UopType)
        self.sew_type = vsc.rand_enum_t(SewType)
        self.funct3_type = vsc.rand_enum_t(Funct3Type) # Added: To select VV or VF
        self.rd = vsc.rand_bit_t(5)                    # Added: Destination Register Index
        
        # --- Validity Control ---
        self.is_legal = vsc.rand_bit_t(1)

        # --- Floating Point Generation (The Bridge) ---
        # Use randsz_list_t to dynamically size the list based on VL
        # Initialize with a default size to avoid "List size: 0" errors during constraint construction
        self.fp_pairs = vsc.randsz_list_t(vsc.rand_attr(FpPair())) # Just for Constraint Elaboration
        self.fp_pairs_list = list()
        # Manually initialize the list with 4 elements to avoid empty list issues during constraint elaboration
        for _ in range(4):
            self.fp_pairs.append(vsc.rand_attr(FpPair()))
        
        # --- Payload Structures (Low Level Signals) ---
        self.payload = vsc.rand_attr(InputPayload())
        self.sew = vsc.rand_attr(SewInput())
        
        self.valid = vsc.rand_bit_t(1)
        self.delay = vsc.rand_uint8_t()
        
        # --- Metadata ---
        self.timestamp = 0

        # --- Derived Fields (Non-random) ---
        self.uop_name = "vfadd"

    # --- Constraints ---
    
    @vsc.constraint
    def list_size_c(self):
        """
        Constrain the number of FP pairs based on SEW and Wideness.
        Assuming a 64-bit data path:
        - FP32 (Normal): 2 elements
        - FP16/BF16 (Normal): 4 elements
        - FP16/BF16 (Widen): 2 elements (limited by 2*SEW output/operand)
        """

        
        # Explicitly bound the size to avoid PyVSC "max size exceeded" errors
        self.fp_pairs.size <= 4
        with vsc.if_then(self.sew_type == SewType.FP32):
            self.fp_pairs.size == 2
        with vsc.else_if(self.sew_type.inside(vsc.rangelist(SewType.FP16, SewType.BF16))):
            # Check if it is any widen operation
            with vsc.if_then(self.uop_type.inside(vsc.rangelist(*WIDEN_OPS, *WIDEN2_OPS))):
                self.fp_pairs.size == 2
            with vsc.else_then():
                self.fp_pairs.size == 4

    @vsc.constraint
    def fp_bridge_c(self):
        # 1. 基础精度约束 (保持不变)
        with vsc.foreach(self.fp_pairs, idx=True) as i:
            # VS1/RS1 (a) is always SEW
            with vsc.if_then(self.sew_type == SewType.FP32):
                self.fp_pairs[i].a.precision == FpPrecision.FP32
            with vsc.else_if(self.sew_type == SewType.FP16):
                self.fp_pairs[i].a.precision == FpPrecision.FP16
            with vsc.else_if(self.sew_type == SewType.BF16):
                self.fp_pairs[i].a.precision == FpPrecision.BF16
            
            # VS2 (b) depends on Widen W ops
            with vsc.if_then(self.uop_type.inside(vsc.rangelist(*WIDEN2_OPS))):
                self.fp_pairs[i].b.precision == FpPrecision.FP32
            with vsc.else_then():
                self.fp_pairs[i].b.precision == self.fp_pairs[i].a.precision

        # 2. 新增：Vector-Scalar 模式下的一致性约束
        with vsc.if_then(self.funct3_type == Funct3Type.OPFVF):
            # 强制所有 Pair 的 'a' 端（即 Scalar 端）数值相等
            # 只需要让后续的元素等于第一个元素即可
            with vsc.foreach(self.fp_pairs, idx=True) as i:
                with vsc.if_then(i > 0):
                    self.fp_pairs[i].a.sign == self.fp_pairs[0].a.sign
                    self.fp_pairs[i].a.exp  == self.fp_pairs[0].a.exp
                    self.fp_pairs[i].a.man  == self.fp_pairs[0].a.man

    @vsc.constraint
    def diversity_c(self):
        # Encourage diversity across elements within a 64-bit lane
        with vsc.foreach(self.fp_pairs, idx=True) as i:
            with vsc.if_then(i > 0):
                # For vector-scalar mode, 'a' is broadcast by spec; skip diversity on 'a'
                with vsc.if_then(self.funct3_type != Funct3Type.OPFVF):
                    vsc.soft(self.fp_pairs[i].a.category != self.fp_pairs[i-1].a.category)
                    vsc.soft(self.fp_pairs[i].a.exp != self.fp_pairs[i-1].a.exp)
                    vsc.soft(self.fp_pairs[i].a.man != self.fp_pairs[i-1].a.man)

                # Always encourage diversity on VS2 (b)
                vsc.soft(self.fp_pairs[i].b.category != self.fp_pairs[i-1].b.category)
                vsc.soft(self.fp_pairs[i].b.exp != self.fp_pairs[i-1].b.exp)
                vsc.soft(self.fp_pairs[i].b.man != self.fp_pairs[i-1].b.man)

            # Prefer a and b of the same element to differ to improve stimulus variety
            vsc.soft(self.fp_pairs[i].a.category != self.fp_pairs[i].b.category)
    @vsc.constraint
    def basic_c(self):
        # Basic legality knobs kept in solver
        vsc.soft(self.is_legal == 1)
        vsc.soft(self.valid == 1)
        # delay: soft constraint, prefer [0,3]
        vsc.soft(self.delay <= 3)
        vsc.dist(self.delay, [
            vsc.weight(vsc.rng(0, 3), 90),
            vsc.weight(vsc.rng(4, 5), 10)
        ])

        # Constraint for funct3_type (VV vs VF)
        # Most ops support both VV and VF
        with vsc.if_then(self.uop_type.inside(vsc.rangelist(
            UopType.VFADD, UopType.VFSUB, UopType.VFRSUB, 
            UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W,
            UopType.VFMIN, UopType.VFMAX, 
            UopType.VFSGNJ, UopType.VFSGNJN, UopType.VFSGNJX,
            UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGT, UopType.VMFGE
        ))):
            self.funct3_type.inside(vsc.rangelist(Funct3Type.OPFVV, Funct3Type.OPFVF))
        
        # Special cases
        with vsc.if_then(self.uop_type == UopType.VFMV_S_F):
            self.funct3_type == Funct3Type.OPFVF
        with vsc.if_then(self.uop_type == UopType.VFMV_F_S):
            self.funct3_type == Funct3Type.OPFVV # Spec specific
        with vsc.if_then(self.uop_type == UopType.VFMV): # vfmv.v.v
             self.funct3_type == Funct3Type.OPFVV # Usually encoded as OPMVV or similar, but here assuming OPFVV/OPMVV context

        # uopIdx selection: for widen/widen2 with 16-bit inputs, select low/high 32-bit half
        with vsc.if_then(self.uop_type.inside(vsc.rangelist(UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W))):
            with vsc.if_then(self.sew_type.inside(vsc.rangelist(SewType.FP16, SewType.BF16))):
                self.payload.uop.uopIdx.inside(vsc.rangelist(0, 1))
            with vsc.else_then():
                self.payload.uop.uopIdx == 0
        with vsc.else_then():
            self.payload.uop.uopIdx == 0

    @vsc.constraint
    def widen_c(self):
        # Widen ops cannot be FP32 (output would be FP64 which is unsupported)
        with vsc.if_then(self.uop_type.inside(vsc.rangelist(*WIDEN_OPS))):
            self.sew_type != SewType.FP32
        with vsc.if_then(self.uop_type.inside(vsc.rangelist(*WIDEN2_OPS))):
            self.sew_type != SewType.FP32

    @vsc.constraint
    def special_ops_c(self):
        # vfmv.f.s: vs1 must be 0 (spec 16.2)
        with vsc.if_then(self.uop_type == UopType.VFMV_F_S):
            self.payload.vs1 == 0
        # vfmv.s.f: vs2 must be 0 (spec 16.2)
        with vsc.if_then(self.uop_type == UopType.VFMV_S_F):
            self.payload.vs2 == 0
        with vsc.if_then(self.uop_type == UopType.VFMV):
            self.payload.uop.ctrl.vm == 1


    # mapping_c and solve_order_c removed: mapping is done in decode_to_payload
        # vsc.solve_order(self.is_legal, self.payload) # InputPayload object not supported in solve_order

    # --- Methods ---

    def post_randomize(self):
        """
        Post-randomization updates.
        Pack generated FP values into vs1/vs2 and update name.
        """
        "Post-randomization processing"
        for i in range(len(self.fp_pairs)):
            self.fp_pairs[i].post_randomize()
            self.fp_pairs_list.append(self.fp_pairs[i])
        
        self.uop_name = self.uop_type.name.lower()
        # Decode high-level knobs to low-level payload/sew/ctrl bits
        self.decode_to_payload()
        self.pack_to_bits()

    def decode_to_payload(self):
        """Decode uop_type/sew_type/is_legal into payload/sew/ctrl fields.
        """
        # SEW Mapping
        self.sew.oneHot_0 = int(self.sew_type == SewType.BF16)
        self.sew.oneHot_1 = int(self.sew_type == SewType.FP16)
        self.sew.oneHot_2 = int(self.sew_type == SewType.FP32)
        self.sew.oneHot_3 = 0  # FP64 not supported

        # Uop Control Mapping (only when is_legal)
        if int(self.is_legal) == 1:
            ctrl = self.payload.uop.ctrl
            ctrl.fp = 1
            ctrl.arith = 1
            ctrl.vfadd = 1
            ctrl.illegal = 0
            
            # Map RD (Destination Index)
            ctrl.ldest = self.rd

            # Default clear for other flags that might confuse DUT
            ctrl.widen = int(self.uop_type in WIDEN_OPS)
            ctrl.widen2 = int(self.uop_type in WIDEN2_OPS)

            # Funct6 Mapping
            # 直接按原始 mapping_c 的枚举编码来写
            if self.uop_type == UopType.VFADD:
                ctrl.funct6 = 0b000000
            elif self.uop_type == UopType.VFSUB:
                ctrl.funct6 = 0b000010
            elif self.uop_type == UopType.VFRSUB:
                ctrl.funct6 = 0b100111
            elif self.uop_type == UopType.VFWADD:
                ctrl.funct6 = 0b110000
            elif self.uop_type == UopType.VFWSUB:
                ctrl.funct6 = 0b110010
            elif self.uop_type == UopType.VFWADD_W:
                ctrl.funct6 = 0b110100
            elif self.uop_type == UopType.VFWSUB_W:
                ctrl.funct6 = 0b110110
            elif self.uop_type == UopType.VFMIN:
                ctrl.funct6 = 0b000100
            elif self.uop_type == UopType.VFMAX:
                ctrl.funct6 = 0b000110
            elif self.uop_type == UopType.VFSGNJ:
                ctrl.funct6 = 0b001000
            elif self.uop_type == UopType.VFSGNJN:
                ctrl.funct6 = 0b001001
            elif self.uop_type == UopType.VFSGNJX:
                ctrl.funct6 = 0b001010
            elif self.uop_type == UopType.VMFEQ:
                ctrl.funct6 = 0b011000
            elif self.uop_type == UopType.VMFNE:
                ctrl.funct6 = 0b011100
            elif self.uop_type == UopType.VMFLT:
                ctrl.funct6 = 0b011011
            elif self.uop_type == UopType.VMFLE:
                ctrl.funct6 = 0b011001
            elif self.uop_type == UopType.VMFGT:
                ctrl.funct6 = 0b011101
            elif self.uop_type == UopType.VMFGE:
                ctrl.funct6 = 0b011111
            elif self.uop_type == UopType.VFMV:
                ctrl.funct6 = 0b010111
            elif self.uop_type == UopType.VFMV_F_S:
                ctrl.funct6 = 0b010000
            elif self.uop_type == UopType.VFMV_S_F:
                ctrl.funct6 = 0b010000

            # Funct3 Mapping
            ctrl.funct3 = self.funct3_type

        # Uop Meta
        self.payload.uop.uopEnd = 1

    def set_from_payload(self, payload, sew):
        """
        Reconstruct transaction state from monitored payload and SEW.
        This allows using report() and other methods on monitored data.
        """
        self.payload = payload
        self.sew = sew
        
        # 1. Decode SEW
        if sew.oneHot_2:
            self.sew_type = SewType.FP32
        elif sew.oneHot_1:
            self.sew_type = SewType.FP16
        elif sew.oneHot_0:
            self.sew_type = SewType.BF16
        else:
            self.sew_type = SewType.FP32
            
        # 2. Decode Uop Type
        funct6 = payload.uop.ctrl.funct6
        funct3 = payload.uop.ctrl.funct3
        # 3. Map funct6 to UopType and func3 UopType
        candidates = FUNCT6_UOP_MAP.get(funct6, [])
        if len(candidates) == 1:
            self.uop_type = candidates[0]
        elif len(candidates) > 1:
            # Disambiguate using funct3
            # Currently only VFMV_F_S vs VFMV_S_F share funct6
            if UopType.VFMV_S_F in candidates and funct3 == Funct3Type.OPFVF:
                self.uop_type = UopType.VFMV_S_F
            elif UopType.VFMV_F_S in candidates and funct3 == Funct3Type.OPFVV:
                self.uop_type = UopType.VFMV_F_S
            else:
                # Fallback or other collisions if any
                self.uop_type = candidates[0]
        else:
            # Unknown funct6
            pass
            
        if hasattr(self, 'uop_type'):
            self.uop_name = self.uop_type.name.lower()

        try:
            self.funct3_type = Funct3Type(int(funct3))
        except ValueError:
            self.funct3_type = Funct3Type.OPFVV
        
        # 3. Unpack bits to FpPairs (Optional, for detailed reporting)
        # self.reconstruct() 

    def reconstruct(self):
        """
        Reconstruct fp_pairs from payload.vs1 and payload.vs2.
        This populates self.fp_pairs with FpPair objects containing decoded FpElements.
        """
        self.fp_pairs = [] # Clear existing list
        self.fp_pairs_list = [] # Clear existing list
        
        # Determine widths and precision
        width_a = 16
        width_b = 16
        prec_a = FpPrecision.FP16
        prec_b = FpPrecision.FP16
        
        if self.sew_type == SewType.FP32:
            width_a = 32
            width_b = 32
            prec_a = FpPrecision.FP32
            prec_b = FpPrecision.FP32
        elif self.sew_type == SewType.BF16:
            prec_a = FpPrecision.BF16
            prec_b = FpPrecision.BF16
            
        # Handle Widen Ops
        if self.uop_type in WIDEN2_OPS:
            width_b = 32
            prec_b = FpPrecision.FP32
    
        # Wait, InputPayload vs1/vs2 are 64-bit. 
        # If VLEN is larger, we might need to adjust InputPayload definition or loop count.
        # Assuming 64-bit data path for now as per InputPayload definition.
        
        max_bits = 64 
        raw_vs1 = self.payload.vs1
        raw_vs2 = self.payload.vs2
        raw_rs1 = self.payload.rs1
        idx = int(self.payload.uop.uopIdx)
        base_shift_a = 0
        base_shift_b = 0
        if width_a == 16 and self.uop_type in [UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W]:
            base_shift_a = 32 * idx
        if width_b == 16 and self.uop_type in [UopType.VFWADD, UopType.VFWSUB]:
            base_shift_b = 32 * idx
        if (self.sew_type in [SewType.FP16, SewType.BF16]) and (self.uop_type in WIDEN_OPS or self.uop_type in WIDEN2_OPS):
            num_elements = 2
        else:
            num_elements = max_bits // (width_a if self.funct3_type != Funct3Type.OPFVF else width_b)
        for i in range(num_elements):
            if self.funct3_type == Funct3Type.OPFVF or self.uop_type == UopType.VFMV_S_F:
                val_a = raw_rs1 & ((1 << width_a) - 1)
            else:
                val_a = (raw_vs1 >> (base_shift_a + i * width_a)) & ((1 << width_a) - 1)
            val_b = (raw_vs2 >> (base_shift_b + i * width_b)) & ((1 << width_b) - 1)
            
            self.reporter.report_msg("vfadd_xaction.reconstruct", f"Pair {i}: raw_vs1={raw_vs1:x}, val_a={val_a:x}, val_b={val_b:x}", ReportLevel.MEDIUM)

            # Create and Unpack Pair
            pair = FpPair()
            pair.a.precision = prec_a
            pair.b.precision = prec_b
            pair.unpack(val_a, val_b)
            self.fp_pairs_list.append(pair)

    def pack_to_bits(self):
        # Determine widths
        width_a = 16
        width_b = 16
        if self.sew_type == SewType.FP32:
            width_a = 32
            width_b = 32
        
        # Check for Widen W ops (VS2 is wide)
        # We can check the enum value directly or use the list if available
        # Since WIDEN2_OPS is in global scope:
        if self.uop_type in WIDEN2_OPS:
            width_b = 32

        vs1_val = 0
        vs2_val = 0
        rs1_val = 0
        base_shift_a = 0
        base_shift_b = 0
        idx = int(self.payload.uop.uopIdx)
        if width_a == 16 and self.uop_type in [UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W]:
            base_shift_a = 32 * idx
        if width_b == 16 and self.uop_type in [UopType.VFWADD, UopType.VFWSUB]:
            base_shift_b = 32 * idx
        
        # Pack FP values
        for i in range(self.fp_pairs.size):
            a_bits = self.fp_pairs[i].a.val_bits
            b_bits = self.fp_pairs[i].b.val_bits
            
            # VS2 is always Vector (from pair.b)
            vs2_val |= (b_bits << (base_shift_b + i * width_b))
            
            if self.funct3_type == Funct3Type.OPFVF or self.uop_type in [UopType.VFMV, UopType.VFMV_S_F]:
                # Scalar Mode: Pack into RS1
                if i == 0:
                    # Apply NaN-Boxing if required by spec (Standard RISC-V F-extension behavior)
                    # Assuming rs1 is 64-bit wide in payload
                    if self.sew_type == SewType.FP32:
                        # FP32 in 64-bit reg: Upper 32 bits are 1s
                        rs1_val = 0xFFFFFFFF00000000 | a_bits
                    elif self.sew_type in [SewType.FP16, SewType.BF16]:
                        # FP16/BF16 in 64-bit reg: Upper 48 bits are 1s
                        rs1_val = 0xFFFFFFFFFFFF0000 | a_bits
                    else:
                        rs1_val = a_bits
            else:
                # Vector Mode: Pack into VS1
                vs1_val |= (a_bits << (base_shift_a + i * width_a))
            
        self.payload.vs1 = vs1_val
        self.payload.vs2 = vs2_val
        self.payload.rs1 = rs1_val # Set RS1

    def report(self, detail=False) -> str:
        """
        Generate a formatted table report of the transaction using tabulate.
        Args:
            detail (bool): If True, include high-level reconstructed information (FP Pairs).
        """
        # 1. Interface / Low-Level Information
        rows = [
            ["Tx ID", f"{self.transaction_id}"],
            ["SampleTime", f"{self.timestamp}"],
            # --- Payload Data ---
            ["VS1 Data", f"0x{int(self.payload.vs1):016x}"],
            ["VS2 Data", f"0x{int(self.payload.vs2):016x}"],
            ["RS1 Data", f"0x{int(self.payload.rs1):016x}"],
            ["VS3 Data", f"0x{int(self.payload.vs3):016x}"],
            # --- SEW Input ---
            ["SEW.OneHot_0 (BF16)", f"{int(self.sew.oneHot_0)}"],
            ["SEW.OneHot_1 (FP16)", f"{int(self.sew.oneHot_1)}"],
            ["SEW.OneHot_2 (FP32)", f"{int(self.sew.oneHot_2)}"],
            ["SEW.OneHot_3 (FP64)", f"{int(self.sew.oneHot_3)}"],
            # --- Uop CSR ---
            ["CSR.VL", f"{int(self.payload.uop.csr.vl)}"],
            ["CSR.VSTART", f"{int(self.payload.uop.csr.vstart)}"],
            ["CSR.VXRM", f"{int(self.payload.uop.csr.vxrm)}"],
            ["CSR.FRM", f"{int(self.payload.uop.csr.frm)}"],
            ["CSR.VLMUL", f"{int(self.payload.uop.csr.vlmul)}"],
            ["CSR.VSEW", f"{int(self.payload.uop.csr.vsew)}"],
            ["CSR.VILL", f"{int(self.payload.uop.csr.vill)}"],
            ["CSR.MA", f"{int(self.payload.uop.csr.ma)}"],
            ["CSR.TA", f"{int(self.payload.uop.csr.ta)}"],
            # --- Uop Ctrl ---
            ["CTRL.FUNCT6", f"0b{int(self.payload.uop.ctrl.funct6):06b}"],
            ["CTRL.FUNCT3", f"0b{int(self.payload.uop.ctrl.funct3):03b}"],
            ["CTRL.VM", f"{int(self.payload.uop.ctrl.vm)}"],
            ["CTRL.LDEST", f"{int(self.payload.uop.ctrl.ldest)}"],
            ["CTRL.LSRC_0", f"{int(self.payload.uop.ctrl.lsrc_0)}"],
            ["CTRL.LSRC_1", f"{int(self.payload.uop.ctrl.lsrc_1)}"],
            ["CTRL.WIDEN", f"{int(self.payload.uop.ctrl.widen)}"],
            ["CTRL.WIDEN2", f"{int(self.payload.uop.ctrl.widen2)}"],
            ["CTRL.NARROW", f"{int(self.payload.uop.ctrl.narrow)}"],
            ["CTRL.NARROW_TO_1", f"{int(self.payload.uop.ctrl.narrow_to_1)}"],
            ["CTRL.VFADD", f"{int(self.payload.uop.ctrl.vfadd)}"],
            ["CTRL.VFMA", f"{int(self.payload.uop.ctrl.vfma)}"],
            ["CTRL.VFCVT", f"{int(self.payload.uop.ctrl.vfcvt)}"],
            ["CTRL.FP", f"{int(self.payload.uop.ctrl.fp)}"],
            ["CTRL.ARITH", f"{int(self.payload.uop.ctrl.arith)}"],
            ["CTRL.ILLEGAL", f"{int(self.payload.uop.ctrl.illegal)}"],
            # Other flags
            ["CTRL.LOAD", f"{int(self.payload.uop.ctrl.load)}"],
            ["CTRL.STORE", f"{int(self.payload.uop.ctrl.store)}"],
            ["CTRL.ALU", f"{int(self.payload.uop.ctrl.alu)}"],
            ["CTRL.MUL", f"{int(self.payload.uop.ctrl.mul)}"],
            ["CTRL.DIV", f"{int(self.payload.uop.ctrl.div)}"],
            ["CTRL.FIXP", f"{int(self.payload.uop.ctrl.fixP)}"],
            ["CTRL.REDU", f"{int(self.payload.uop.ctrl.redu)}"],
            ["CTRL.MASK", f"{int(self.payload.uop.ctrl.mask)}"],
            ["CTRL.PERM", f"{int(self.payload.uop.ctrl.perm)}"],
            ["CTRL.CROSSLANE", f"{int(self.payload.uop.ctrl.crossLane)}"],
        ]
        
        # 2. High-Level Information (Optional)
        if detail:
            rows.extend([
                ["---", "---"],
                ["HL.Uop Type", f"{self.uop_name.upper()}"],
                ["HL.Mode", f"{self.funct3_type.name}"],
                ["HL.SEW", f"{self.sew_type.name}"],
                ["HL.RD Idx", f"{self.rd}"],
                ["HL.Legal", f"{int(self.is_legal)}"],
            ])
        
        # Generate table
        table_str = tabulate(rows, headers=["Field", "Value"], tablefmt="psql")
        
        # Report Every FpPair if detail is True
        if detail:
            for i in range(len(self.fp_pairs_list)):
                pair_report = self.fp_pairs_list[i].report()
                table_str += f"\n\nFP Pair {i}:\n{pair_report}"
        return f"\n{table_str}"
