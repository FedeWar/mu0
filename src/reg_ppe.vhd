library ieee;
use ieee.std_logic_1164.all;

entity reg_ppe is
	generic(
		DEPTH : integer := 8
	);
	port(
		DIN : in std_logic_vector(DEPTH - 1 downto 0);
		EN : in std_logic;
		RST : in std_logic;
		CLK : in std_logic;
		DOUT : out std_logic_vector(DEPTH - 1 downto 0)
	);
end reg_ppe;

architecture arch of reg_ppe is
	component ff_de is
		port(
			D : in std_logic;
			EN : in std_logic;
			RST : in std_logic;
			CLK : in std_logic;
			Q : out std_logic
		);
	end component;
begin
	FFS : for i in 0 to DEPTH - 1 generate
		ffde : ff_de port map(DIN(i), EN, RST, CLK, DOUT(i));
	end generate;
end architecture;
