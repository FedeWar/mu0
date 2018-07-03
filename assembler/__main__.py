# Std
from sys import argv

def genInstr(line):
	tokens = line.split(' ')
	mnemonic = tokens[0].upper()
	arg0 = tokens[1].strip()

	if mnemonic == "LDA":
		opcode = 0b0000
	elif mnemonic == "STO":
		opcode = 0b0001
	elif mnemonic == "ADD":
		opcode = 0b0010
	elif mnemonic == "SUB":
		opcode = 0b0011
	elif mnemonic == "JMP":
		opcode = 0b0100
	elif mnemonic == "JGE":
		opcode = 0b0101
	elif mnemonic == "JNE":
		opcode = 0b0110
	elif mnemonic == "STP":
		opcode = 0b0111
	else:
		raise Exception("Mnemonic unknown.")

	a0 = int(arg0) << 4
	return opcode | a0

def encode(val):
	val0 = (val >> 8) & 255 # più significativo
	val1 = val & 255		# meno significativo
	v0 = ('0' + hex(val0)[2:])[-2:]
	v1 = ('0' + hex(val1)[2:])[-2:]

	print("val0 ", val0)
	print("val1 ", val1)
	print("v0 ", v0)
	print("v1 ", v1)
	return str.encode(v0 + v1 + '\n')

def main():
	with open(argv[1], 'r') as f, open('out.hex', 'wb') as out:
		for line in f:
			
			if line[0] == '.':
				instr = int(line[1:-1])
			else:
				instr = genInstr(line)

			print("raw ", hex(instr))
			data = encode(instr)
			print("data = ", data)
			out.write(data)
			print("---------------")
		out.flush()

if __name__ == "__main__":
	main()
