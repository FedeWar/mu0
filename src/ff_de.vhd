library ieee;
use ieee.std_logic_1164.all;

-- Attenzione se il segnale cambia <1 ns prima
-- del falling edge del clock il risultato è indefinito.
entity ff_de is
	port(
		D : in std_logic;
		EN : in std_logic;
		RST : in std_logic;
		CLK : in std_logic;
		Q : out std_logic
	);
end ff_de;

architecture arch of ff_de is
	signal q1 : std_logic;
begin
	q1 <=	D after 1 ns	when (CLK = '1') and (EN = '1') else 
			'0' after 1 ns	when RST = '1' else q1;

	process(CLK)
	begin
		if falling_edge(CLK) then
			Q <= q1 after 1 ns;
		end if;
	end process;

end architecture;
