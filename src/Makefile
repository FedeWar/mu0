
APP=mu0
TESTAPP=dp_test
OBJS=mu0.o datapath.o mux.o alu.o buffer.o reg_ppe.o ff_de.o memory.o
TEST=datapath_test.o

FF_INCLUDES=
FFIN_OBJS=$(addsuffix .o, $(basename $(FF_INCLUDES)))

# Comandi automatici

all: app test asm

%.o: %.vhd
	ghdl -a --std=08 $<

%.o: ../flipflop-2/%.vhd
	ghdl -a $<

%.o: ../registers/%.vhd
	ghdl -a $<

$(APP): $(OBJS) $(FFIN_OBJS)
	ghdl -e --std=08 $(APP)

$(TESTAPP): $(OBJS) $(TEST) $(FFIN_OBJS)
	ghdl -e --std=08 $(TESTAPP)

# Comandi manuali

app: $(APP)

test: $(TESTAPP)

run: app
	ghdl -r $(APP) --vcd=out.vcd --stop-time=500ns #--disp-time

runtest: test
	ghdl -r $(TESTAPP) --vcd=test_out.vcd #--disp-time --stop-time=100ns

asm: ../mu0-assembler/test.asm
	python3 ../mu0-assembler ../mu0-assembler/test.asm

plot:
	gtkwave out.vcd

plottest:
	gtkwave test_out.vcd

clean:
	rm *.o *.vcd *.cf $(APP) *.hex
