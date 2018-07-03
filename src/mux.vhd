library ieee;
use ieee.std_logic_1164.all;

entity mux is
	generic(
		DEPTH : integer := 8
	);
	port(
		IN0 : in std_logic_vector(DEPTH - 1 downto 0);
		IN1 : in std_logic_vector(DEPTH - 1 downto 0);
		SEL : in std_logic;
		O : out std_logic_vector(DEPTH - 1 downto 0)
	);
end mux;

architecture arch of mux is
begin
	O <= IN0 when SEL = '0' else IN1;

	--process
	--begin
	--	if SEL = '0' then
	--		O <= IN0;
	--	elsif SEL = '1' then
	--		O <= IN1;
	--	end if;
	--end process;
end architecture;
