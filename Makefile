.PHONY: all
all: flash-uart_hello

memory_tb.out: uart_memory.v
controller_tb.out: uart_memory.v

.PRECIOUS: %.bin %.vcd

%.blif: %.v
	yosys -q -p "synth_ice40 -blif $@" $<

%.txt: icestick.pcf %.blif
	arachne-pnr -p icestick.pcf $*.blif -o $@

%.bin: %.txt
	icepack $*.txt $@

%.vcd: %.out
	./$<

%.out: %.v
	iverilog $< -o $@

.PHONY: prog-%
flash-%: %.bin
	iceprog $<

.PHONY: sim-%
sim-%: %.vcd
	gtkwave $<

.PHONY: run-%
run-%: %.out
	./$<

.PHONY: clean
clean:
	rm *.bin *.blif *.txt
