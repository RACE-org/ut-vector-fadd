from toffee.agent import *
from env.common import prj_reporter
from asyncio import Queue
from env.vfadd_xaction import OutputPayload, Uop, UopCtrl, UopCsr

class vfadd_slave_agent(Agent):
    """vfadd_slave_agent: Monitors the output interface."""
    def __init__(self, vfadd_bundle, name="vfadd_slave_agent"):
        super().__init__(vfadd_bundle)
        self.name = name
        self.prj_reporter = prj_reporter.get_reporter()
        self.tx_counter = 0

    @monitor_method()
    async def monitor_out(self):
        if self.bundle.output.valid.value == 1 or self.bundle.rd.valid.value == 1:
            # Capture Output Payload
            payload = OutputPayload()
           
            payload.vd = self.bundle.output.bits.vd.value
            payload.fflags_0 = self.bundle.output.bits.fflags_0.value
            payload.fflags_1 = self.bundle.output.bits.fflags_1.value
            payload.fflags_2 = self.bundle.output.bits.fflags_2.value
            payload.fflags_3 = self.bundle.output.bits.fflags_3.value
            payload.uop = Uop()
            payload.uop.ctrl = UopCtrl()
            payload.uop.csr = UopCsr()
            payload.uop.ctrl.funct6 = self.bundle.output.bits.uop.ctrl.funct6.value
            payload.uop.ctrl.funct3 = self.bundle.output.bits.uop.ctrl.funct3.value
            payload.uop.ctrl.vm = self.bundle.output.bits.uop.ctrl.vm.value
            payload.uop.ctrl.fp = self.bundle.output.bits.uop.ctrl.fp.value
            payload.uop.ctrl.arith = self.bundle.output.bits.uop.ctrl.arith.value
            payload.uop.ctrl.vfadd = self.bundle.output.bits.uop.ctrl.vfadd.value
            payload.uop.ctrl.widen = self.bundle.output.bits.uop.ctrl.widen.value
            payload.uop.ctrl.widen2 = self.bundle.output.bits.uop.ctrl.widen2.value
            payload.uop.ctrl.mask = self.bundle.output.bits.uop.ctrl.mask.value
            payload.uop.ctrl.lsrc_0 = self.bundle.output.bits.uop.ctrl.lsrc_0.value
            payload.uop.ctrl.lsrc_1 = self.bundle.output.bits.uop.ctrl.lsrc_1.value
            payload.uop.ctrl.ldest = self.bundle.output.bits.uop.ctrl.ldest.value
            payload.uop.ctrl.illegal = self.bundle.output.bits.uop.ctrl.illegal.value
            payload.uop.ctrl.lsrcVal_0 = self.bundle.output.bits.uop.ctrl.lsrcVal_0.value
            payload.uop.ctrl.lsrcVal_1 = self.bundle.output.bits.uop.ctrl.lsrcVal_1.value
            payload.uop.ctrl.lsrcVal_2 = self.bundle.output.bits.uop.ctrl.lsrcVal_2.value
            payload.uop.ctrl.ldestVal = self.bundle.output.bits.uop.ctrl.ldestVal.value
            payload.uop.ctrl.load = self.bundle.output.bits.uop.ctrl.load.value
            payload.uop.ctrl.store = self.bundle.output.bits.uop.ctrl.store.value
            payload.uop.ctrl.crossLane = self.bundle.output.bits.uop.ctrl.crossLane.value
            payload.uop.ctrl.alu = self.bundle.output.bits.uop.ctrl.alu.value
            payload.uop.ctrl.mul = self.bundle.output.bits.uop.ctrl.mul.value
            payload.uop.ctrl.div = self.bundle.output.bits.uop.ctrl.div.value
            payload.uop.ctrl.fixP = self.bundle.output.bits.uop.ctrl.fixP.value
            payload.uop.ctrl.redu = self.bundle.output.bits.uop.ctrl.redu.value
            payload.uop.ctrl.perm = self.bundle.output.bits.uop.ctrl.perm.value
            payload.uop.ctrl.vfma = self.bundle.output.bits.uop.ctrl.vfma.value
            payload.uop.ctrl.vfcvt = self.bundle.output.bits.uop.ctrl.vfcvt.value
            payload.uop.ctrl.narrow = self.bundle.output.bits.uop.ctrl.narrow.value
            payload.uop.ctrl.narrow_to_1 = self.bundle.output.bits.uop.ctrl.narrow_to_1.value
            payload.uop.csr.vl = self.bundle.output.bits.uop.csr.vl.value
            payload.uop.csr.frm = self.bundle.output.bits.uop.csr.frm.value
            payload.uop.csr.vstart = self.bundle.output.bits.uop.csr.vstart.value
            payload.uop.csr.vxrm = self.bundle.output.bits.uop.csr.vxrm.value
            payload.uop.csr.vlmul = self.bundle.output.bits.uop.csr.vlmul.value
            payload.uop.csr.vsew = self.bundle.output.bits.uop.csr.vsew.value
            payload.uop.csr.vill = self.bundle.output.bits.uop.csr.vill.value
            payload.uop.csr.ma = self.bundle.output.bits.uop.csr.ma.value
            payload.uop.csr.ta = self.bundle.output.bits.uop.csr.ta.value
            payload.uop.uopIdx = self.bundle.output.bits.uop.uopIdx.value
            payload.uop.uopEnd = self.bundle.output.bits.uop.uopEnd.value
                
            payload.transaction_id = self.tx_counter
            self.tx_counter += 1
            payload.rd_valid = self.bundle.rd.valid.value
            payload.rd_bits = self.bundle.rd.bits.value
            vd_str = f"0x{int(payload.vd):016x}" if self.bundle.output.valid.value == 1 else "N/A"
            rd_bits_str = f"0x{int(payload.rd_bits):016x}" if int(payload.rd_valid) == 1 else "N/A"
            uop_str = ""
            if self.bundle.output.valid.value == 1:
                uop_str = f" funct6=0b{int(payload.uop.ctrl.funct6):06b} funct3=0b{int(payload.uop.ctrl.funct3):03b} uopIdx={int(payload.uop.uopIdx)} uopEnd={int(payload.uop.uopEnd)}"
            self.prj_reporter.report_msg(
                f"{self.name}.monitor",
                f"Captured Output: ID={int(payload.transaction_id)} VD={vd_str} RD_valid={int(payload.rd_valid)} RD_bits={rd_bits_str}{uop_str}",
                prj_reporter.ReportLevel.MEDIUM
            )
            return payload
    
    
