.PHONY: dut clean_dut

dut:
	picker export ./rtl/LaneFAdd.sv --rw 1 --sim verilator --lang python -c -w LaneFAdd.vcd -V --trace-underscore

clean_dut:
	@rm -rf LaneFAdd

