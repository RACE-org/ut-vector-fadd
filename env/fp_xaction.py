"""
Floating Point Transaction and Generation Logic.

This module defines classes to generate constrained floating-point numbers
and pairs of numbers with specific relationships (exponent difference,
mantissa difference) to target verification corner cases.
"""

import vsc
from enum import IntEnum
from typing import Any
from tabulate import tabulate
import numpy as np
import ml_dtypes
from env.common.prj_reporter import get_reporter, ReportLevel

# ==============================================================================
# 1. Enums
# ==============================================================================

class FpPrecision(IntEnum):
    FP16 = 0 # 1-5-10
    BF16 = 1 # 1-8-7
    FP32 = 2 # 1-8-23

class FpCategory(IntEnum):
    ZERO = 0
    NORMAL = 1
    SUBNORMAL = 2
    INFINITY = 3
    NAN = 4

class ExpRelation(IntEnum):
    EQUAL = 0
    CLOSE = 1 # diff = 1
    FAR = 2   # diff > 1
    RANDOM = 3

class ManRelation(IntEnum):
    EQUAL = 0
    SMALL_DIFF = 1 # diff <= 2
    LARGE_DIFF = 2 # diff > 2
    RANDOM = 3

class SignRelation(IntEnum):
    SAME = 0
    OPPOSITE = 1

# ==============================================================================
# 2. Single Floating Point Element
# ==============================================================================

