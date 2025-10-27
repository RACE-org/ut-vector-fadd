import toffee_test
from toffee import start_clock

from LaneFAdd import DUTLaneFAdd
from bundles import LaneFAddBundle


@toffee_test.fixture
async def lanefadd_dut(toffee_request: toffee_test.ToffeeRequest) -> DUTLaneFAdd:
    dut = toffee_request.create_dut(DUTLaneFAdd, "clock")
    start_clock(dut)
    return dut


@toffee_test.testcase
async def test_basic_demo(lanefadd_dut: DUTLaneFAdd):
    dut = lanefadd_dut
    io_bundle = LaneFAddBundle.from_prefix("io_").bind(dut)
    io_bundle.set_all(0)

    dut.reset.value = 1
    await io_bundle.step(5)

    dut.reset.value = 0
    await io_bundle.step()

    assert io_bundle.output.valid.value == 0
