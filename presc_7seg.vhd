library	IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity presc_7seg is
	generic(
	COUNTER_VALUE : natural := 200000
	);
	port(
	sys_rst_n   : in std_logic;
	clk_input : in std_logic;
	ena_out  : out std_logic
	);
end presc_7seg;

architecture presc of presc_7seg is

begin
	
	process(clk_input)
	variable count : integer range 0 to COUNTER_VALUE;
	begin
		if rising_edge(clk_input) then
			if sys_rst_n  = '0' then
				count := 0;
				ena_out <= '0';
			else
				if count < COUNTER_VALUE then
					ena_out <= '0';
					count := count + 1;
				else
					ena_out <= '1';
					count := 0;
				end if;
			end if;
		end if;
	end process;
end presc;
