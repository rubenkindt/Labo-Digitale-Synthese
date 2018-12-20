-- Made by Ruben Kindt 3BaE-ICT 18/10/2018
-- PN Generator 
-- we shiften van link naar rechts
--      0 1 0 0 0+ clk=>  00100
--      ^bit0   ^bit4		  vector(0 upto 4)
-- Changes in this document must also be made in /receiver/receiver_Access_Layer/pN_generator_and_NCO_tb.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pngenerator_tb is
end pngenerator_tb;

architecture structural of pngenerator_tb is 
component pngenerator
port (
	clk:      in std_logic;
  	clk_en:   in std_logic:='1';
  	rst:      in std_logic:='0';
  	pn_start: out std_logic:='0'; -- wanneer we de sequens opnieuw terug tegen komen komt deze op 1
  	pn1:      out std_logic:='0';
  	pn2:      out std_logic:='0';
  	gold:     out std_logic:='0' -- xor van bovenste 2
	);
end component;

-- hier maken we van alle in/outgangen signalen om ze dan te koppelen
for uut : pngenerator use entity work.pngenerator(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       std_logic:='0';
signal clk_en:    std_logic:='1';
signal rst:       std_logic:='0';
signal pn_start:  std_logic:='0';
signal pn1:       std_logic:='0';
signal pn2:       std_logic:='0';
signal gold:      std_logic:='0';


BEGIN
uut: pngenerator PORT MAP(
	clk       => clk,
	clk_en    => clk_en,
	rst       => rst,
	pn_start  => pn_start,
	pn1       => pn1,
	pn2       => pn2,
	gold      => gold	
	);

clock : process
begin 
 clk <= '0';
 wait for period/2;
loop
  clk <= '0';
  wait for period/2;
  clk <= '1';
  wait for period/2;
exit when end_of_sim;
end loop;
wait;
end process clock;
  
tb : PROCESS 
BEGIN
clk_en    <='1';
rst       <='0';
FOR i IN 0 TO 200 loop 			
	WAIT FOR period;
END LOOP;
----------RST test--------------
rst <= '1';
FOR i IN 0 TO 20 loop 			
	WAIT FOR period;
END LOOP;
rst <= '0';
----------back to normal--------------
FOR i IN 0 TO 40 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
END;




