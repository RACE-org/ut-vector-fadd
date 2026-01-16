import asyncio
from env.vfadd_pkg import vfadd_env
from env.common.prj_reporter import get_reporter, ReportLevel

class BaseTestCase:  # Renamed from BaseTest
    """
    Base test class for VFAdd verification.
    Handles setup, reset, and environment instantiation.
    """
    def __init__(self, setup_fixture):
        self.dut, self.io_bundle = setup_fixture
        self.reporter = get_reporter()
        self.env = None
        self.seq = None
        self.fail_count = None

    async def run_reset(self):
        """Standard reset sequence."""
        self.dut.reset.value = 1
        await self.io_bundle.step(5)
        self.dut.reset.value = 0
        await self.io_bundle.step()

    async def setup_env(self):
        """Instantiate the environment."""
        self.env = vfadd_env(self.io_bundle)

    async def run_sequence(self):
        """
        Run the sequence and agent. 
        Child classes should instantiate self.seq before calling this.
        """
        if not self.seq:
            self.reporter.report_msg("BaseTestCase", "No sequence defined!", ReportLevel.ERROR)
            return

        self.seq.randomize()
        
        # Start environment in background
        env_task = asyncio.create_task(self.env.run())
        
        # Run sequence
        await self.seq.run()
        
        # Drain time: Wait for DUT to process remaining transactions
        self.reporter.report_msg("BaseTestCase", "Sequence finished, waiting for drain...", ReportLevel.MEDIUM)
        for _ in range(100):
            await self.io_bundle.step()
            
        # Cancel environment task
        self.reporter.report_msg("BaseTestCase", "Drain finished, stopping environment...", ReportLevel.MEDIUM)
        env_task.cancel()
        try:
            await env_task
        except asyncio.CancelledError:
            pass

    async def run(self):
        """Main execution flow."""
        self.reporter.report_msg(self.__class__.__name__, "Start Test", ReportLevel.MEDIUM)
        
        await self.run_reset()
        await self.setup_env()
        
        # Hook for child classes to define their sequence
        self.create_sequence()
        
        await self.run_sequence()
        
        self.reporter.report_msg(self.__class__.__name__, "Test Finished", ReportLevel.MEDIUM)
        self.fail_count = self.env.vfadd_rm.fail_count

    def create_sequence(self):
        """Override this in child classes."""
        raise NotImplementedError