@vsc.randobj
class FpElement:
    def __init__(self):
        # Reporter = get_reporter()
        self.reporter = get_reporter()
        # Knobs
        self.precision = vsc.rand_enum_t(FpPrecision)
        self.category = vsc.rand_enum_t(FpCategory)
        
        # Components
        self.sign = vsc.rand_bit_t(1)
        self.exp = vsc.rand_uint8_t()  # Max 8 bits for FP32/BF16
        self.man = vsc.rand_uint32_t() # Max 23 bits for FP32
        
        # Output
        self.val_bits = 0 # Calculated in post_randomize

        # Internal helpers for constraints
        # Optimization: Removed exp_max and man_mask to reduce solver variables
        self.bias = vsc.rand_uint8_t()

    @vsc.constraint
    def config_c(self):
        # Define width constants based on precision
        with vsc.if_then(self.precision == FpPrecision.FP16):
            self.bias == 15
        with vsc.else_if(self.precision == FpPrecision.BF16):
            self.bias == 127
        with vsc.else_if(self.precision == FpPrecision.FP32):
            self.bias == 127

    @vsc.constraint
    def category_c(self):
        # Zero: Exp=0, Man=0
        with vsc.if_then(self.category == FpCategory.ZERO):
            self.exp == 0
            self.man == 0
        
        # Subnormal: Exp=0, Man!=0
        with vsc.if_then(self.category == FpCategory.SUBNORMAL):
            self.exp == 0
            self.man > 0
            # Man mask check
            with vsc.if_then(self.precision == FpPrecision.FP16):
                self.man <= 0x3FF
            with vsc.else_if(self.precision == FpPrecision.BF16):
                self.man <= 0x7F
            with vsc.else_if(self.precision == FpPrecision.FP32):
                self.man <= 0x7FFFFF

        # Normal: 0 < Exp < Max
        with vsc.if_then(self.category == FpCategory.NORMAL):
            self.exp > 0
            with vsc.if_then(self.precision == FpPrecision.FP16):
                self.exp < 31
                self.man <= 0x3FF
            with vsc.else_if(self.precision == FpPrecision.BF16):
                self.exp < 255
                self.man <= 0x7F
            with vsc.else_if(self.precision == FpPrecision.FP32):
                self.exp < 255
                self.man <= 0x7FFFFF

        # Infinity: Exp=Max, Man=0
        with vsc.if_then(self.category == FpCategory.INFINITY):
            self.man == 0
            with vsc.if_then(self.precision == FpPrecision.FP16):
                self.exp == 31
            with vsc.else_if(self.precision == FpPrecision.BF16):
                self.exp == 255
            with vsc.else_if(self.precision == FpPrecision.FP32):
                self.exp == 255

        # NaN: Exp=Max, Man!=0
        with vsc.if_then(self.category == FpCategory.NAN):
            self.man > 0
            with vsc.if_then(self.precision == FpPrecision.FP16):
                self.exp == 31
                self.man <= 0x3FF
            with vsc.else_if(self.precision == FpPrecision.BF16):
                self.exp == 255
                self.man <= 0x7F
            with vsc.else_if(self.precision == FpPrecision.FP32):
                self.exp == 255
                self.man <= 0x7FFFFF

    @vsc.constraint
    def normal_exp_dist_c(self):
        """For NORMAL numbers, spread exponent over low/mid/high ranges."""
        with vsc.if_then(self.category == FpCategory.NORMAL):
            # FP32: exp in [1, 254]
            with vsc.if_then(self.precision == FpPrecision.FP32):
                vsc.dist(self.exp, [
                    vsc.weight(vsc.rng(1, 50), 30),
                    vsc.weight(vsc.rng(51, 150), 40),
                    vsc.weight(vsc.rng(151, 254), 30)
                ])

            # FP16: exp in [1, 30]
            with vsc.else_if(self.precision == FpPrecision.FP16):
                vsc.dist(self.exp, [
                    vsc.weight(vsc.rng(1, 10), 30),
                    vsc.weight(vsc.rng(11, 20), 40),
                    vsc.weight(vsc.rng(21, 30), 30)
                ])

            # BF16: exp range is same as FP32
            with vsc.else_if(self.precision == FpPrecision.BF16):
                vsc.dist(self.exp, [
                    vsc.weight(vsc.rng(1, 50), 30),
                    vsc.weight(vsc.rng(51, 150), 40),
                    vsc.weight(vsc.rng(151, 254), 30)
                ])

    @vsc.constraint
    def normal_man_dist_c(self):
        """For NORMAL numbers, spread mantissa over low/mid/high ranges."""
        with vsc.if_then(self.category == FpCategory.NORMAL):
            # FP32: 23-bit mantissa [0, 0x7FFFFF]
            with vsc.if_then(self.precision == FpPrecision.FP32):
                vsc.dist(self.man, [
                    vsc.weight(vsc.rng(0x000001, 0x0FFFFF), 30),
                    vsc.weight(vsc.rng(0x100000, 0x5FFFFF), 40),
                    vsc.weight(vsc.rng(0x600000, 0x7FFFFF), 30)
                ])

            # FP16: 10-bit mantissa [0, 0x3FF]
            with vsc.else_if(self.precision == FpPrecision.FP16):
                vsc.dist(self.man, [
                    vsc.weight(vsc.rng(0x000, 0x0FF), 30),
                    vsc.weight(vsc.rng(0x100, 0x2FF), 40),
                    vsc.weight(vsc.rng(0x300, 0x3FF), 30)
                ])

            # BF16: 7-bit mantissa [0, 0x7F]
            with vsc.else_if(self.precision == FpPrecision.BF16):
                vsc.dist(self.man, [
                    vsc.weight(vsc.rng(0x00, 0x1F), 30),
                    vsc.weight(vsc.rng(0x20, 0x5F), 40),
                    vsc.weight(vsc.rng(0x60, 0x7F), 30)
                ])

    def post_randomize(self):
        """Pack the components into the final integer representation."""
        self.pack_to_bits()

    def pack_to_bits(self):
        """Decode the generated bits into components."""
        # Pack bits based on precision
        s = self.sign
        e = self.exp
        m = self.man
        
        if self.precision == FpPrecision.FP32:
            self.val_bits = (s << 31) | (e << 23) | m
        elif self.precision == FpPrecision.FP16:
            self.val_bits = (s << 15) | (e << 10) | m
        elif self.precision == FpPrecision.BF16:
            self.val_bits = (s << 15) | (e << 7) | m

    def get_float(self) -> Any:
        """Decode the generated bits into a numpy/ml_dtype floating point scalar."""
        # print(f"DEBUG: get_float val_bits={self.val_bits} precision={self.precision}")
        if self.precision == FpPrecision.FP32:
            return np.uint32(self.val_bits).view(np.float32)
        elif self.precision == FpPrecision.FP16:
            return np.uint16(self.val_bits).view(np.float16)
        elif self.precision == FpPrecision.BF16:
            return np.uint16(self.val_bits).view(ml_dtypes.bfloat16)
        return float('nan') 

    def unpack(self, val_int):
        """Unpack integer value into components based on precision."""
        self.val_bits = val_int
        if self.precision == FpPrecision.FP32:
            self.sign = (val_int >> 31) & 0x1
            self.exp  = (val_int >> 23) & 0xFF
            self.man  = val_int & 0x7FFFFF
        elif self.precision == FpPrecision.FP16:
            self.sign = (val_int >> 15) & 0x1
            self.exp  = (val_int >> 10) & 0x1F
            self.man  = val_int & 0x3FF
        elif self.precision == FpPrecision.BF16:
            self.sign = (val_int >> 15) & 0x1
            self.exp  = (val_int >> 7) & 0xFF
            self.man  = val_int & 0x7F
        
        # Unpack Category
        max_exp = 0
        if self.precision == FpPrecision.FP32:
            max_exp = 255
        elif self.precision == FpPrecision.FP16:
            max_exp = 31
        elif self.precision == FpPrecision.BF16:
            max_exp = 255

        if self.exp == 0:
            if self.man == 0:
                self.category = FpCategory.ZERO
            else:
                self.category = FpCategory.SUBNORMAL
        elif self.exp == max_exp:
            if self.man == 0:
                self.category = FpCategory.INFINITY
            else:
                self.category = FpCategory.NAN
        else:
            self.category = FpCategory.NORMAL
        
        return self
    
    def report(self) -> str:
        """
        Generate a formatted table report of the transaction using tabulate.
        """
        # Data rows
        rows = [
            ["Precision", FpPrecision(self.precision).name],
            ["Category", FpCategory(self.category).name],
            ["Sign", self.sign],
            ["Exponent", f"0x{self.exp:x}"],
            ["Mantissa", f"0x{self.man:x}"],
            ["Value Bits", f"0x{self.val_bits:08x}"],
            ["Float Value", str(self.get_float())]
        ]
        
        # Generate table
        table_str = tabulate(rows, headers=["Field", "Value"], tablefmt="psql")
        
        return f"\n{table_str}"

