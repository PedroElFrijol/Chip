GHDL = /usr/bin/ghdl
GHDL_FLAGS = --ieee=synopsys --warn-no-vital-generic --workdir=simu --work=work
GTKWAVE = /usr/bin/gtkwave
VHDL = $(wildcard ../VHDL/*.vhd)
TESTBENCH = $(wildcard src/testbench/*.vhd)
SIMFILES = testbench/tb_cpu.vhd
SIMTOP = tb_cpu
GHDL_SIM_OPT = --assert-level=error # Assert level at which to stop simulation (none|note|warning|error|failure), i.e. ./touchy_design --assert-level=note
SRCDIR = src
OFILES = $(VHDLFILES:.vhd=.o) $(TBFILES:.vhd=.o)

.PHONY: clean

compile: $(VHDL) $(TESTBENCH)
	mkdir -p ghdl
	$(GHDL) -i $(GHDL_FLAGS) --workdir=simu --work=work $(SIMFILES) $(VHDL)
	$(GHDL) -m $(GHDL_FLAGS) --workdir=simu --work=work $(SIMTOP)

run:
	@$(SIMDIR)/$(SIMTOP) $(GHDL_SIM_OPT) --vcdgz=$(SIMDIR)/$(SIMTOP).vcdgz 

view:
	gunzip --stdout $(SIMDIR)/$(SIMTOP).vcdgz | $(GTKWAVE) --vcd

clean:
	@rm -rf $(GHDL) --clean --workdir=simu