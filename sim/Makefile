.PHONY: run clean help regress

# ==============================================================================
# Configuration
# ==============================================================================
# 项目根目录 (相对于 sim 目录)
ROOT_DIR = ..

# 报告输出目录 (相对于 sim 目录)
REPORT_DIR ?= report
REPORT_LEVEL ?= LOW
PYTEST_OPTS ?=

# 输入参数
tc ?= 
seed ?= 0
wave ?= on

# ==============================================================================
# Targets
# ==============================================================================

help:
	@echo "Usage (run inside sim/ directory):"
	@echo "  make run tc=NAME [seed=N] [wave=on] - Run specific test case"
	@echo "  make -f regress.mk regress tl.lst [REG_WAVE=on] - Run tl file"
	@echo "  make regress ./path/to.tl.lst [REG_JOBS=N] - Simple regression"
	@echo "  make verdi tc=NAME [seed=N]         - Open waveform in Verdi"
	@echo "  make clean                          - Clean generated reports and cache"
	@echo ""
	@echo "Example:"
	@echo "  make run tc=test_sanity seed=1234 wave=on"
	@echo "  make verdi tc=test_sanity seed=1234"

# Run Test Case
run:
	@if [ -z "$(tc)" ]; then \
		echo "Error: Please specify a test case using 'tc=NAME'"; \
		exit 1; \
	fi
	@# Define run-specific report directory
	$(eval RUN_DIR := $(REPORT_DIR)/$(tc)_$(seed)_report)
	@mkdir -p $(RUN_DIR)
	@echo "========================================================"
	@echo "Running Test : $(tc)"
	@echo "Random Seed  : $(seed)"
	@echo "Output Dir   : $(RUN_DIR)"
	@echo "Log File     : $(RUN_DIR)/$(tc)_$(seed).log"
	@echo "Report File  : $(RUN_DIR)/report_$(tc)_$(seed).html"
	@echo "========================================================"
	@# PYTHONPATH 设置说明：
	@# 1. $(ROOT_DIR): 用于找到 env/ 和 bundles/ 模块
	@# 2. .          : 用于找到当前目录下可能存在的 LaneFAdd 包 (如果 DUT 是在这里编译的)
	@SEED=$(seed) \
	REPORT_LEVEL=$(REPORT_LEVEL) \
	LOG_PATH=$(RUN_DIR)/$(tc)_$(seed).log \
	PYTHONPATH=$(ROOT_DIR):. \
	python3 -m pytest -s \
		$(PYTEST_OPTS) \
		-k "$(tc)" \
		--toffee-report \
		--report-dir=$(RUN_DIR) \
		--report-name=report_$(tc)_$(seed).html \
		$(ROOT_DIR)/tests/ \
		2>&1 | tee $(RUN_DIR)/$(tc)_$(seed).log
	@if [ "$(wave)" = "on" ]; then \
		if command -v vcd2fsdb >/dev/null 2>&1; then \
			for vcd in $$(find $(RUN_DIR) -name "*.vcd" 2>/dev/null); do \
				fsdb=$${vcd%.vcd}_$(seed).fsdb; \
				echo "Converting $$vcd -> $$fsdb"; \
				vcd2fsdb $$vcd -o $$fsdb; \
			done; \
		else \
			echo "vcd2fsdb not found, skipping waveform conversion"; \
		fi; \
	fi

# Open Verdi
verdi:
	@if [ -z "$(tc)" ]; then \
		echo "Error: Please specify a test case using 'tc=NAME'"; \
		exit 1; \
	fi
	@RUN_DIR=$(REPORT_DIR)/$(tc)_$(seed)_report; \
	if [ ! -d "$$RUN_DIR" ]; then \
		echo "Error: Report directory '$$RUN_DIR' does not exist. Run the test first."; \
		exit 1; \
	fi; \
	FSDB_FILE=$$(find $$RUN_DIR -name "*_$(seed).fsdb" 2>/dev/null | head -n 1); \
	if [ -z "$$FSDB_FILE" ]; then \
		echo "Error: No FSDB file found in '$$RUN_DIR'. Did you run with wave=on?"; \
		exit 1; \
	fi; \
	echo "Opening Waveform: $$FSDB_FILE"; \
	verdi -rcFile rcfile/novas.rc -f rtl.lst -ssf $$FSDB_FILE &

clean:
	@rm -rf __pycache__ .pytest_cache
	@rm -rf $(REPORT_DIR)
