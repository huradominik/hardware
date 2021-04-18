library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 7 SEG FJ5461BH --
-- common anode --


-- 		 a
--		---
--	  f| g |b
--		---
--	  e|   |c
--		---	.dp
--		 d

entity transcoder_bcd_7seg is
	port(
	bcd_data : in std_logic_vector (3 downto  0);
	seg7_data  : out std_logic_vector (7 downto 0)
	);
end transcoder_bcd_7seg;


architecture beh of transcoder_bcd_7seg is

begin
	
with bcd_data select 
--			  abcdefgdp     --BCD--
seg7_data <= "00000011" when "0000",	 --0
			 "10011111" when "0001",	 --1
			 "00100101" when "0010",	 --2
			 "00001101" when "0011",	 --3
			 "10011001" when "0100",	 --4
			 "01001001" when "0101",	 --5
			 "01000001" when "0110",	 --6
			 "00011111" when "0111",	 --7
			 "00000001" when "1000",	 --8
			 "00001001" when "1001",	 --9
			 "11111110" when "1111",  -- dot
			 "11111111" when others;
		
end beh;
