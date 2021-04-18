library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seg7_tb is
end entity;


architecture testBench of seg7_tb is

signal clk_in_r : std_logic;
signal sys_rst_n : std_logic;
signal data_input_r : std_logic_vector (31 downto 0);
signal anoda_r : std_logic_vector(3 downto 0);
signal katoda_r : std_logic_vector(7 downto 0);

component seg7_top is
	generic(
	DIVIDE_TO_PRESCALER : natural := 200000;
	bits : natural := 14;
	bcd : natural := 4
	);
	port(
	clk_in : in std_logic;
	sys_rst_n : in std_logic;
	
	data_input : in std_logic_vector (31 downto 0);
	
	anoda : out std_logic_vector (3 downto 0);
	katoda : out std_logic_vector (7 downto 0)
	);
end component;

component clk_gen is
	generic (BASE_TIME : time := 10ns
	);
	port ( clk_out : out std_logic);
	
end component;
	
begin
	
	seg7 : seg7_top
	generic map(
	DIVIDE_TO_PRESCALER =>  10,
	bits => 14,
	bcd => 4
	)
	port map(
	clk_in => clk_in_r,
	sys_rst_n => sys_rst_n,
	
	data_input => data_input_r,
	
	anoda => anoda_r,
	katoda => katoda_r
	
	);
	
	gen_clk : clk_gen
	generic map(
	BASE_TIME => 10 ns
	)
	port map(
	clk_out => clk_in_r
	);
	
	
	process
	begin
		data_input_r <= X"0000014F";
		sys_rst_n <= '0';
		wait for 500 ns;
		sys_rst_n <= '1';
		wait for 300 ns;
		data_input_r <= X"00000567";
		wait for 1000 ns;
		data_input_r <= X"0000254A";	
		wait for 1000 ms;
	end process;
end testBench;
