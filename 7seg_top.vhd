library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seg7_top is
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
	
end seg7_top;

architecture top of seg7_top is

signal ena_presc : std_logic;
signal bcd_in_r : std_logic_vector(15 downto 0);
signal bcd_out_r :std_logic_vector(3 downto 0);
signal sel_r  : std_logic_vector(3 downto 0);

--
signal enable_r : std_logic;
signal busy_r : std_logic;
signal ff_r_1 : std_logic_vector(bits-1 downto 0);
signal ff_r_2 : std_logic_vector(bits-1 downto 0);

--COMPONENT--
	
	component transcoder_bcd_7seg is
		port(
			bcd_data : in std_logic_vector (3 downto  0);
			seg7_data  : out std_logic_vector (7 downto 0)
		);
	end component;
	
	component presc_7seg is
		generic(
		COUNTER_VALUE : natural := 40
		);
		port(
		sys_rst_n   : in std_logic;
		clk_input : in std_logic;
		ena_out  : out std_logic
		);
	end component;
	
	component ff_ring_1 is
		port(
		sys_rst_n : in std_logic;
		clk_in : in std_logic;
		enable : in std_logic;
		Q	   : out std_logic_vector (3 downto 0)
		);				   
	end component;
	
	component mux_bcd_4 is
		port(
		din : in std_logic_vector (15 downto 0);
		dout : out std_logic_vector (3 downto 0);
		sel : in std_logic_vector (3 downto 0) 
		);									   
	end component;
	
	component binary_to_bcd is
	generic(
		bits		:	INTEGER := 10;		--size of the binary input numbers in bits
		digits	:	INTEGER := 3);		--number of BCD digits to convert to
	port(
		clk_in	:	IN		STD_LOGIC;											--system clock
		reset_n	:	IN		STD_LOGIC;											--active low asynchronus reset
		ena		:	IN		STD_LOGIC;											--latches in new binary number and starts conversion
		binary	:	IN		STD_LOGIC_VECTOR(bits-1 DOWNTO 0);			--binary number to convert
		busy	:	OUT	STD_LOGIC;											--indicates conversion in progress
		bcd		:	OUT	STD_LOGIC_VECTOR(digits*4-1 DOWNTO 0));	--resulting BCD number
	end component;

begin
	
	E1 : presc_7seg
	generic map(
	COUNTER_VALUE => DIVIDE_TO_PRESCALER
	)
	port map(
	sys_rst_n => sys_rst_n,
	clk_input => clk_in,
	ena_out => ena_presc
	);
	
	E2 : ff_ring_1
	port map(
	sys_rst_n => sys_rst_n,
	clk_in => clk_in,
	enable => ena_presc,
	Q => sel_r
	);
	
	E3 : mux_bcd_4
	port map(
	din => bcd_in_r,
	dout => bcd_out_r,
	sel => sel_r
	);
	
	E4 : binary_to_bcd
	generic map (
	bits => 14,
	digits => 4	
	)
	port map(
	clk_in => clk_in,	
	reset_n	=> sys_rst_n,
	ena	=> enable_r,	
	binary => ff_r_1,	
	busy => busy_r,	
	bcd	=> bcd_in_r	
	);
	
	E5 : transcoder_bcd_7seg
	port map(
	bcd_data =>	bcd_out_r,
	seg7_data => katoda
	);
	
	anoda <= sel_r;
	
	process(clk_in, sys_rst_n)
	begin
		if rising_edge(clk_in) then
			if sys_rst_n = '0' then
				ff_r_1 <= (others => '0');
				ff_r_2 <= (others => '0');
			else
				ff_r_1 <= data_input(bits-1 downto 0);
				if busy_r = '0' then
					ff_r_2 <= ff_r_1;
				else
					ff_r_2 <= ff_r_2;
				end if;
			end if;
		end if;					
	end process;
	
	process(ff_r_1, ff_r_2)
	begin
		if ff_r_1 = ff_r_2 then
			enable_r <= '0';
		else
			enable_r <= '1';
		end if;
	end process;
		
end top;
