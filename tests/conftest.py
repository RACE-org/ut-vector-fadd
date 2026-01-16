import toffee_test
import os
import random
import hashlib
from toffee import start_clock
from LaneFAdd import DUTLaneFAdd
from bundles import LaneFAddBundle
from env.common.prj_reporter import Reporter, ReportLevel, get_reporter
from toffee_test.reporter import set_func_coverage
from tests.funcov_global import get_all_cov_groups


def init_covergroup(toffee_request: toffee_test.ToffeeRequest):
    for g in get_all_cov_groups():
        toffee_request.add_cov_groups(g)

def pytest_addoption(parser):
    g = parser.getgroup("vfadd")
    g.addoption("--seed", action="store", default=None)
    g.addoption("--tl", action="store", default=None)
    g.addoption("--reg-seed", action="store", default=None)
    g.addoption("--regress", action="store_true", default=False)
    g.addoption("--count", action="store", default=2)

def _parse_tl(path: str):
    items = []
    with open(path, "r") as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith("#"):
                continue
            parts = [p.strip() for p in s.split(",")]
            name = parts[0]
            count = int(parts[1]) if len(parts) > 1 and parts[1] else 1
            wave = None
            if len(parts) > 2 and parts[2] in ("wave=on", "wave=off"):
                wave = parts[2].split("=")[1]
            items.append((name, count, wave))
    return items

def _det_seed(reg_seed: int, nodeid: str, idx: int) -> int:
    h = hashlib.sha256(f"{int(reg_seed)}|{nodeid}|{int(idx)}".encode("utf-8")).digest()
    return int.from_bytes(h[:4], byteorder="little", signed=False)

def _get_reg_seed(config) -> int:
    cached = getattr(config, "_vfadd_reg_seed", None)
    if cached is not None:
        return int(cached)
    workerinput = getattr(config, "workerinput", None)
    if isinstance(workerinput, dict) and "vfadd_reg_seed" in workerinput:
        config._vfadd_reg_seed = int(workerinput["vfadd_reg_seed"])
        return int(config._vfadd_reg_seed)
    opt = config.getoption("--reg-seed")
    if opt is not None:
        base = int(opt)
    else:
        base = random.SystemRandom().getrandbits(32)
    config._vfadd_reg_seed = int(base)
    return int(base)

def pytest_configure_node(node):
    base = _get_reg_seed(node.config)
    node.workerinput["vfadd_reg_seed"] = int(base)

def pytest_configure(config):
    if config.getoption("--tl") or config.getoption("--regress"):
        if not hasattr(config, "workerinput"):
            base = _get_reg_seed(config)
            print(f"\n[Conftest] Regression base seed: {base}\n")

def pytest_generate_tests(metafunc):
    tl_path = metafunc.config.getoption("--tl")
    regress = bool(metafunc.config.getoption("--regress"))
    if not tl_path and not regress:
        return

    if tl_path and str(tl_path).lower() not in ("default", "all"):
        try:
            tl_items = _parse_tl(tl_path)
        except Exception:
            return

        nodeid = metafunc.definition.nodeid
        match = None
        for (name, count, wave) in tl_items:
            if name and (name in nodeid):
                match = (name, count, wave)
                break
        if match is None:
            return
        (_, count, wave) = match
    else:
        if "vfadd_setup" not in getattr(metafunc, "fixturenames", []):
            return
        count = int(metafunc.config.getoption("--count") or 5)
        wave = None

    nodeid = metafunc.definition.nodeid
    base = _get_reg_seed(metafunc.config)
    params = []
    ids = []
    for i in range(int(count)):
        seed = _det_seed(base, nodeid, i)
        params.append({"seed": seed, "wave": wave, "iter": i})
        ids.append(f"seed={seed}")
    metafunc.parametrize("vfadd_setup", params, indirect=True, ids=ids)

def pytest_collection_modifyitems(config, items):
    tl_path = config.getoption("--tl")
    if not tl_path:
        return
    if str(tl_path).lower() in ("default", "all"):
        return
    try:
        tl_items = _parse_tl(tl_path)
    except Exception:
        return
    if not tl_items:
        return
    names = [n for (n, _, _) in tl_items if n]
    kept = []
    for item in items:
        if any(n in item.nodeid for n in names):
            kept.append(item)
    items[:] = kept

@toffee_test.fixture
async def vfadd_setup(toffee_request: toffee_test.ToffeeRequest, request):
    """
    Fixture to setup the DUT environment:
    1. Bind IO bundle
    2. Initialize signals
    3. Setup default reporter
    
    Returns:
        tuple: (dut, io_bundle)
    """
    p = getattr(request, "param", None)
    if isinstance(p, dict) and "seed" in p:
        seed = int(p["seed"])
    else:
        opt_seed = request.config.getoption("--seed")
        if opt_seed is not None:
            seed = int(opt_seed)
        else:
            seed = int(os.environ.get("SEED", 0))
    os.environ["SEED"] = str(seed)
    random.seed(seed)

    dut = toffee_request.create_dut(DUTLaneFAdd, "clock")
    init_covergroup(toffee_request)
    start_clock(dut)
    io_bundle = LaneFAddBundle.from_prefix("io_").bind(dut)
    io_bundle.set_all(0)
    
    # Initialize functional coverage points and register sampling
    # Setup default reporter (can be re-configured in test if needed)
    Reporter.reset_instance()
    # Build log path: ./report/test_name_seed.log
    test_name = getattr(request.node, "originalname", None) or request.node.name
    log_dir = os.path.join(".", "report_log")
    os.makedirs(log_dir, exist_ok=True)
    log_file_path = os.path.join(log_dir, f"{test_name}_{seed}.log")
    reporter = get_reporter(log_file_path=log_file_path, dut=dut)
    
    # Set verbosity from environment variable
    report_level_str = os.environ.get("REPORT_LEVEL", "LOW").upper()
    try:
        report_level = getattr(ReportLevel, report_level_str)
    except AttributeError:
        print(f"\n[Conftest] Warning: Invalid REPORT_LEVEL '{report_level_str}', defaulting to LOW")
        report_level = ReportLevel.LOW
        
    reporter.set_verbosity(report_level)
    print(f"\n[Conftest] Report Level set to: {report_level.name}\n")

    # Report Pre-test info
    reporter.report_pre(test_name, seed)

    yield dut, io_bundle
    
    # Report Post-test info
    reporter.report_post()
    try:
        # 循环set_func_coverage
        for g in get_all_cov_groups():
            set_func_coverage(request, g)
    except Exception:
        pass
