"""
Base Sequence for VFAdd Verification.

This module defines the base sequence class responsible for generating
and sending transactions to the driver's sequencer.
"""

import vsc
import asyncio
from collections import deque
from typing import Optional
from env.vfadd_xaction import vfadd_xaction
from env.common import prj_reporter


@vsc.randobj
class vfadd_base_seq:
    """
    Base sequence class for generating VFAdd transactions.
    """

    # Random variables
    xaction_queue: Optional[deque] = None
    xaction_num: vsc.rand_uint64_t

    def __init__(self, agent):
        """
        Initialize the sequence.

        Args:
            agent: The agent to drive transactions.
        """
        self.agent = agent
        self.prj_reporter = prj_reporter.get_reporter()
        
        # Local queue for buffering transactions
        self.xaction_queue = deque()

        # Config base seq random variables
        self.xaction_num = vsc.rand_uint64_t()

    @vsc.constraint
    def tc_base_seq_c(self):
        """Constraints for sequence configuration."""
        vsc.soft(self.xaction_num == 10)

    def gen_xaction(self):
        """Generate a random transaction."""
        tx = vfadd_xaction()
        tx.randomize()
        return tx
    
    def add_xaction(self, xaction_num: int):
        """
        Generate transactions and put them into the local queue.

        Args:
            xaction_num: The number of transactions to generate.
        """
        topic = "tc_base_seq.add_xaction"

        self.prj_reporter.report_msg(
            topic, f"Generating {xaction_num} transactions", prj_reporter.ReportLevel.NONE
        )

        current_id = 0
        count = xaction_num

        while count > 0:
            current_id += 1

            # Create and randomize transaction
            tx = self.gen_xaction()
            tx.transaction_id = current_id

            # Put to local queue
            self.xaction_queue.append(tx)

            # Log transaction
            self.prj_reporter.report_msg(
                topic, f"Generated transaction: {tx.report()}", prj_reporter.ReportLevel.MEDIUM
            )

            count -= 1

        self.prj_reporter.report_msg(
            topic, "Finished generating transactions", prj_reporter.ReportLevel.NONE
        )

        # Send Sentinel (None) to signal end of generation
        self.xaction_queue.append(None)

    async def send_xaction(self):
        """
        Retrieve transactions from local queue and send to agent.
        """
        topic = "tc_base_seq.send_xaction"
        
        while True:
            try:
                tx = self.xaction_queue.popleft()
            except IndexError:
                break

            if tx is None:
                break
            
            await self.agent.drive(tx)
            self.prj_reporter.report_msg(topic, f"Sent transaction to agent: ID={tx.transaction_id}", prj_reporter.ReportLevel.MEDIUM)

    async def run(self):
        """
        Run the sequence: generate and send.
        """
        self.add_xaction(self.xaction_num)
        await self.send_xaction()


