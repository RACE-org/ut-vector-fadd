import toffee.funcov as fc

_COV_GROUPS = {
    "COMMON": fc.CovGroup("VFAdd-COV-COMMON"),
    "ELEMENT": fc.CovGroup("VFAdd-COV-ELEMENT"),
    "FADD_SUB": fc.CovGroup("VFAdd-COV-FADD_SUB"),
    "WIDEN": fc.CovGroup("VFAdd-COV-WIDEN"),
    "FCMP": fc.CovGroup("VFAdd-COV-FCMP"),
    "MINMAX": fc.CovGroup("VFAdd-COV-MINMAX"),
    "SIGN": fc.CovGroup("VFAdd-COV-SIGN"),
    "FMV": fc.CovGroup("VFAdd-COV-FMV"),
}

def get_global_cov_group():
    return _COV_GROUPS["COMMON"]

def get_cov_group(name: str) -> fc.CovGroup:
    return _COV_GROUPS[name]

def get_all_cov_groups():
    return list(_COV_GROUPS.values())
