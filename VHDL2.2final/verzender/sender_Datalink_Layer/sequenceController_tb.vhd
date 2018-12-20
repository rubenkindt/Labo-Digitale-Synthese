-- Made by Ruben Kindt 3BaE-ICT 01/11/2018
-- Sequence Controller Testbench 
-- te testen: geeft de eerste pn_start door naar load, de andere 11 door naar shift?
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sequenceController_tb is
end sequenceController_tb;

architecture structural of sequenceController_tb is 
component sequenceController
port (
	clk:		in  std_logic;
  	clk_en:		in  std_logic:='1';
  	rst: 		in  std_logic:='0';
  	pn_start:	in  std_logic:='0'; -- vanuit ander process verandert relatief traag, dus extreem testen is overbodig
  	shift:		out std_logic:='0';
  	load:		out std_logic:='0'
	);
end component;

-- hier maken we van alle in/outgangen signalen om ze dan te koppelen
for uut : sequenceController use entity work.sequenceController(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       	std_logic:='0';
signal clk_en:    	std_logic:='1';
signal rst:       	std_logic:='0';
signal pn_start:	std_logic:='0';
signal shift:		std_logic:='0';
signal load:		std_logic:='0';


BEGIN
uut: sequenceController PORT MAP(
	clk     => clk,
	clk_en  => clk_en,
	rst     => rst,
	pn_start=> pn_start,
	shift	=> shift,
	load    => load	
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
WAIT FOR period;
WAIT FOR period;
----------StandBy test--------------
FOR i IN 0 TO 50 loop 			
	WAIT FOR period;
END LOOP;
----------12 pn_start pulsen--------------
FOR i IN 0 TO 12 loop		-- 12 genomen zodat begin nieuwe cyclus zichtbaar is
	pn_start	<='1';	
	WAIT FOR period;
	pn_start	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;	-- te dicht bij één zou niet realistisch zijn
	WAIT FOR period;
END LOOP;
----------RST test--------------
rst <= '1';
FOR i IN 0 TO 20 loop 			
	WAIT FOR period;
END LOOP;
rst <= '0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------RST test tijdens pulsen--------------
FOR i IN 0 TO 5 loop	
	pn_start	<='1';	
	WAIT FOR period;
	pn_start	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;	-- te dicht bij één zou niet realistisch zijn
	WAIT FOR period;
END LOOP;
rst		<='1';
WAIT FOR period;
FOR i IN 0 TO 5 loop
	pn_start	<='1';
	WAIT FOR period;
	pn_start	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;	-- te dicht bij één zou niet realistisch zijn
	WAIT FOR period;
END LOOP;
rst <= '0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------RST STOPT en pn_start='1'--------------
rst	<='1';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst		<='0';
pn_start	<='1';		-- pn_start puls ko
WAIT FOR period;
pn_start	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;	-- te dicht bij één zou niet realistisch zijn
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------back to normal--------------
FOR i IN 0 TO 40 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
END;
