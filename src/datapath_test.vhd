library ieee;
use ieee.std_logic_1164.all;

entity dp_test is
end dp_test;

architecture test of dp_test is
	signal clk : std_logic := '0';
	signal stop_clock0 : std_logic := '0';
	signal stop_clock1 : std_logic := '0';

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

	signal d0 : std_logic;
	signal en0 : std_logic;
	signal rst : std_logic;
	signal q0 : std_logic;
	component ff_de is
		port(
			D : in std_logic;
			EN : in std_logic;
			RST : in std_logic;
			CLK : in std_logic;
			Q : out std_logic
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

	-- TODO test registri
	ff0_test : ff_de port map(d0, en0, rst, clk, q0);
	process
	begin
		wait for 2 ns;
		
		rst <= '1';
		wait for 10 ns;
		assert (q0 = '0') severity ERROR;

		rst <= '0';
		d0 <= '1';
		en0 <= '1';
		wait for 10 ns;
		assert (q0 = '1') severity ERROR;

		d0 <= '0';
		en0 <= '1';
		wait for 10 ns;
		assert (q0 = '0') severity ERROR;

		d0 <= '1';
		en0 <= '0';
		wait for 10 ns;
		assert (q0 = '0') severity ERROR;

		d0 <= '1';
		en0 <= '1';
		wait for 10 ns;
		assert (q0 = '1') severity ERROR;

		rst <= '0';
		d0 <= '0';
		en0 <= '0';
		wait for 10 ns;
		assert (q0 = '1') severity ERROR;

		en0 <= '0';
		rst <= '1';
		wait for 10 ns;
		assert (q0 = '0') severity ERROR;

		rst <= '0';
		d0 <= '0';
		en0 <= '0';
		wait for 10 ns;
		assert (q0 = '0') severity ERROR;

		stop_clock1 <= '1';
		wait;
	end process;

	process
	begin
		-- Attesa del reset dei registri
		wait for 20 ns;

		-- LOAD 
		Asel <= '1';
		Bsel <= '1';
		ACCce <= '1';
		PCce <= '0';
		IRce <= '0';
		ACCoe <= '0';
		ALUfs <= "010"; -- =B
		MEMrq <= '1';
		RnW <= '1';

		--bus_data <= "0110110000111001";
		wait for 20 ns;

		-- JUMP
		Asel <= '1';
		Bsel <= '0';
		ACCce <= '0';
		PCce <= '1';
		IRce <= '1';
		ACCoe <= '0';
		ALUfs <= "100"; -- B+1
		MEMrq <= '1';
		RnW <= '1';
		--bus_data <= "0000000011111111";

		stop_clock0 <= '1';
		wait;
	end process;

	process
	begin
		if stop_clock0 = '1' and stop_clock1 = '1' then
			wait;
		end if;
		wait for 5 ns;
		clk <= not clk;
		wait for 5 ns;
		clk <= not clk;
	end process;
end architecture;
