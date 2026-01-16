import asyncio
from toffee.env import *
from env.common import prj_reporter
from .vfadd_master_agent import *
from .vfadd_slave_agent import *
from .vfadd_rm import vfadd_rm


class vfadd_env(Env):
    """vfadd_env环境类的示例."""
    def __init__(self, vfadd_bundle, name="vfadd_env"):
        super().__init__()
        self.name = name
        self.vfadd_master_agent = vfadd_master_agent(vfadd_bundle, name="vfadd_master_agent")
        self.vfadd_slave_agent = vfadd_slave_agent(vfadd_bundle, name="vfadd_slave_agent")
        self.prj_reporter = prj_reporter.get_reporter()
        self.vfadd_rm = vfadd_rm()
        
        # Attach Reference Model
        self.attach(self.vfadd_rm)
    
    async def run(self):
        # Environment logic is handled by Toffee framework (Agents & Models)
        # Keep this alive for BaseTestCase compatibility if needed, or remove.
        # For now, just wait forever until cancelled.
        await asyncio.Event().wait()

        
        