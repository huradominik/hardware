library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mux_bcd_4 is
	port(
	din : in std_logic_vector (15 downto 0);
	dout : out std_logic_vector (3 downto 0);
	sel : in std_logic_vector (3 downto 0) 
	);									   
end mux_bcd_4;

architecture mux of mux_bcd_4 is

begin
	with sel select
	dout <= din(3 downto 0) when "0001",
	 		din(7 downto 4) when "0010",
			din(11 downto 8) when "0100",
			din(15 downto 12) when "1000",
			din(3 downto 0) when others;
	
end mux;
