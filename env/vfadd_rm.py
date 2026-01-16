from toffee import Model, DriverPort, MonitorPort
from env.common import prj_reporter
from env.vfadd_xaction import OutputPayload, UopType, SewType
from env.fp_xaction import FpPrecision
from tests.vfadd_cov_wrap import VFAddCovWrap
import asyncio
import numpy as np
import ml_dtypes


class vfadd_rm(Model):
    def __init__(self):
        super().__init__()
        self.prj_reporter = prj_reporter.get_reporter()
        
        # Define Ports
        self.from_mst_agent_port = MonitorPort(agent_name="vfadd_master_agent", monitor_name="monitor_in")
        self.from_slv_agent_port = MonitorPort(agent_name="vfadd_slave_agent", monitor_name="monitor_out")
        
        self.pass_count = 0
        self.fail_count = 0
        self.cov = VFAddCovWrap()

    async def main(self):
        self.prj_reporter.report_msg("vfadd_rm", "RM started", prj_reporter.ReportLevel.NONE)
        expected_q = asyncio.Queue(maxsize=4096)
        actual_q = asyncio.Queue(maxsize=4096)
        async def producer():
            while True:
                input_tx = await self.from_mst_agent_port()
                input_tx.reconstruct()
                self.prj_reporter.report_msg("vfadd_rm",
                                             f"Input xaction: {input_tx.report(detail=False)}",
                                             prj_reporter.ReportLevel.MEDIUM)
                expected = OutputPayload()
                expected.timestamp = input_tx.timestamp
                if input_tx.uop_type in [UopType.VFADD, UopType.VFSUB, UopType.VFRSUB,
                                         UopType.VFWADD, UopType.VFWSUB,
                                         UopType.VFWADD_W, UopType.VFWSUB_W]:
                    expected.vd = self._predict_add_sub(input_tx)
                elif input_tx.uop_type in [UopType.VFMIN, UopType.VFMAX]:
                    expected.vd = self._predict_minmax(input_tx)
                elif input_tx.uop_type in [UopType.VFSGNJ, UopType.VFSGNJN, UopType.VFSGNJX]:
                    expected.vd = self._predict_sgn(input_tx)
                elif input_tx.uop_type in [UopType.VMFEQ, UopType.VMFNE, UopType.VMFLT, UopType.VMFLE, UopType.VMFGE, UopType.VMFGT]:
                    expected.vd = self._predict_compare(input_tx)
                elif input_tx.uop_type == UopType.VFMV or input_tx.uop_type == UopType.VFMV_S_F:
                    expected.vd = self._predict_move(input_tx)
                elif input_tx.uop_type == UopType.VFMV_F_S:
                    expected.rd_bits = self._predict_copy_vs2(input_tx)
                    expected.rd_valid = 1
                else:
                    self.prj_reporter.report_msg("vfadd_rm", f"Unsupported Uop: {input_tx.uop_type}", prj_reporter.ReportLevel.WARNING)
                    expected.vd = 0
                await expected_q.put((input_tx, expected))
        async def drain_slv():
            while True:
                actual_output = await self.from_slv_agent_port()
                await actual_q.put(actual_output)
        async def matcher():
            while True:
                input_tx, expected = await expected_q.get()
                actual_output = await actual_q.get()
                id_in = int(getattr(input_tx, "transaction_id", -1))
                id_out = int(getattr(actual_output, "transaction_id", -1))
                if id_in != id_out:
                    self.prj_reporter.report_error(
                        "vfadd_rm",
                        f"ID mismatch: in={id_in} out={id_out} | Uop={getattr(input_tx, 'uop_name', 'unknown')} SEW={input_tx.sew_type.name}"
                    )
                    self.fail_count += 1
                    continue
                ok = self._compare(input_tx, expected, actual_output)
                if not ok:
                    self.fail_count += 1
                else:
                    self.pass_count += 1
                self.cov.sample(input_tx)
        prod_task = asyncio.create_task(producer())
        slv_task = asyncio.create_task(drain_slv())
        match_task = asyncio.create_task(matcher())
        try:
            await asyncio.gather(prod_task, slv_task, match_task)
        except asyncio.CancelledError:
            prod_task.cancel()
            slv_task.cancel()
            match_task.cancel()
            self.report_summary()
            self.prj_reporter.report_msg("vfadd_rm", "RM stopped", prj_reporter.ReportLevel.NONE)
            raise

    def _compare(self, input_tx, expected, actual) -> bool:
        ctx = f"Uop={getattr(input_tx, 'uop_name', 'unknown')} SEW={input_tx.sew_type.name} TS={getattr(input_tx, 'timestamp', 0)}"
        errors = []
        if hasattr(actual, "uop") and actual.uop is not None:
            def _neq(e, a):
                try:
                    return int(a) != int(e)
                except Exception:
                    return True
            mism = []
            try:
                if _neq(input_tx.payload.uop.ctrl.funct6, actual.uop.ctrl.funct6): mism.append(("funct6", input_tx.payload.uop.ctrl.funct6, actual.uop.ctrl.funct6))
                if _neq(input_tx.payload.uop.ctrl.funct3, actual.uop.ctrl.funct3): mism.append(("funct3", input_tx.payload.uop.ctrl.funct3, actual.uop.ctrl.funct3))
                if _neq(input_tx.payload.uop.ctrl.vm, actual.uop.ctrl.vm): mism.append(("vm", input_tx.payload.uop.ctrl.vm, actual.uop.ctrl.vm))
                if _neq(input_tx.payload.uop.ctrl.fp, actual.uop.ctrl.fp): mism.append(("fp", input_tx.payload.uop.ctrl.fp, actual.uop.ctrl.fp))
                if _neq(input_tx.payload.uop.ctrl.arith, actual.uop.ctrl.arith): mism.append(("arith", input_tx.payload.uop.ctrl.arith, actual.uop.ctrl.arith))
                if _neq(input_tx.payload.uop.ctrl.vfadd, actual.uop.ctrl.vfadd): mism.append(("vfadd", input_tx.payload.uop.ctrl.vfadd, actual.uop.ctrl.vfadd))
                if _neq(input_tx.payload.uop.ctrl.widen, actual.uop.ctrl.widen): mism.append(("widen", input_tx.payload.uop.ctrl.widen, actual.uop.ctrl.widen))
                if _neq(input_tx.payload.uop.ctrl.widen2, actual.uop.ctrl.widen2): mism.append(("widen2", input_tx.payload.uop.ctrl.widen2, actual.uop.ctrl.widen2))
                if _neq(input_tx.payload.uop.ctrl.mask, actual.uop.ctrl.mask): mism.append(("mask", input_tx.payload.uop.ctrl.mask, actual.uop.ctrl.mask))
                if _neq(input_tx.payload.uop.ctrl.lsrc_0, actual.uop.ctrl.lsrc_0): mism.append(("lsrc_0", input_tx.payload.uop.ctrl.lsrc_0, actual.uop.ctrl.lsrc_0))
                if _neq(input_tx.payload.uop.ctrl.lsrc_1, actual.uop.ctrl.lsrc_1): mism.append(("lsrc_1", input_tx.payload.uop.ctrl.lsrc_1, actual.uop.ctrl.lsrc_1))
                if _neq(input_tx.payload.uop.ctrl.ldest, actual.uop.ctrl.ldest): mism.append(("ldest", input_tx.payload.uop.ctrl.ldest, actual.uop.ctrl.ldest))
                if _neq(input_tx.payload.uop.ctrl.illegal, actual.uop.ctrl.illegal): mism.append(("illegal", input_tx.payload.uop.ctrl.illegal, actual.uop.ctrl.illegal))
                if _neq(input_tx.payload.uop.ctrl.lsrcVal_0, actual.uop.ctrl.lsrcVal_0): mism.append(("lsrcVal_0", input_tx.payload.uop.ctrl.lsrcVal_0, actual.uop.ctrl.lsrcVal_0))
                if _neq(input_tx.payload.uop.ctrl.lsrcVal_1, actual.uop.ctrl.lsrcVal_1): mism.append(("lsrcVal_1", input_tx.payload.uop.ctrl.lsrcVal_1, actual.uop.ctrl.lsrcVal_1))
                if _neq(input_tx.payload.uop.ctrl.lsrcVal_2, actual.uop.ctrl.lsrcVal_2): mism.append(("lsrcVal_2", input_tx.payload.uop.ctrl.lsrcVal_2, actual.uop.ctrl.lsrcVal_2))
                if _neq(input_tx.payload.uop.ctrl.ldestVal, actual.uop.ctrl.ldestVal): mism.append(("ldestVal", input_tx.payload.uop.ctrl.ldestVal, actual.uop.ctrl.ldestVal))
                if _neq(input_tx.payload.uop.ctrl.load, actual.uop.ctrl.load): mism.append(("load", input_tx.payload.uop.ctrl.load, actual.uop.ctrl.load))
                if _neq(input_tx.payload.uop.ctrl.store, actual.uop.ctrl.store): mism.append(("store", input_tx.payload.uop.ctrl.store, actual.uop.ctrl.store))
                if _neq(input_tx.payload.uop.ctrl.crossLane, actual.uop.ctrl.crossLane): mism.append(("crossLane", input_tx.payload.uop.ctrl.crossLane, actual.uop.ctrl.crossLane))
                if _neq(input_tx.payload.uop.ctrl.alu, actual.uop.ctrl.alu): mism.append(("alu", input_tx.payload.uop.ctrl.alu, actual.uop.ctrl.alu))
                if _neq(input_tx.payload.uop.ctrl.mul, actual.uop.ctrl.mul): mism.append(("mul", input_tx.payload.uop.ctrl.mul, actual.uop.ctrl.mul))
                if _neq(input_tx.payload.uop.ctrl.div, actual.uop.ctrl.div): mism.append(("div", input_tx.payload.uop.ctrl.div, actual.uop.ctrl.div))
                if _neq(input_tx.payload.uop.ctrl.fixP, actual.uop.ctrl.fixP): mism.append(("fixP", input_tx.payload.uop.ctrl.fixP, actual.uop.ctrl.fixP))
                if _neq(input_tx.payload.uop.ctrl.redu, actual.uop.ctrl.redu): mism.append(("redu", input_tx.payload.uop.ctrl.redu, actual.uop.ctrl.redu))
                if _neq(input_tx.payload.uop.ctrl.perm, actual.uop.ctrl.perm): mism.append(("perm", input_tx.payload.uop.ctrl.perm, actual.uop.ctrl.perm))
                if _neq(input_tx.payload.uop.ctrl.vfma, actual.uop.ctrl.vfma): mism.append(("vfma", input_tx.payload.uop.ctrl.vfma, actual.uop.ctrl.vfma))
                if _neq(input_tx.payload.uop.ctrl.vfcvt, actual.uop.ctrl.vfcvt): mism.append(("vfcvt", input_tx.payload.uop.ctrl.vfcvt, actual.uop.ctrl.vfcvt))
                if _neq(input_tx.payload.uop.ctrl.narrow, actual.uop.ctrl.narrow): mism.append(("narrow", input_tx.payload.uop.ctrl.narrow, actual.uop.ctrl.narrow))
                if _neq(input_tx.payload.uop.ctrl.narrow_to_1, actual.uop.ctrl.narrow_to_1): mism.append(("narrow_to_1", input_tx.payload.uop.ctrl.narrow_to_1, actual.uop.ctrl.narrow_to_1))
                if _neq(input_tx.payload.uop.csr.vl, actual.uop.csr.vl): mism.append(("vl", input_tx.payload.uop.csr.vl, actual.uop.csr.vl))
                if _neq(input_tx.payload.uop.csr.frm, actual.uop.csr.frm): mism.append(("frm", input_tx.payload.uop.csr.frm, actual.uop.csr.frm))
                if _neq(input_tx.payload.uop.csr.vstart, actual.uop.csr.vstart): mism.append(("vstart", input_tx.payload.uop.csr.vstart, actual.uop.csr.vstart))
                if _neq(input_tx.payload.uop.csr.vxrm, actual.uop.csr.vxrm): mism.append(("vxrm", input_tx.payload.uop.csr.vxrm, actual.uop.csr.vxrm))
                if _neq(input_tx.payload.uop.csr.vlmul, actual.uop.csr.vlmul): mism.append(("vlmul", input_tx.payload.uop.csr.vlmul, actual.uop.csr.vlmul))
                if _neq(input_tx.payload.uop.csr.vsew, actual.uop.csr.vsew): mism.append(("vsew", input_tx.payload.uop.csr.vsew, actual.uop.csr.vsew))
                if _neq(input_tx.payload.uop.csr.vill, actual.uop.csr.vill): mism.append(("vill", input_tx.payload.uop.csr.vill, actual.uop.csr.vill))
                if _neq(input_tx.payload.uop.csr.ma, actual.uop.csr.ma): mism.append(("ma", input_tx.payload.uop.csr.ma, actual.uop.csr.ma))
                if _neq(input_tx.payload.uop.csr.ta, actual.uop.csr.ta): mism.append(("ta", input_tx.payload.uop.csr.ta, actual.uop.csr.ta))
                if _neq(input_tx.payload.uop.uopIdx, actual.uop.uopIdx): mism.append(("uopIdx", input_tx.payload.uop.uopIdx, actual.uop.uopIdx))
                if _neq(input_tx.payload.uop.uopEnd, actual.uop.uopEnd): mism.append(("uopEnd", input_tx.payload.uop.uopEnd, actual.uop.uopEnd))
            except Exception:
                pass
            if mism:
                detail = "; ".join([f"{n}: exp={int(e)} act={int(a)}" for (n,e,a) in mism])
                errors.append(f"Transparency mismatch [{ctx}] {detail}")
        if input_tx.uop_type == UopType.VFMV_F_S:
            if int(getattr(actual, "rd_valid", 0)) != 1:
                errors.append(f"Scalar rd_valid mismatch [{ctx}] exp=1 act={int(getattr(actual,'rd_valid',0))}")
            res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
            prec = FpPrecision.FP32 if res_width == 32 else (FpPrecision.BF16 if input_tx.sew_type == SewType.BF16 else FpPrecision.FP16)
            exp_bits = int(getattr(expected, "rd_bits", 0)) & ((1 << res_width) - 1)
            act_bits = int(getattr(actual, "rd_bits", 0)) & ((1 << res_width) - 1)
            exp_is_nan = self._is_nan_bits(exp_bits, prec)
            act_is_nan = self._is_nan_bits(act_bits, prec)
            if exp_bits == act_bits:
                ok = True
            else:
                if exp_is_nan and act_is_nan:
                    ok = True
                elif self._is_zero_bits(exp_bits, prec) and self._is_zero_bits(act_bits, prec):
                    ok = True
                else:
                    ok = False
            if not ok:
                errors.append(f"Scalar bits mismatch [{ctx}] exp=0x{exp_bits:0{res_width//4}x} act=0x{act_bits:0{res_width//4}x}")
        else:
            res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
            is_widen = input_tx.uop_type in [UopType.VFWADD, UopType.VFWSUB, UopType.VFWADD_W, UopType.VFWSUB_W]
            if is_widen:
                res_width = 32
            num_elems = (64 // res_width)
            prec = FpPrecision.FP32 if res_width == 32 else (FpPrecision.BF16 if input_tx.sew_type == SewType.BF16 else FpPrecision.FP16)
            mismatches = []
            for i in range(num_elems):
                mask = (1 << res_width) - 1
                exp_bits = (int(getattr(expected, "vd", 0)) >> (i * res_width)) & mask
                act_bits = (int(getattr(actual, "vd", 0)) >> (i * res_width)) & mask
                if input_tx.uop_type in [UopType.VFMIN, UopType.VFMAX]:
                    try:
                        pair = input_tx.fp_pairs_list[i]
                        a_in_nan = self._is_nan_bits(pair.a.val_bits, pair.a.precision)
                        b_in_nan = self._is_nan_bits(pair.b.val_bits, pair.b.precision)
                        if a_in_nan or b_in_nan:
                            if act_bits == (pair.a.val_bits & mask) or act_bits == (pair.b.val_bits & mask):
                                continue
                            else:
                                mismatches.append((i, exp_bits, act_bits, "minmax NaN -> expect a or b"))
                                continue
                    except Exception:
                        pass
                exp_is_nan = self._is_nan_bits(exp_bits, prec)
                act_is_nan = self._is_nan_bits(act_bits, prec)
                if exp_bits == act_bits:
                    continue
                if exp_is_nan and act_is_nan:
                    if input_tx.uop_type in [UopType.VFMV, UopType.VFMV_S_F]:
                        # For move instructions, both NaN is acceptable regardless of qNaN
                        continue
                    else:
                        # For non-move, allow qNaN on actual when bits differ
                        if not self._is_qnan_bits(act_bits, prec):
                            mismatches.append((i, exp_bits, act_bits, "expect NaN, got non-qNaN"))
                        continue
                if self._is_zero_bits(exp_bits, prec) and self._is_zero_bits(act_bits, prec):
                    continue
                mismatches.append((i, exp_bits, act_bits, "bit mismatch"))
            if mismatches:
                first = mismatches[0]
                errors.append(f"Vector elem mismatch [{ctx}] idx={first[0]} exp=0x{first[1]:0{res_width//4}x} act=0x{first[2]:0{res_width//4}x} ({first[3]})")
                errors.append(f"VD expected=0x{int(getattr(expected,'vd',0)):016x} actual=0x{int(getattr(actual,'vd',0)):016x}")
                errors.append(f"VS1=0x{int(input_tx.payload.vs1):016x} VS2=0x{int(input_tx.payload.vs2):016x} RS1=0x{int(input_tx.payload.rs1):016x}")
        if errors:
            detail = "\n".join(errors)
            msg = f"{detail}\n[Input] {input_tx.report(detail=True)}\n"
            
            if input_tx.uop_type == UopType.VFMV_F_S:
                exp_rd_valid = int(getattr(expected, "rd_valid", 0))
                act_rd_valid = int(getattr(actual, "rd_valid", 0))
                exp_rd_bits = int(getattr(expected, "rd_bits", 0))
                act_rd_bits = int(getattr(actual, "rd_bits", 0))
                msg += f"[Output Expected] RD(valid={exp_rd_valid} bits=0x{exp_rd_bits:016x})\n"
                msg += f"[Output Actual  ] RD(valid={act_rd_valid} bits=0x{act_rd_bits:016x})"
            else:
                exp_vd = f"0x{int(getattr(expected,'vd',0)):016x}"
                act_vd = f"0x{int(getattr(actual,'vd',0)):016x}"
                msg += f"[Output Expected] VD={exp_vd}\n"
                msg += f"[Output Actual  ] VD={act_vd}"
            
            self.prj_reporter.report_error("vfadd_rm", msg)
            return False
        if input_tx.uop_type == UopType.VFMV_F_S:
            exp_rd_valid = int(getattr(expected, "rd_valid", 0))
            act_rd_valid = int(getattr(actual, "rd_valid", 0))
            exp_rd_bits = int(getattr(expected, "rd_bits", 0))
            act_rd_bits = int(getattr(actual, "rd_bits", 0))
            pass_msg = "Compare_Success:\n"
            pass_msg += f"[Output Expected] RD(valid={exp_rd_valid} bits=0x{exp_rd_bits:016x})\n"
            pass_msg += f"[Output Actual  ] RD(valid={act_rd_valid} bits=0x{act_rd_bits:016x})\n"
            pass_msg += f"Input Detail:{input_tx.report(detail=True)}\n"
        else:
            exp_vd = f"0x{int(getattr(expected,'vd',0)):016x}"
            act_vd = f"0x{int(getattr(actual,'vd',0)):016x}"
            pass_msg = "Compare_Success:\n"
            pass_msg += f"[Output Expected] VD={exp_vd}\n"
            pass_msg += f"[Output Actual  ] VD={act_vd}\n"
            pass_msg += f"Input Detail:{input_tx.report(detail=True)}\n"
        self.prj_reporter.report_msg("vfadd_rm", pass_msg, prj_reporter.ReportLevel.MEDIUM)
        return True

    def _pack_elem(self, bits, width, index):
        return (int(bits) & ((1 << width) - 1)) << (index * width)
    def _predict_add_sub(self, input_tx) -> int:
        """
        Handle Vector Floating-Point Add/Sub instructions.
        Returns the packed integer result for VD.
        """
        vd_int = 0
        
        # Determine result width and precision
        # Default: same as input SEW
        res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
        res_prec = FpPrecision.FP32 if input_tx.sew_type == SewType.FP32 else \
                   (FpPrecision.BF16 if input_tx.sew_type == SewType.BF16 else FpPrecision.FP16)

        # Check for Widening Operations
        is_widen = input_tx.uop_type in [
            UopType.VFWADD, UopType.VFWSUB, 
            UopType.VFWADD_W, UopType.VFWSUB_W
        ]
        
        if is_widen:
            res_width = 32
            res_prec = FpPrecision.FP32

        # Iterate over all lanes
        for i, pair in enumerate(input_tx.fp_pairs_list):
            # Convert bits to numpy objects
            val_a = self._bits_to_numpy(pair.a.val_bits, pair.a.precision)
            val_b = self._bits_to_numpy(pair.b.val_bits, pair.b.precision)
            
            res_val = 0.0
            
            # Perform Operation
            with np.errstate(all='ignore'):
                if input_tx.uop_type == UopType.VFADD:
                    # vd = vs2 + vs1
                    res_val = val_b + val_a
                    
                elif input_tx.uop_type == UopType.VFSUB:
                    # vd = vs2 - vs1
                    res_val = val_b - val_a
                    
                elif input_tx.uop_type == UopType.VFRSUB:
                    # vd = vs1 - vs2 (Reverse Subtract)
                    res_val = val_a - val_b
                    
                elif input_tx.uop_type == UopType.VFWADD:
                    # vd = vs2 + vs1 (Widening, inputs are narrow)
                    res_val = val_b.astype(np.float32) + val_a.astype(np.float32)
                    
                elif input_tx.uop_type == UopType.VFWSUB:
                    # vd = vs2 - vs1 (Widening)
                    res_val = val_b.astype(np.float32) - val_a.astype(np.float32)
                    
                elif input_tx.uop_type == UopType.VFWADD_W:
                    # vd = vs2 + vs1 (Widening, vs2 is already wide)
                    # pair.b is already FP32 due to reconstruct logic
                    res_val = val_b + val_a.astype(np.float32)
                    
                elif input_tx.uop_type == UopType.VFWSUB_W:
                    # vd = vs2 - vs1 (Widening, vs2 is already wide)
                    res_val = val_b - val_a.astype(np.float32)

            # Convert result back to bits
            res_bits = self._numpy_to_bits(res_val, res_prec)
            
            self.prj_reporter.report_msg("vfadd_rm", f"Predict: Uop={input_tx.uop_type.name}, Pair={i}, A={val_a}, B={val_b}, Res={res_val}, Bits={res_bits:x}", prj_reporter.ReportLevel.MEDIUM)

            # Pack into result integer
            vd_int |= (res_bits << (i * res_width))
            
        return vd_int

    def _bits_to_numpy(self, bits, precision):
        """Convert integer bits to numpy floating point object."""
        if precision == FpPrecision.FP32:
            return np.uint32(bits).view(np.float32)
        elif precision == FpPrecision.FP16:
            return np.uint16(bits).view(np.float16)
        elif precision == FpPrecision.BF16:
            return np.uint16(bits).view(ml_dtypes.bfloat16)
        return np.float32(0.0)

    def _numpy_to_bits(self, val, precision):
        """Convert numpy floating point object back to integer bits."""
        if precision == FpPrecision.FP32:
            # Ensure type is correct before view
            return np.array(val, dtype=np.float32).view(np.uint32).item()
        elif precision == FpPrecision.FP16:
            return np.array(val, dtype=np.float16).view(np.uint16).item()
        elif precision == FpPrecision.BF16:
            return np.array(val, dtype=ml_dtypes.bfloat16).view(np.uint16).item()
        return 0

    def _is_nan_bits(self, bits, precision):
        if precision == FpPrecision.FP32:
            exp = (bits >> 23) & 0xFF
            frac = bits & 0x7FFFFF
            return exp == 0xFF and frac != 0
        if precision == FpPrecision.FP16:
            exp = (bits >> 10) & 0x1F
            frac = bits & 0x3FF
            return exp == 0x1F and frac != 0
        if precision == FpPrecision.BF16:
            exp = (bits >> 7) & 0xFF
            frac = bits & 0x7F
            return exp == 0xFF and frac != 0
        return False

    def _is_qnan_bits(self, bits, precision):
        if precision == FpPrecision.FP32:
            exp = (bits >> 23) & 0xFF
            frac = bits & 0x7FFFFF
            return exp == 0xFF and (frac & 0x400000) != 0
        if precision == FpPrecision.FP16:
            exp = (bits >> 10) & 0x1F
            frac = bits & 0x3FF
            return exp == 0x1F and (frac & 0x200) != 0
        if precision == FpPrecision.BF16:
            exp = (bits >> 7) & 0xFF
            frac = bits & 0x7F
            return exp == 0xFF and (frac & 0x40) != 0
        return False

    def _is_zero_bits(self, bits, precision):
        if precision == FpPrecision.FP32:
            return (bits & 0x7FFFFFFF) == 0
        if precision == FpPrecision.FP16:
            return (bits & 0x7FFF) == 0
        if precision == FpPrecision.BF16:
            return (bits & 0x7FFF) == 0
        return False

    def _predict_minmax(self, input_tx) -> int:
        vd_int = 0
        # Element width like add/sub
        res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
        res_prec = FpPrecision.FP32 if input_tx.sew_type == SewType.FP32 else (
            FpPrecision.BF16 if input_tx.sew_type == SewType.BF16 else FpPrecision.FP16
        )
        is_max = (input_tx.uop_type == UopType.VFMAX)
        for i, pair in enumerate(input_tx.fp_pairs_list):
            a = self._bits_to_numpy(pair.a.val_bits, pair.a.precision)
            b = self._bits_to_numpy(pair.b.val_bits, pair.b.precision)
            a_is_nan = np.isnan(np.array(a, dtype=np.float32)) if res_prec == FpPrecision.FP32 else np.isnan(float(np.array(a)))
            b_is_nan = np.isnan(np.array(b, dtype=np.float32)) if res_prec == FpPrecision.FP32 else np.isnan(float(np.array(b)))
            # Rule: if any operand is NaN, output may be either operand (a or b)
            if a_is_nan and b_is_nan:
                res_bits = pair.a.val_bits
            elif a_is_nan:
                res_bits = pair.b.val_bits
            elif b_is_nan:
                res_bits = pair.a.val_bits
            else:
                if is_max:
                    res = b if (b > a) else a
                else:
                    res = b if (b < a) else a
                res_bits = self._numpy_to_bits(res, res_prec)
            vd_int |= self._pack_elem(res_bits, res_width, i)
        return vd_int

    def _predict_sgn(self, input_tx) -> int:
        vd_int = 0
        res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
        for i, pair in enumerate(input_tx.fp_pairs_list):
            # Extract sign and payload according to precision
            def inject_sign(bits, prec, sign):
                if prec == FpPrecision.FP32:
                    return ((sign & 1) << 31) | (bits & 0x7FFFFFFF)
                else:
                    # FP16/BF16 both 1 sign bit at MSB of 16
                    return ((sign & 1) << 15) | (bits & 0x7FFF)

            a_bits = pair.a.val_bits
            b_bits = pair.b.val_bits
            if input_tx.sew_type == SewType.FP32:
                a_sign = (a_bits >> 31) & 1
                b_sign = (b_bits >> 31) & 1
                prec = FpPrecision.FP32
            else:
                a_sign = (a_bits >> 15) & 1
                b_sign = (b_bits >> 15) & 1
                prec = FpPrecision.FP16 if input_tx.sew_type == SewType.FP16 else FpPrecision.BF16

            if input_tx.uop_type == UopType.VFSGNJ:
                res_sign = b_sign
            elif input_tx.uop_type == UopType.VFSGNJN:
                res_sign = b_sign ^ 1
            else:  # VFSGNJX
                res_sign = a_sign ^ b_sign

            res_bits = inject_sign(a_bits, prec, res_sign)
            vd_int |= self._pack_elem(res_bits, res_width, i)
        return vd_int

    def _predict_move(self, input_tx) -> int:
        # vfmv.f.v: broadcast rs1 to all elements
        vd_int = 0
        res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
        rs1 = int(input_tx.payload.rs1)
        # Extract element-sized value from rs1 low bits according to SEW
        elem = (rs1 & ((1 << res_width) - 1))
        num_elems = 2 if res_width == 32 else 4
        for i in range(num_elems):
            vd_int |= self._pack_elem(elem, res_width, i)
        return vd_int

    def _predict_copy_vs2(self, input_tx) -> int:
        vd_int = 0
        res_width = 32 if input_tx.sew_type == SewType.FP32 else 16
        # VFMV.F.S moves the first element of VS2 to scalar RD
        if input_tx.fp_pairs_list:
            vd_int = self._pack_elem(input_tx.fp_pairs_list[0].b.val_bits, res_width, 0)
        return vd_int
    def _predict_compare(self, input_tx) -> int:
        # Compare semantics: mask[i] = (vs2 op vs1)
        # Pack mask bits into low 2 or 4 bits of 64-bit vd
        vd_mask = 0
        num_elems = 2 if input_tx.sew_type == SewType.FP32 else 4
        for i, pair in enumerate(input_tx.fp_pairs_list):
            a = self._bits_to_numpy(pair.a.val_bits, pair.a.precision)
            b = self._bits_to_numpy(pair.b.val_bits, pair.b.precision)
            a_nan = np.isnan(float(np.array(a)))
            b_nan = np.isnan(float(np.array(b)))
            lhs = b  # vs2
            rhs = a  # vs1
            bit = 0
            if input_tx.uop_type == UopType.VMFEQ:
                bit = 1 if (not a_nan and not b_nan and lhs == rhs) else 0
            elif input_tx.uop_type == UopType.VMFNE:
                bit = 1 if (a_nan or b_nan or lhs != rhs) else 0
            elif input_tx.uop_type == UopType.VMFLT:
                bit = 1 if (not a_nan and not b_nan and lhs < rhs) else 0
            elif input_tx.uop_type == UopType.VMFLE:
                bit = 1 if (not a_nan and not b_nan and lhs <= rhs) else 0
            elif input_tx.uop_type == UopType.VMFGE:
                bit = 1 if (not a_nan and not b_nan and lhs >= rhs) else 0
            elif input_tx.uop_type == UopType.VMFGT:
                bit = 1 if (not a_nan and not b_nan and lhs > rhs) else 0
            vd_mask |= (bit & 1) << i
        # Mask is in low bits, remaining bits zero
        return vd_mask

    def report_summary(self):
        self.prj_reporter.report_msg("vfadd_rm", "--- Checker Summary ---", prj_reporter.ReportLevel.NONE)
        self.prj_reporter.report_msg("vfadd_rm", f"Passed: {self.pass_count}", prj_reporter.ReportLevel.NONE)
        self.prj_reporter.report_msg("vfadd_rm", f"Failed: {self.fail_count}", prj_reporter.ReportLevel.NONE)
        try:
            cov_dict = self.cov.as_dict()
            self.prj_reporter.report_msg("vfadd_rm", f"Func Coverage: {cov_dict}", prj_reporter.ReportLevel.NONE)
        except Exception:
            pass