# ==============================================================================
# 3. Floating Point Pair (The "Bridge")
# ==============================================================================

@vsc.randobj
class FpPair:
    def __init__(self):
        self.reporter = get_reporter()
        self.a = vsc.rand_attr(FpElement())
        self.b = vsc.rand_attr(FpElement())
        
        # Relationship Knobs
        self.exp_relation = vsc.rand_enum_t(ExpRelation)
        self.man_relation = vsc.rand_enum_t(ManRelation)
        self.sign_relation = vsc.rand_enum_t(SignRelation)

        # Helper variables for signed difference
        self.exp_diff = vsc.rand_int16_t()
        self.man_diff = vsc.rand_int32_t()

    @vsc.constraint
    def diff_calc_c(self):
        # Use split constraints to avoid potential signed/unsigned mixing issues
        with vsc.if_then(self.exp_diff >= 0):
            (self.b.exp + self.a.bias) + self.exp_diff == (self.a.exp + self.b.bias)
        with vsc.else_then():
            (self.a.exp + self.b.bias) + (self.exp_diff * -1) == (self.b.exp + self.a.bias)

        with vsc.if_then(self.man_diff >= 0):
            self.b.man + self.man_diff == self.a.man
        with vsc.else_then():
            self.a.man + (self.man_diff * -1) == self.b.man

    @vsc.constraint
    def sign_c(self):
        with vsc.if_then(self.sign_relation == SignRelation.SAME):
            self.a.sign == self.b.sign
        with vsc.else_then():
            self.a.sign != self.b.sign

    @vsc.constraint
    def exp_c(self):
        # Compare true exponents: (exp - bias)
        
        with vsc.if_then(self.exp_relation == ExpRelation.EQUAL):
            self.exp_diff == 0
        
        with vsc.else_if(self.exp_relation == ExpRelation.CLOSE):
            # Diff is 1
            self.exp_diff.inside(vsc.rangelist(-1, 1))
            
        with vsc.else_if(self.exp_relation == ExpRelation.FAR):
            # Diff > 1
            self.exp_diff.inside(vsc.rangelist(vsc.rng(-4096, -2), vsc.rng(2, 4096)))

    @vsc.constraint
    def man_c(self):
        # Only applies if precisions are equal (enforced by consistency_c)
        with vsc.if_then(self.man_relation == ManRelation.EQUAL):
            self.man_diff == 0
            
        with vsc.else_if(self.man_relation == ManRelation.SMALL_DIFF):
            # Diff <= 2 and != 0
            self.man_diff.inside(vsc.rangelist(-2, -1, 1, 2))
            
        with vsc.else_if(self.man_relation == ManRelation.LARGE_DIFF):
            self.man_diff.inside(vsc.rangelist(vsc.rng(-10000000, -3), vsc.rng(3, 10000000)))

    def post_randomize(self):
        self.a.post_randomize()
        self.b.post_randomize()

    @staticmethod
    def _bias_for_precision(prec) -> int:
        try:
            p = prec if isinstance(prec, FpPrecision) else FpPrecision(int(prec))
        except Exception:
            return 127
        if p == FpPrecision.FP16:
            return 15
        return 127

    def _reconstruct_relationships(self):
        bias_a = self._bias_for_precision(getattr(self.a, "precision", None))
        bias_b = self._bias_for_precision(getattr(self.b, "precision", None))

        try:
            self.a.bias = bias_a
        except Exception:
            pass
        try:
            self.b.bias = bias_b
        except Exception:
            pass

        try:
            a_exp = int(getattr(self.a, "exp", 0))
            b_exp = int(getattr(self.b, "exp", 0))
            self.exp_diff = int((a_exp + bias_b) - (b_exp + bias_a))
        except Exception:
            self.exp_diff = 0

        ad = int(self.exp_diff)
        if ad == 0:
            self.exp_relation = ExpRelation.EQUAL
        elif abs(ad) == 1:
            self.exp_relation = ExpRelation.CLOSE
        else:
            self.exp_relation = ExpRelation.FAR

        try:
            a_man = int(getattr(self.a, "man", 0))
            b_man = int(getattr(self.b, "man", 0))
            self.man_diff = int(a_man - b_man)
        except Exception:
            self.man_diff = 0

        md = int(self.man_diff)
        if md == 0:
            self.man_relation = ManRelation.EQUAL
        elif abs(md) <= 2:
            self.man_relation = ManRelation.SMALL_DIFF
        else:
            self.man_relation = ManRelation.LARGE_DIFF

        try:
            sa = int(getattr(self.a, "sign", 0))
            sb = int(getattr(self.b, "sign", 0))
            self.sign_relation = SignRelation.SAME if sa == sb else SignRelation.OPPOSITE
        except Exception:
            self.sign_relation = SignRelation.SAME

    def unpack(self, val_a, val_b):
        """Unpack integer values into FpElements."""
        # Assuming precision is already set or inferred from context
        # If precision is not set, we might need to pass it or default it
        # Here we assume self.a.precision and self.b.precision are set correctly
        # by the caller (e.g. vfadd_xaction.reconstruct)
        self.a.unpack(val_a)
        self.b.unpack(val_b)
        self._reconstruct_relationships()
        return self
        
    def report(self) -> str:
        """
        Generate a formatted table report of the transaction using tabulate.
        """
        # Data rows
        rows = [
            ["Field", "A", "B"],
            ["Precision", FpPrecision(self.a.precision).name, FpPrecision(self.b.precision).name],
            ["Category", FpCategory(self.a.category).name, FpCategory(self.b.category).name],
            ["Sign", self.a.sign, self.b.sign],
            ["Exponent", f"0x{self.a.exp:x}", f"0x{self.b.exp:x}"],
            ["Mantissa", f"0x{self.a.man:x}", f"0x{self.b.man:x}"],
            ["Value Bits", f"0x{self.a.val_bits:08x}", f"0x{self.b.val_bits:08x}"],
            ["Float Value", str(self.a.get_float()), str(self.b.get_float())]
        ]

        # Generate table
        table_str = tabulate(rows, headers=["OPA", "OPB"], tablefmt="psql")
        return f"\n{table_str}"
