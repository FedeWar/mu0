library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity memory is
	port(
		ADDR : in std_logic_vector(11 downto 0);
		DATA : inout std_logic_vector(15 downto 0);
		MEMrq : in std_logic;
		RnW : in std_logic
	);
end entity;

architecture arch of memory is
	subtype	word_t is std_logic_vector(15 downto 0);
	type ram_t is array(0 to 4095) of word_t;

	impure function readFile(FileName : STRING) return ram_t is
		file FileHandle       : TEXT open READ_MODE is FileName;
		variable CurrentLine  : LINE;
		variable TempWord     : STD_LOGIC_VECTOR(15 downto 0);
		variable Result       : ram_t    := (others => (others => '0'));
	begin
		for i in 0 to 4095 loop
			exit when endfile(FileHandle);
  
			readline(FileHandle, CurrentLine);
			hread(CurrentLine, TempWord);
			Result(i) := TempWord;
		end loop;
  
		return Result;
	end function;

	signal core : ram_t := readFile("out.hex");
begin

	DATA <= core(to_integer(unsigned(ADDR))) when (MEMrq = '1' and RnW = '1') else "ZZZZZZZZZZZZZZZZ";
	core(to_integer(unsigned(ADDR))) <= DATA when (MEMrq = '1' and RnW = '0') else core(to_integer(unsigned(ADDR)));

end architecture;
