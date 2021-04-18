library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ff_ring_1 is
	port(
	sys_rst_n : in std_logic;
	clk_in : in std_logic;
	enable : in std_logic;
	Q	   : out std_logic_vector (3 downto 0)
	);				   
end ff_ring_1;

architecture ring of ff_ring_1 is

signal ring : std_logic_vector (3 downto 0);
begin
	
	process(clk_in, sys_rst_n)
	begin
	if rising_edge(clk_in) then
		if sys_rst_n = '0' then
			ring <= "0001";
		else
			if enable = '1' then
				ring <= ring(2 downto 0) & ring(3);
			else
				ring <= ring;
			end if;
		end if;
	end if;
	Q <= ring;
	end process;
end ring;
