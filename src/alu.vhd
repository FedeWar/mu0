library ieee;
use ieee.std_logic_1164.all;

entity alu is
	port(
		ABUS : in std_logic_vector(15 downto 0);
		BBUS : in std_logic_vector(15 downto 0);
		ALUfs : in std_logic_vector(2 downto 0);
		O : out std_logic_vector(15 downto 0)
	);
end alu;

library ieee;
use ieee.std_logic_1164.all;
entity fulladder is
	port(
		A : in std_logic;
		B : in std_logic;
		Cin : in std_logic;
		S : out std_logic;
		Cout : out std_logic
	);
end fulladder;

architecture add of fulladder is
	signal x : std_logic;
begin
	x <= A xor B;
	S <= x xor Cin;
	Cout <= (x and Cin) or (A and B);
end architecture;

architecture arch of alu is
	component fulladder is
		port(
			A : in std_logic;
			B : in std_logic;
			Cin : in std_logic;
			S : out std_logic;
			Cout : out std_logic
		);
	end component;

	component mux is
		generic(
			DEPTH : integer
		);
		port(
			IN0 : in std_logic_vector;
			IN1 : in std_logic_vector;
			SEL : in std_logic;
			O : out std_logic_vector
		);
	end component;

	-- Vettore dei carry, sono una pipeline
	signal cins : std_logic_vector(16 downto 0);

	-- Uscita degli adder
	signal adderout : std_logic_vector(15 downto 0);
	
	-- Vettore costante tutto 0
	constant zero : std_logic_vector(15 downto 0) := "0000000000000000";

	-- Segnali di controllo dei muxer
	signal asel : std_logic;
	signal bsel : std_logic;

	-- Uscite dei muxer
	signal aout : std_logic_vector(15 downto 0);
	signal bout : std_logic_vector(15 downto 0);
begin
	-- TODO non è necessario utilizzare dei muxer
	AMUX : mux generic map(16) port map(zero, ABUS, asel, aout);
	BMUX : mux generic map(16) port map(zero, BBUS, bsel, bout);

	GENADD : for i in 0 to 15 generate
		adder : fulladder port map(aout(i), bout(i), cins(i), adderout(i), cins(i+1));
	end generate;

	asel <= '0' when (ALUfs = "000") or (ALUfs = "010") or (ALUfs = "100") else '1';
	bsel <= '0' when (ALUfs = "000") or (ALUfs = "001") or (ALUfs = "011") else '1';

	cins(0) <= '1' when (ALUfs = "011") or (ALUfs = "100") else '0';

	O <= "0000000000000000" when ALUfs = "000" else -- =0
	ABUS when ALUfs = "001" else					-- =A
	BBUS when ALUfs = "010" else					-- =B
	adderout when ALUfs = "011" else		-- A+1
	adderout when ALUfs = "100" else		-- B+1
	adderout when ALUfs = "101" else		-- A+B
	adderout when ALUfs = "110" else		-- A-B
	adderout when ALUfs = "111";			-- B-A

end architecture;
