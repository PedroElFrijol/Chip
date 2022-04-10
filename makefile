GHDL = ../bin/ghdl
GHDLFLAGS = --ieee=standard --std=08 --workdir=ghdlwork
VHDL = $(wildcard ../VHDL/*.vhd)
TESTBENCH = $(wildcard cpu/*.vhd)
TB = tb_cpu
OFILES = $(VHDLFILES:.vhd=.o) $(TBFILES:.vhd=.o)

tb_cpu: $(VHDL) $(TESTBENCH)
	mkdir -p ghdl
	$(GHDL) -i $(GHDLFLAGS) $^
	$(GHDL) -m $(GHDLFLAGS) $(TB)
	$(GHDL) -r $(GHDLFLAGS) $(TB) --stop-time=1ms --vcd=system_tb.vcdgz | grep -v VHDL