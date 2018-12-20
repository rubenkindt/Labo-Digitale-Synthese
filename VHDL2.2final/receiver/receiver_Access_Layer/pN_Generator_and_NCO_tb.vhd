-- Made by Ruben Kindt 3BaE-ICT 18/10/2018
-- Changed at 15/11/2018: name changes and added a positive pulse detection
-- PN Generator with NCO
-- we shiften van link naar rechts
--      0 1 0 0 0+ clk=>  00100
--      ^bit0   ^bit4
--        vector(0 upto 4)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pngeneratorAndNCO_tb is
end pngeneratorAndNCO_tb;

architecture structural of pngeneratorAndNCO_tb is 
component pngeneratorAndNCO
port (
	clk:      	in std_logic;
	clk_en:   	in std_logic:='1';
 	rst:      	in std_logic:='0';
	chip_sampleD1: 	in std_logic:='0';
	seq_det:	in std_logic:='0';
	bit_sample:	out std_logic:='0';
  	pn1_receiver:	out std_logic:='0';
  	pn2_receiver:	out std_logic:='0';
  	gold_receiver:	out std_logic:='0'
	);
end component;

for uut : pngeneratorAndNCO use entity work.pngeneratorAndNCO(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       	std_logic:='0';
signal clk_en:    	std_logic:='1';
signal rst:       	std_logic:='0';
signal chip_sampleD1:  	std_logic:='0';
signal seq_det:		std_logic:='0';
signal bit_sample:	std_logic:='0';
signal pn1_receiver:	std_logic:='0';
signal pn2_receiver:  	std_logic:='0';
signal gold_receiver:   std_logic:='0';


BEGIN
uut: pngeneratorAndNCO PORT MAP(
	clk      	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	chip_sampleD1	=> chip_sampleD1,
	seq_det		=> seq_det,
	bit_sample	=> bit_sample,
	pn1_receiver	=> pn1_receiver,
	pn2_receiver	=> pn2_receiver,
	gold_receiver	=> gold_receiver
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
clk_en    	<='1';
rst       	<='0';
chip_sampleD1	<='1';
FOR i IN 0 TO 200 loop 			
	WAIT FOR period;
END LOOP;
----------RST test--------------
rst <= '1';
FOR i IN 0 TO 20 loop 			
	WAIT FOR period;
END LOOP;
rst <= '0';
WAIT FOR period;
seq_det <= '1';
FOR i IN 0 TO 20 loop 			
	WAIT FOR period;
END LOOP;
seq_det <= '0';
----------back to normal--------------
FOR i IN 0 TO 40 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
END;




