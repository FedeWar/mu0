library ieee;
use ieee.std_logic_1164.all;

entity mu0 is
end mu0;

architecture main of mu0 is
	signal clk : std_logic := '1';
	signal stop_clock : std_logic := '0';
	signal exfs : std_logic := '1';			-- State bit

	-- Segnali al datapath
	signal bus_addr : std_logic_vector(11 downto 0);
	signal bus_data : std_logic_vector(15 downto 0);
	signal Asel : std_logic;
	signal Bsel : std_logic;
	signal ACCce : std_logic;
	signal PCce : std_logic;
	signal IRce : std_logic;
	signal ACCoe : std_logic;
	signal ALUfs : std_logic_vector(2 downto 0);
	signal IRbus : std_logic_vector(3 downto 0);
	signal ACCstatus : std_logic_vector(1 downto 0);
	
	-- Segnali alla memoria
	signal MEMrq : std_logic;
	signal RnW : std_logic;

	component datapath is
		port(
			CLK : in std_logic;
			bus_addr : out std_logic_vector;
			bus_data : inout std_logic_vector;
			Asel : in std_logic;
			Bsel : in std_logic;
			ACCce : in std_logic;
			PCce : in std_logic;
			IRce : in std_logic;
			ACCoe : in std_logic;
			ALUfs : in std_logic_vector;
			IRbus : out std_logic_vector;
			ACCstatus : out std_logic_vector
		);
	end component;

	component memory is
		port(
			ADDR : in std_logic_vector;
			DATA : inout std_logic_vector;
			MEMrq : in std_logic;
			RnW : in std_logic
		);
	end component;
begin
	dpath : datapath port map(clk, bus_addr, bus_data, Asel, Bsel, ACCce, PCce, IRce, ACCoe, ALUfs, IRbus, ACCstatus);
	mem : memory port map(bus_addr, bus_data, MEMrq, RnW);

	CONTROL : process(clk)
	begin
		if (rising_edge(clk)) and (exfs = '0') then		-- EXECUTE
			if IRbus = "0000" then		-- LDA
				Asel <= '1';
				Bsel <= '1';
				ACCce <= '1';
				PCce <= '0';
				IRce <= '0';
				ACCoe <= '0';
				ALUfs <= "010";	-- =B
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '1';
			elsif IRbus = "0001" then	-- STO
				Asel <= '1';
				Bsel <= 'X';
				ACCce <= '0';
				PCce <= '0';
				IRce <= '0';
				ACCoe <= '1';
				ALUfs <= "XXX";	-- Don't care
				MEMrq <= '1';
				RnW <= '0' after 1 ns;
				exfs <= '1';
			elsif IRbus = "0010" then	-- ADD
				Asel <= '1';
				Bsel <= '1';
				ACCce <= '1';
				PCce <= '0';
				IRce <= '0';
				ACCoe <= '0';
				ALUfs <= "101";	-- A+B
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '1';
			elsif IRbus = "0011" then	-- SUB
				Asel <= '1';
				Bsel <= '1';
				ACCce <= '1';
				PCce <= '0';
				IRce <= '0';
				ACCoe <= '0';
				ALUfs <= "110";	-- A-B
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '1';
			elsif IRbus = "0100" then	-- JMP
				Asel <= '1';
				Bsel <= '0';
				ACCce <= '0';
				PCce <= '1';
				IRce <= '1';
				ACCoe <= '0';
				ALUfs <= "100";	-- B+1
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '0';
			elsif IRbus = "0101" then	-- JGE
				Asel <= not ACCstatus(1);
				Bsel <= '0';
				ACCce <= '0';
				PCce <= '1';
				IRce <= '1';
				ACCoe <= '0';
				ALUfs <= "100";	-- B+1
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '0';
			elsif IRbus = "0110" then	-- JNE
				Asel <= ACCstatus(0);
				Bsel <= '0';
				ACCce <= '0';
				PCce <= '1';
				IRce <= '1';
				ACCoe <= '0';
				ALUfs <= "100";	-- B+1
				MEMrq <= '1';
				RnW <= '1';
				exfs <= '0';
			elsif IRbus = "0111" then	-- STP
				Asel <= '1';
				Bsel <= 'X';
				ACCce <= '0';
				PCce <= '0';
				IRce <= '0';
				ACCoe <= '0';
				ALUfs <= "XXX";	-- Don't care
				MEMrq <= '0';
				RnW <= '1';
				exfs <= '0';
				stop_clock <= '1';
			end if;
		elsif (rising_edge(clk)) and (exfs = '1') then	-- FETCH
			Asel <= '0';
			Bsel <= '0';
			ACCce <= '0';
			PCce <= '1';
			IRce <= '1';
			ACCoe <= '0';
			ALUfs <= "100";	-- B+1
			MEMrq <= '1';
			RnW <= '1';
			exfs <= '0';
		end if;
	end process;

	process
	begin
		if stop_clock = '1' then
			wait;
		end if;
		wait for 5 ns;
		clk <= not clk;
		wait for 5 ns;
		clk <= not clk;
	end process;
end architecture;
