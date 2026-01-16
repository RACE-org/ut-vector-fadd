from toffee.agent import *
from env.common import prj_reporter
from asyncio import Queue
import asyncio
from env.vfadd_xaction import InputPayload, OutputPayload, Uop, UopCtrl, UopCsr, SewInput, vfadd_xaction
from env.vfadd_xaction import UopType

class vfadd_master_agent(Agent):
    def __init__(self, vfadd_bundle, name="vfadd_master_agent"):
        super().__init__(vfadd_bundle)
        self.name = name
        self.prj_reporter = prj_reporter.get_reporter()
        self.tx_counter = 0
        
    @driver_method()
    async def drive(self, trans):
        "Report driving transaction"
        self.prj_reporter.report_msg(
            f"{self.name}", f"Driving transaction: {trans.report()}", prj_reporter.ReportLevel.MEDIUM
        )
        # 1. Drive Input Payload (Operands)
        self.bundle.input.bits.vs1.value = trans.payload.vs1
        self.bundle.input.bits.vs2.value = trans.payload.vs2
        self.bundle.input.bits.vs3.value = trans.payload.vs3
        self.bundle.input.bits.rs1.value = trans.payload.rs1
        
        # 2. Drive Uop Control
        ctrl = trans.payload.uop.ctrl
        self.bundle.input.bits.uop.ctrl.funct6.value = ctrl.funct6
        self.bundle.input.bits.uop.ctrl.funct3.value = ctrl.funct3
        self.bundle.input.bits.uop.ctrl.vm.value = ctrl.vm
        self.bundle.input.bits.uop.ctrl.fp.value = ctrl.fp
        self.bundle.input.bits.uop.ctrl.arith.value = ctrl.arith
        self.bundle.input.bits.uop.ctrl.vfadd.value = ctrl.vfadd
        self.bundle.input.bits.uop.ctrl.widen.value = ctrl.widen
        self.bundle.input.bits.uop.ctrl.widen2.value = ctrl.widen2
        self.bundle.input.bits.uop.ctrl.mask.value = ctrl.mask
        self.bundle.input.bits.uop.ctrl.lsrc_0.value = ctrl.lsrc_0
        self.bundle.input.bits.uop.ctrl.lsrc_1.value = ctrl.lsrc_1
        self.bundle.input.bits.uop.ctrl.ldest.value = ctrl.ldest
        self.bundle.input.bits.uop.ctrl.illegal.value = ctrl.illegal
        self.bundle.input.bits.uop.ctrl.lsrcVal_0.value = ctrl.lsrcVal_0
        self.bundle.input.bits.uop.ctrl.lsrcVal_1.value = ctrl.lsrcVal_1
        self.bundle.input.bits.uop.ctrl.lsrcVal_2.value = ctrl.lsrcVal_2
        self.bundle.input.bits.uop.ctrl.ldestVal.value = ctrl.ldestVal
        self.bundle.input.bits.uop.ctrl.load.value = ctrl.load
        self.bundle.input.bits.uop.ctrl.store.value = ctrl.store
        self.bundle.input.bits.uop.ctrl.crossLane.value = ctrl.crossLane
        self.bundle.input.bits.uop.ctrl.alu.value = ctrl.alu
        self.bundle.input.bits.uop.ctrl.mul.value = ctrl.mul
        self.bundle.input.bits.uop.ctrl.div.value = ctrl.div
        self.bundle.input.bits.uop.ctrl.fixP.value = ctrl.fixP
        self.bundle.input.bits.uop.ctrl.redu.value = ctrl.redu
        self.bundle.input.bits.uop.ctrl.perm.value = ctrl.perm
        self.bundle.input.bits.uop.ctrl.vfma.value = ctrl.vfma
        self.bundle.input.bits.uop.ctrl.vfcvt.value = ctrl.vfcvt
        self.bundle.input.bits.uop.ctrl.narrow.value = ctrl.narrow
        self.bundle.input.bits.uop.ctrl.narrow_to_1.value = ctrl.narrow_to_1
        from env.vfadd_xaction import UopType
        self.bundle.input.bits.uop.ctrl.rdVal.value = 1 if trans.uop_type == UopType.VFMV_F_S else 0

        uop = trans.payload.uop
        self.bundle.input.bits.uop.robIdx_flag.value = uop.robIdx_flag
        self.bundle.input.bits.uop.robIdx_value.value = uop.robIdx_value
        self.bundle.input.bits.uop.veewVd.value = uop.veewVd
        self.bundle.input.bits.uop.lsrcUop_0.value = uop.lsrcUop_0
        self.bundle.input.bits.uop.lsrcUop_1.value = uop.lsrcUop_1
        self.bundle.input.bits.uop.lsrcValUop_0.value = uop.lsrcValUop_0
        self.bundle.input.bits.uop.lsrcValUop_1.value = uop.lsrcValUop_1
        self.bundle.input.bits.uop.lsrcValUop_2.value = uop.lsrcValUop_2
        self.bundle.input.bits.uop.ldestUop.value = uop.ldestUop
        self.bundle.input.bits.uop.lmaskValUop.value = uop.lmaskValUop
        self.bundle.input.bits.uop.ldestValUop.value = uop.ldestValUop
        # 3. Drive Uop CSR & Misc
        csr = trans.payload.uop.csr
        self.bundle.input.bits.uop.csr.vstart.value = csr.vstart
        self.bundle.input.bits.uop.csr.vl.value = csr.vl
        self.bundle.input.bits.uop.csr.vxrm.value = csr.vxrm
        self.bundle.input.bits.uop.csr.frm.value = csr.frm
        self.bundle.input.bits.uop.csr.vlmul.value = csr.vlmul
        self.bundle.input.bits.uop.csr.vsew.value = csr.vsew
        self.bundle.input.bits.uop.csr.vill.value = csr.vill
        self.bundle.input.bits.uop.csr.ma.value = csr.ma
        self.bundle.input.bits.uop.csr.ta.value = csr.ta
        self.bundle.input.bits.uop.uopIdx.value = trans.payload.uop.uopIdx
        self.bundle.input.bits.uop.uopEnd.value = trans.payload.uop.uopEnd

        # 4. Drive SEW
        self.bundle.sewIn.oneHot_0.value = trans.sew.oneHot_0
        self.bundle.sewIn.oneHot_1.value = trans.sew.oneHot_1
        self.bundle.sewIn.oneHot_2.value = trans.sew.oneHot_2
        self.bundle.sewIn.oneHot_3.value = trans.sew.oneHot_3
        
        # 5. Drive Valid
        self.bundle.input.valid.value = trans.valid
        
        await self.bundle.step()
        # 6. De-assert valid and wait delay cycles
        await asyncio.sleep(0)
        self.bundle.set_all(0)
        await self.bundle.step(trans.delay)
    
    @monitor_method()
    async def monitor_in(self):
        self.prj_reporter.report_msg(f"{self.name}.monitor", f"Checking input valid: {self.bundle.input.valid.value}", prj_reporter.ReportLevel.MEDIUM)
        if self.bundle.input.valid.value == 1:
            # Capture Input Payload
            payload = InputPayload()
            payload.vs1 = self.bundle.input.bits.vs1.value
            payload.vs2 = self.bundle.input.bits.vs2.value
            payload.vs3 = self.bundle.input.bits.vs3.value
            payload.rs1 = self.bundle.input.bits.rs1.value

            # Directly print bundle value
            self.prj_reporter.report_msg(f"{self.name}.monitor", 
                                         f"Bundle Input Bits: vs1={self.bundle.input.bits.vs1.value:x}, vs2={self.bundle.input.bits.vs2.value:x}, rs1={self.bundle.input.bits.rs1.value:x}", prj_reporter.ReportLevel.MEDIUM)
            # Capture Uop
            payload.uop = Uop()
            payload.uop.ctrl = UopCtrl()
            payload.uop.csr = UopCsr()

            # Capture Control Signals
            payload.uop.ctrl.funct6 = self.bundle.input.bits.uop.ctrl.funct6.value
            payload.uop.ctrl.funct3 = self.bundle.input.bits.uop.ctrl.funct3.value
            payload.uop.ctrl.vm = self.bundle.input.bits.uop.ctrl.vm.value
            payload.uop.ctrl.fp = self.bundle.input.bits.uop.ctrl.fp.value
            payload.uop.ctrl.arith = self.bundle.input.bits.uop.ctrl.arith.value
            payload.uop.ctrl.vfadd = self.bundle.input.bits.uop.ctrl.vfadd.value
            payload.uop.ctrl.widen = self.bundle.input.bits.uop.ctrl.widen.value
            payload.uop.ctrl.widen2 = self.bundle.input.bits.uop.ctrl.widen2.value  
            payload.uop.ctrl.mask = self.bundle.input.bits.uop.ctrl.mask.value
            payload.uop.ctrl.lsrc_0 = self.bundle.input.bits.uop.ctrl.lsrc_0.value
            payload.uop.ctrl.lsrc_1 = self.bundle.input.bits.uop.ctrl.lsrc_1.value
            payload.uop.ctrl.ldest = self.bundle.input.bits.uop.ctrl.ldest.value
            payload.uop.ctrl.illegal = self.bundle.input.bits.uop.ctrl.illegal.value
            payload.uop.ctrl.lsrcVal_0 = self.bundle.input.bits.uop.ctrl.lsrcVal_0.value
            payload.uop.ctrl.lsrcVal_1 = self.bundle.input.bits.uop.ctrl.lsrcVal_1.value
            payload.uop.ctrl.lsrcVal_2 = self.bundle.input.bits.uop.ctrl.lsrcVal_2.value
            payload.uop.ctrl.ldestVal = self.bundle.input.bits.uop.ctrl.ldestVal.value
            payload.uop.ctrl.load = self.bundle.input.bits.uop.ctrl.load.value
            payload.uop.ctrl.store = self.bundle.input.bits.uop.ctrl.store.value
            payload.uop.ctrl.crossLane = self.bundle.input.bits.uop.ctrl.crossLane.value
            payload.uop.ctrl.alu = self.bundle.input.bits.uop.ctrl.alu.value
            payload.uop.ctrl.mul = self.bundle.input.bits.uop.ctrl.mul.value
            payload.uop.ctrl.div = self.bundle.input.bits.uop.ctrl.div.value
            payload.uop.ctrl.fixP = self.bundle.input.bits.uop.ctrl.fixP.value
            payload.uop.ctrl.redu = self.bundle.input.bits.uop.ctrl.redu.value
            payload.uop.ctrl.perm = self.bundle.input.bits.uop.ctrl.perm.value
            payload.uop.ctrl.vfma = self.bundle.input.bits.uop.ctrl.vfma.value
            payload.uop.ctrl.vfcvt = self.bundle.input.bits.uop.ctrl.vfcvt.value
            payload.uop.ctrl.narrow = self.bundle.input.bits.uop.ctrl.narrow.value
            payload.uop.ctrl.narrow_to_1 = self.bundle.input.bits.uop.ctrl.narrow_to_1.value

            # Capture CSR Signals
            payload.uop.csr.vl = self.bundle.input.bits.uop.csr.vl.value
            payload.uop.csr.frm = self.bundle.input.bits.uop.csr.frm.value
            payload.uop.csr.vstart = self.bundle.input.bits.uop.csr.vstart.value
            payload.uop.csr.vxrm = self.bundle.input.bits.uop.csr.vxrm.value
            payload.uop.csr.vlmul = self.bundle.input.bits.uop.csr.vlmul.value
            payload.uop.csr.vsew = self.bundle.input.bits.uop.csr.vsew.value
            payload.uop.csr.vill = self.bundle.input.bits.uop.csr.vill.value
            payload.uop.csr.ma = self.bundle.input.bits.uop.csr.ma.value
            payload.uop.csr.ta = self.bundle.input.bits.uop.csr.ta.value

            # Capture Misc
            payload.uop.uopIdx = self.bundle.input.bits.uop.uopIdx.value
            payload.uop.uopEnd = self.bundle.input.bits.uop.uopEnd.value

            # Capture SEW
            sew = SewInput()
            sew.oneHot_0 = self.bundle.sewIn.oneHot_0.value
            sew.oneHot_1 = self.bundle.sewIn.oneHot_1.value
            sew.oneHot_2 = self.bundle.sewIn.oneHot_2.value
            sew.oneHot_3 = self.bundle.sewIn.oneHot_3.value

            # Reconstruct Transaction
            monitored_tx = vfadd_xaction()
            monitored_tx.set_from_payload(payload, sew)
            monitored_tx.valid = 1
            # add timestamp used by report()
            monitored_tx.timestamp = self.prj_reporter.get_timestamp()
            monitored_tx.transaction_id = self.tx_counter
            self.tx_counter += 1
            # Report origin payload for Debug
            self.prj_reporter.report_msg(f"{self.name}.monitor", 
                                         f"Captured Input Transaction: {monitored_tx.report()}", prj_reporter.ReportLevel.MEDIUM)
            return monitored_tx
