library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port(
		CLK : in std_logic;
		bus_addr : out std_logic_vector(11 downto 0);
		bus_data : inout std_logic_vector(15 downto 0);
		Asel : in std_logic;
		Bsel : in std_logic;
		ACCce : in std_logic;
		PCce : in std_logic;
		IRce : in std_logic;
		ACCoe : in std_logic;
		-- questo è un simbolo a 3 bit
		ALUfs : in std_logic_vector(2 downto 0);
		-- l'IR deve essere disponibile anche alla logica di controllo
		IRbus : out std_logic_vector(3 downto 0)
	);
end datapath;

architecture arch of datapath is
	subtype bus16_t is std_logic_vector(15 downto 0);

	signal alu_out : bus16_t;	-- Uscita della ALU
	signal alu_a : bus16_t;		-- Ingresso A della ALU
	signal alu_b : bus16_t;		-- Ingresso B della ALU

	signal amux0 : bus16_t;		-- Ingresso 0 del MUX A
	signal amux1 : bus16_t;		-- Ingresso 1 del MUX A
	signal bmux0 : bus16_t;		-- Ingresso 0 del MUX B
	-- L'ingresso 1 del MUX B è il data bus

	signal reset : std_logic := '1';

	component reg_ppe is
		generic(
			DEPTH : integer
		);
		port(
			DIN :	in std_logic_vector;
			EN :	in std_logic;
			RST	:	in std_logic;
			CLK :	in std_logic;
			DOUT :	out std_logic_vector
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

	component ALU is
		port(
			ABUS : in std_logic_vector;
			BBUS : in std_logic_vector;
			ALUfs : in std_logic_vector;
			O : out std_logic_vector
		);
	end component;
	
	component transmission_gate is
		port(
			DIN : in std_logic_vector;
			CTRL : in std_logic;
			DOUT : out std_logic_vector
		);
	end component;
	signal adapter : std_logic_vector(15 downto 0);
begin
	acc : reg_ppe generic map(16) port map(	alu_out,	ACCce,	reset,	CLK,	alu_a);
	ir : reg_ppe generic map(16) port map(	bus_data,	IRce,	reset,	CLK,	adapter);
	pc : reg_ppe generic map(16) port map(	alu_out,	PCce,	reset,	CLK,	amux0);

	amux : mux generic map(16) port map(amux0,	amux1,		Asel,	bmux0);
	bmux : mux generic map(16) port map(bmux0,	bus_data,	Bsel,	alu_b);

	alunit : ALU port map(alu_a, alu_b, ALUfs, alu_out);

	-- Buffer di connessione dell'accumulatore al data bus
	buf : transmission_gate port map(alu_a, ACCoe, bus_data);

	-- Questi devono essere modificati solo qui
	amux1(15 downto 12) <= "0000";
	amux1(11 downto 0) <= adapter(15 downto 4);
	bus_addr <= bmux0(11 downto 0); --(15 downto 4);
	IRbus <= adapter(3 downto 0);

	-- Procedura di inizializzazione
	INIT : process
	begin
		wait for 1 ns;
		reset <= '0';
		wait;
	end process;

end architecture;
