.PHONY: dut clean_dut

dut:
	picker export ./rtl/LaneFAdd.v --rw 1 --sim verilator --lang python -c -w LaneFAdd.fst

clean_dut:
	@rm -rf LaneFAdd

