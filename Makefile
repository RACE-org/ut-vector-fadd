.PHONY: dut clean_dut

dut:
	picker export ./rtl/LaneFAdd.sv --rw 1 --sim verilator --lang python -c -w LaneFAdd.vcd -V --trace-underscore

clean_dut:
	@rm -rf LaneFAdd

.PHONY: regress
regress:
	@TL_ARG=$$(echo "$(MAKECMDGOALS)" | awk '{for(i=1;i<=NF;i++) if($$i!="regress") {print $$i; exit}}'); \
	if [ -z "$$TL_ARG" ]; then \
		echo "Usage: make regress <path/to.tl.lst> [REG_JOBS=N] [REG_WAVE=on|off]"; \
		exit 1; \
	fi; \
	$(MAKE) -C sim regress $$TL_ARG
