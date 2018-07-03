
APP=mu0
TESTAPP=dp_test
OBJS=mu0.o datapath.o mux.o alu.o buffer.o reg_ppe.o ff_de.o memory.o
TEST=datapath_test.o

# Comandi automatici

all: app test

%.o: %.vhd
	ghdl -a --std=08 $<

$(APP): $(OBJS) $(FFIN_OBJS)
	ghdl -e --std=08 $(APP)

$(TESTAPP): $(OBJS) $(TEST) $(FFIN_OBJS)
	ghdl -e --std=08 $(TESTAPP)

# Comandi manuali

app: $(APP)

test: $(TESTAPP)

run: app
	ghdl -r $(APP) --vcd=out.vcd --stop-time=500ns

runtest: test
	ghdl -r $(TESTAPP) --vcd=test_out.vcd

#asm: ../mu0-assembler/test.asm
#	python3 ../mu0-assembler ../mu0-assembler/test.asm

plot:
	gtkwave out.vcd

plottest:
	gtkwave test_out.vcd

clean:
	rm *.o *.vcd *.cf $(APP) *.hex

