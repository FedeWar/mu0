library ieee;
use ieee.std_logic_1164.all;

entity transmission_gate is
	port(
		DIN : in std_logic_vector(15 downto 0);
		CTRL : in std_logic;
		DOUT : out std_logic_vector(15 downto 0)
	);
end transmission_gate;

architecture arch of transmission_gate is
begin
	DOUT <= DIN when CTRL = '1' else "ZZZZZZZZZZZZZZZZ";
end architecture;
