from env.fp_xaction import ExpRelation, FpCategory, FpPrecision, ManRelation, SignRelation
from env.vfadd_xaction import Funct3Type, SewType, UopType
from tests.funcov_global import get_cov_group

class VFAddCovWrap:
    def __init__(self):
        self.groups = {
            "COMMON": get_cov_group("COMMON"),
            "ELEMENT": get_cov_group("ELEMENT"),
            "FADD_SUB": get_cov_group("FADD_SUB"),
            "WIDEN": get_cov_group("WIDEN"),
            "FCMP": get_cov_group("FCMP"),
            "MINMAX": get_cov_group("MINMAX"),
            "SIGN": get_cov_group("SIGN"),
            "FMV": get_cov_group("FMV"),
        }
        self._input_tx = None
        self.lane_idx = 0

        self._ensure_groups_defined()

    def _ensure_groups_defined(self):
        if self._is_group_empty(self.groups["COMMON"]):
            self._define_common_points()
        if self._is_group_empty(self.groups["ELEMENT"]):
            self._define_element_points()
        if self._is_group_empty(self.groups["FADD_SUB"]):
            self._define_fadd_sub_points()
        if self._is_group_empty(self.groups["WIDEN"]):
            self._define_widen_points()
        if self._is_group_empty(self.groups["FCMP"]):
            self._define_fcmp_points()
        if self._is_group_empty(self.groups["MINMAX"]):
            self._define_minmax_points()
        if self._is_group_empty(self.groups["SIGN"]):
            self._define_sign_points()
        if self._is_group_empty(self.groups["FMV"]):
            self._define_fmv_points()

    @staticmethod
    def _is_group_empty(g) -> bool:
        points = getattr(g, "cov_points", None)
        if points is None:
            return True
        try:
            return len(points) == 0
        except Exception:
            return True

    def _define_common_points(self):
        g = self.groups["COMMON"]
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="COMMON.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="COMMON.form"
        )
        g.add_watch_point(
            self,
            {
                "input_has_nan": lambda x: int(x._input_has_nan()) == 1,
                "input_no_nan": lambda x: int(x._input_has_nan()) == 0,
            },
            name="COMMON.input_nan"
        )

    def _define_element_points(self):
        g = self.groups["ELEMENT"]
        g.add_watch_point(
            self,
            {
                "lane=0": lambda x: int(x.lane_idx) == 0,
                "lane=1": lambda x: int(x.lane_idx) == 1,
                "lane=2": lambda x: int(x.lane_idx) == 2,
                "lane=3": lambda x: int(x.lane_idx) == 3,
            },
            name="ELEMENT.lane"
        )
        cats = [FpCategory.NAN, FpCategory.INFINITY, FpCategory.SUBNORMAL, FpCategory.ZERO, FpCategory.NORMAL]
        a_map = {f"A_CAT={c.name}": (lambda cc=c: (lambda x: x._a_category() == cc))() for c in cats}
        b_map = {f"B_CAT={c.name}": (lambda cc=c: (lambda x: x._b_category() == cc))() for c in cats}
        g.add_watch_point(self, a_map, name="ELEMENT.a_category")
        g.add_watch_point(self, b_map, name="ELEMENT.b_category")
        ab_map = {}
        for ca in cats:
            for cb in cats:
                ab_map[f"A={ca.name}&B={cb.name}"] = (
                    lambda cca=ca, ccb=cb: (lambda x: x._a_category() == cca and x._b_category() == ccb)
                )()
        g.add_watch_point(self, ab_map, name="ELEMENT.ab_category_cross")
        lane_ab_map = {}
        for lane in range(4):
            for ca in cats:
                for cb in cats:
                    lane_ab_map[f"lane={lane}&A={ca.name}&B={cb.name}"] = (
                        lambda ll=lane, cca=ca, ccb=cb: (
                            lambda x: int(x.lane_idx) == ll and x._a_category() == cca and x._b_category() == ccb
                        )
                    )()
        g.add_watch_point(self, lane_ab_map, name="ELEMENT.lane_ab_category_cross")
        g.add_watch_point(
            self,
            {
                "ExpRel=EQUAL": lambda x: x._exp_relation() == ExpRelation.EQUAL,
                "ExpRel=CLOSE": lambda x: x._exp_relation() == ExpRelation.CLOSE,
                "ExpRel=FAR": lambda x: x._exp_relation() == ExpRelation.FAR,
            },
            name="ELEMENT.exp_relation"
        )
        g.add_watch_point(
            self,
            {
                "ManRel=EQUAL": lambda x: x._man_relation() == ManRelation.EQUAL,
                "ManRel=SMALL_DIFF": lambda x: x._man_relation() == ManRelation.SMALL_DIFF,
                "ManRel=LARGE_DIFF": lambda x: x._man_relation() == ManRelation.LARGE_DIFF,
            },
            name="ELEMENT.man_relation"
        )
        g.add_watch_point(
            self,
            {
                "SignRel=SAME": lambda x: x._sign_relation() == SignRelation.SAME,
                "SignRel=OPPOSITE": lambda x: x._sign_relation() == SignRelation.OPPOSITE,
            },
            name="ELEMENT.sign_relation"
        )
        g.add_watch_point(
            self,
            {
                "VS1+=0,VS2+=0": lambda x: int(x._a_sign()) == 0 and int(x._b_sign()) == 0,
                "VS1+=0,VS2-=1": lambda x: int(x._a_sign()) == 0 and int(x._b_sign()) == 1,
                "VS1-=1,VS2+=0": lambda x: int(x._a_sign()) == 1 and int(x._b_sign()) == 0,
                "VS1-=1,VS2-=1": lambda x: int(x._a_sign()) == 1 and int(x._b_sign()) == 1,
            },
            name="ELEMENT.sign_combo"
        )
        prec_pairs = [
            (FpPrecision.FP16, FpPrecision.FP16),
            (FpPrecision.BF16, FpPrecision.BF16),
            (FpPrecision.FP16, FpPrecision.FP32),
            (FpPrecision.BF16, FpPrecision.FP32),
        ]
        m_prec = {}
        for pa, pb in prec_pairs:
            m_prec[f"A={pa.name}&B={pb.name}"] = (
                lambda ppa=pa, ppb=pb: (lambda x: x._a_precision() == ppa and x._b_precision() == ppb)
            )()
        g.add_watch_point(self, m_prec, name="ELEMENT.prec_pair")
        g.add_watch_point(
            self,
            {
                "cmp_has_nan": lambda x: int(x._cmp_has_nan()) == 1,
                "cmp_no_nan": lambda x: int(x._cmp_has_nan()) == 0,
            },
            name="ELEMENT.cmp_nan_in_pair"
        )
        g.add_watch_point(
            self,
            {
                "cmp_true": lambda x: int(x._cmp_bit()) == 1,
                "cmp_false": lambda x: int(x._cmp_bit()) == 0,
            },
            name="ELEMENT.cmp_result"
        )
        g.add_watch_point(
            self,
            {
                "Rel=LT": lambda x: x._cmp_relation() == "LT",
                "Rel=EQ": lambda x: x._cmp_relation() == "EQ",
                "Rel=GT": lambda x: x._cmp_relation() == "GT",
                "Rel=UNORDERED": lambda x: x._cmp_relation() == "UNORDERED",
            },
            name="ELEMENT.cmp_relation"
        )

    def _define_fadd_sub_points(self):
        g = self.groups["FADD_SUB"]
        g.add_watch_point(
            self,
            {
                "FADD_SUB=VFADD": lambda x: x._uop_type() == UopType.VFADD,
                "FADD_SUB=VFSUB": lambda x: x._uop_type() == UopType.VFSUB,
                "FADD_SUB=VFRSUB": lambda x: x._uop_type() == UopType.VFRSUB,
            },
            name="FADD_SUB.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="FADD_SUB.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="FADD_SUB.form"
        )
        m_uop_sew = {}
        for u in [UopType.VFADD, UopType.VFSUB, UopType.VFRSUB]:
            for s in [SewType.FP32, SewType.FP16, SewType.BF16]:
                m_uop_sew[f"uop={u.name}&SEW={s.name}"] = (
                    lambda uu=u, ss=s: (lambda x: x._uop_type() == uu and x._sew_type() == ss)
                )()
        g.add_watch_point(self, m_uop_sew, name="FADD_SUB.uop_sew")
        m_form_sew = {}
        for f in [Funct3Type.OPFVV, Funct3Type.OPFVF]:
            for s in [SewType.FP32, SewType.FP16, SewType.BF16]:
                m_form_sew[f"Form={f.name}&SEW={s.name}"] = (
                    lambda ff=f, ss=s: (lambda x: x._funct3_type() == ff and x._sew_type() == ss)
                )()
        g.add_watch_point(self, m_form_sew, name="FADD_SUB.form_sew")

    def _define_widen_points(self):
        g = self.groups["WIDEN"]
        g.add_watch_point(
            self,
            {
                "WIDEN=VFWADD": lambda x: x._uop_type() == UopType.VFWADD,
                "WIDEN=VFWSUB": lambda x: x._uop_type() == UopType.VFWSUB,
                "WIDEN=VFWADD_W": lambda x: x._uop_type() == UopType.VFWADD_W,
                "WIDEN=VFWSUB_W": lambda x: x._uop_type() == UopType.VFWSUB_W,
            },
            name="WIDEN.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="WIDEN.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="WIDEN.form"
        )
        g.add_watch_point(
            self,
            {
                "widen=1": lambda x: int(x._widen()) == 1 and int(x._widen2()) == 0,
                "widen2=1": lambda x: int(x._widen2()) == 1,
            },
            name="WIDEN.widen_flags"
        )
        g.add_watch_point(
            self,
            {
                "uopIdx=0": lambda x: int(x._uop_idx()) == 0,
                "uopIdx=1": lambda x: int(x._uop_idx()) == 1,
            },
            name="WIDEN.uopIdx"
        )

    def _define_fcmp_points(self):
        g = self.groups["FCMP"]
        g.add_watch_point(
            self,
            {
                "FCMP=VMFEQ": lambda x: x._uop_type() == UopType.VMFEQ,
                "FCMP=VMFNE": lambda x: x._uop_type() == UopType.VMFNE,
                "FCMP=VMFLT": lambda x: x._uop_type() == UopType.VMFLT,
                "FCMP=VMFLE": lambda x: x._uop_type() == UopType.VMFLE,
                "FCMP=VMFGT": lambda x: x._uop_type() == UopType.VMFGT,
                "FCMP=VMFGE": lambda x: x._uop_type() == UopType.VMFGE,
            },
            name="FCMP.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="FCMP.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="FCMP.form"
        )

    def _define_minmax_points(self):
        g = self.groups["MINMAX"]
        g.add_watch_point(
            self,
            {
                "MINMAX=VFMIN": lambda x: x._uop_type() == UopType.VFMIN,
                "MINMAX=VFMAX": lambda x: x._uop_type() == UopType.VFMAX,
            },
            name="MINMAX.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="MINMAX.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="MINMAX.form"
        )

    def _define_sign_points(self):
        g = self.groups["SIGN"]
        g.add_watch_point(
            self,
            {
                "SIGN=VFSGNJ": lambda x: x._uop_type() == UopType.VFSGNJ,
                "SIGN=VFSGNJN": lambda x: x._uop_type() == UopType.VFSGNJN,
                "SIGN=VFSGNJX": lambda x: x._uop_type() == UopType.VFSGNJX,
            },
            name="SIGN.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="SIGN.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="SIGN.form"
        )

    def _define_fmv_points(self):
        g = self.groups["FMV"]
        g.add_watch_point(
            self,
            {
                "FMV=VFMV": lambda x: x._uop_type() == UopType.VFMV,
                "FMV=VFMV_F_S": lambda x: x._uop_type() == UopType.VFMV_F_S,
                "FMV=VFMV_S_F": lambda x: x._uop_type() == UopType.VFMV_S_F,
            },
            name="FMV.uop"
        )
        g.add_watch_point(
            self,
            {
                "SEW=FP32": lambda x: x._sew_type() == SewType.FP32,
                "SEW=FP16": lambda x: x._sew_type() == SewType.FP16,
                "SEW=BF16": lambda x: x._sew_type() == SewType.BF16,
            },
            name="FMV.sew"
        )
        g.add_watch_point(
            self,
            {
                "Form=OPFVV": lambda x: x._funct3_type() == Funct3Type.OPFVV,
                "Form=OPFVF": lambda x: x._funct3_type() == Funct3Type.OPFVF,
            },
            name="FMV.form"
        )
        cats = [FpCategory.NAN, FpCategory.INFINITY, FpCategory.SUBNORMAL, FpCategory.ZERO, FpCategory.NORMAL]
        m = {f"SRC_CAT={c.name}": (lambda cc=c: (lambda x: x._move_src_category() == cc))() for c in cats}
        g.add_watch_point(self, m, name="FMV.src_category")

    def _uop_type(self):
        return getattr(self._input_tx, "uop_type", None)

    def _sew_type(self):
        return getattr(self._input_tx, "sew_type", None)

    def _funct3_type(self):
        return getattr(self._input_tx, "funct3_type", None)

    def _widen(self):
        try:
            return int(self._input_tx.payload.uop.ctrl.widen)
        except Exception:
            return 0

    def _widen2(self):
        try:
            return int(self._input_tx.payload.uop.ctrl.widen2)
        except Exception:
            return 0

    def _uop_idx(self):
        try:
            return int(self._input_tx.payload.uop.uopIdx)
        except Exception:
            return 0

    @staticmethod
    def _lane_count(input_tx) -> int:
        if input_tx.sew_type == SewType.FP32:
            return 2
        if input_tx.sew_type in [SewType.FP16, SewType.BF16] and input_tx.uop_type in [
            UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W
        ]:
            return 2
        return 4

    @staticmethod
    def _as_enum(enum_t, val):
        try:
            if isinstance(val, enum_t):
                return val
            return enum_t(int(val))
        except Exception:
            return None

    @staticmethod
    def _mag_key(cat: FpCategory, exp: int, man: int):
        if cat == FpCategory.ZERO:
            rank = 0
        elif cat == FpCategory.SUBNORMAL:
            rank = 1
        elif cat == FpCategory.NORMAL:
            rank = 2
        elif cat == FpCategory.INFINITY:
            rank = 3
        else:
            rank = -1
        return (rank, int(exp), int(man))

    @classmethod
    def _cmp_relation_from_components(
        cls,
        lhs_cat: FpCategory, lhs_sign: int, lhs_exp: int, lhs_man: int,
        rhs_cat: FpCategory, rhs_sign: int, rhs_exp: int, rhs_man: int,
    ) -> str:
        if lhs_cat == FpCategory.NAN or rhs_cat == FpCategory.NAN:
            return "UNORDERED"
        if lhs_cat == FpCategory.ZERO and rhs_cat == FpCategory.ZERO:
            return "EQ"
        if lhs_cat == FpCategory.INFINITY and rhs_cat == FpCategory.INFINITY and int(lhs_sign) == int(rhs_sign):
            return "EQ"
        if int(lhs_sign) != int(rhs_sign):
            return "LT" if int(lhs_sign) == 1 else "GT"

        lhs_key = cls._mag_key(lhs_cat, lhs_exp, lhs_man)
        rhs_key = cls._mag_key(rhs_cat, rhs_exp, rhs_man)
        if lhs_key == rhs_key:
            return "EQ"

        mag_lt = lhs_key < rhs_key
        if int(lhs_sign) == 0:
            return "LT" if mag_lt else "GT"
        return "GT" if mag_lt else "LT"

    def _pair(self, lane_idx: int | None = None):
        if self._input_tx is None:
            return None
        lane = int(self.lane_idx if lane_idx is None else lane_idx)
        pair = None
        try:
            if getattr(self._input_tx, "fp_pairs_list", None) and len(self._input_tx.fp_pairs_list) > lane:
                pair = self._input_tx.fp_pairs_list[lane]
        except Exception:
            pair = None
        if pair is None:
            try:
                pair = self._input_tx.fp_pairs[lane]
            except Exception:
                pair = None
        return pair

    def _a(self):
        pair = self._pair()
        return getattr(pair, "a", None) if pair is not None else None

    def _b(self):
        pair = self._pair()
        return getattr(pair, "b", None) if pair is not None else None

    def _a_precision(self):
        a = self._a()
        return self._as_enum(FpPrecision, getattr(a, "precision", None))

    def _b_precision(self):
        b = self._b()
        return self._as_enum(FpPrecision, getattr(b, "precision", None))

    def _a_category(self):
        a = self._a()
        return self._as_enum(FpCategory, getattr(a, "category", None))

    def _b_category(self):
        b = self._b()
        return self._as_enum(FpCategory, getattr(b, "category", None))

    def _a_sign(self):
        a = self._a()
        return int(getattr(a, "sign", 0)) if a is not None else 0

    def _b_sign(self):
        b = self._b()
        return int(getattr(b, "sign", 0)) if b is not None else 0

    def _exp_relation(self):
        pair = self._pair()
        return self._as_enum(ExpRelation, getattr(pair, "exp_relation", None)) if pair is not None else None

    def _man_relation(self):
        pair = self._pair()
        return self._as_enum(ManRelation, getattr(pair, "man_relation", None)) if pair is not None else None

    def _sign_relation(self):
        pair = self._pair()
        return self._as_enum(SignRelation, getattr(pair, "sign_relation", None)) if pair is not None else None

    def _input_has_nan(self) -> int:
        if self._input_tx is None:
            return 0
        lane_count = self._lane_count(self._input_tx)
        for i in range(lane_count):
            pair = self._pair(i)
            if pair is None:
                continue
            a_cat = self._as_enum(FpCategory, getattr(pair.a, "category", None))
            b_cat = self._as_enum(FpCategory, getattr(pair.b, "category", None))
            if a_cat == FpCategory.NAN or b_cat == FpCategory.NAN:
                return 1
        return 0

    def _cmp_has_nan(self) -> int:
        return 1 if (self._a_category() == FpCategory.NAN or self._b_category() == FpCategory.NAN) else 0

    def _cmp_relation(self):
        if self._input_tx is None:
            return None
        if self._uop_type() not in [UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGT, UopType.VMFGE]:
            return None
        pair = self._pair()
        if pair is None:
            return None

        lhs_cat = self._b_category()
        rhs_cat = self._a_category()
        lhs_sign = int(getattr(pair.b, "sign", 0))
        rhs_sign = int(getattr(pair.a, "sign", 0))
        lhs_exp = int(getattr(pair.b, "exp", 0))
        rhs_exp = int(getattr(pair.a, "exp", 0))
        lhs_man = int(getattr(pair.b, "man", 0))
        rhs_man = int(getattr(pair.a, "man", 0))
        return self._cmp_relation_from_components(
            lhs_cat, lhs_sign, lhs_exp, lhs_man,
            rhs_cat, rhs_sign, rhs_exp, rhs_man,
        )

    def _cmp_bit(self) -> int:
        uop = self._uop_type()
        rel = self._cmp_relation()
        if uop not in [UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGT, UopType.VMFGE]:
            return 0
        if rel is None:
            return 0
        if rel == "UNORDERED":
            return 1 if uop == UopType.VMFNE else 0

        if uop == UopType.VMFEQ:
            return 1 if rel == "EQ" else 0
        if uop == UopType.VMFNE:
            return 1 if rel != "EQ" else 0
        if uop == UopType.VMFLT:
            return 1 if rel == "LT" else 0
        if uop == UopType.VMFLE:
            return 1 if rel in ["LT", "EQ"] else 0
        if uop == UopType.VMFGE:
            return 1 if rel in ["GT", "EQ"] else 0
        if uop == UopType.VMFGT:
            return 1 if rel == "GT" else 0
        return 0

    def _move_src_category(self):
        if self._input_tx is None:
            return None
        uop = self._uop_type()
        pair0 = self._pair(0)
        if pair0 is None:
            return None
        a_cat0 = self._as_enum(FpCategory, getattr(pair0.a, "category", None))
        b_cat0 = self._as_enum(FpCategory, getattr(pair0.b, "category", None))
        if uop in [UopType.VFMV, UopType.VFMV_S_F]:
            return a_cat0
        if uop == UopType.VFMV_F_S:
            return b_cat0
        return None

    def sample(self, input_tx):
        self._input_tx = input_tx
        lane_count = self._lane_count(input_tx)

        target_groups = ["COMMON"]
        u = input_tx.uop_type
        if u in [UopType.VFADD, UopType.VFSUB, UopType.VFRSUB]:
            target_groups.append("FADD_SUB")
        elif u in [UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W]:
            target_groups.append("WIDEN")
        elif u in [UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGT, UopType.VMFGE]:
            target_groups.append("FCMP")
        elif u in [UopType.VFMIN, UopType.VFMAX]:
            target_groups.append("MINMAX")
        elif u in [UopType.VFSGNJ, UopType.VFSGNJN, UopType.VFSGNJX]:
            target_groups.append("SIGN")
        elif u in [UopType.VFMV, UopType.VFMV_F_S, UopType.VFMV_S_F]:
            target_groups.append("FMV")

        for gn in target_groups:
            self.groups[gn].sample()

        for i in range(lane_count):
            self.lane_idx = i
            self.groups["ELEMENT"].sample()
        self._input_tx = None

    def update_and_sample(self, input_tx, expected, actual):
        return self.sample(input_tx)

    def as_dict(self):
        return {k: v.as_dict() for k, v in self.groups.items()}

    def clear(self):
        for g in self.groups.values():
            g.clear()
