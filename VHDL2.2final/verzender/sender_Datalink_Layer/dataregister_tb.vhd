-- Made by Ruben Kindt	04/11/2018
-- testbench for the dataregester.vhd 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataregister_tb is
end dataregister_tb;

architecture structural of dataregister_tb is 
component dataregister
port (
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	load		:IN  std_logic:='0';
	shift		:IN  std_logic:='0';
	data		:IN  std_logic_vector(3 downto 0):="0000";
	sdo_posenc	:OUT std_logic:='0'
	);
end component;

for uut : dataregister use entity work.dataregister(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal rst:		std_logic:='0';
signal shift,load:	std_logic:='0';
signal data:		std_logic_vector(3 downto 0):="0000";
Signal sdo_posenc:	std_logic:='0';

BEGIN
uut: dataregister PORT MAP(
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	shift		=> shift,
	load		=> load,
	data		=> data,
	sdo_posenc	=> sdo_posenc
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
clk_en	<='1';
rst	<='0';
data	<="1010";
-----------zonder pulsen----------
FOR J IN 0 TO 20 loop
	WAIT FOR period;
END LOOP;
-----------load test---------- 
WAIT FOR period;
load	<='1';
WAIT FOR period;
load	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------20 keer shiften---------- -- 20=willekeurig gekozen
FOR J IN 1 TO 20 loop
	shift	<='1';
	WAIT FOR period;
	shift	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------2 keer volledige 'normale cyclus ----------
FOR J IN 0 TO 1 loop -- 2 keer loaden
	load	<='1';
	WAIT FOR period;
	load	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
	FOR JJ IN 0 TO 10 loop	-- 11 keer shiften
		shift	<='1';
		WAIT FOR period;
		shift	<='0';
		WAIT FOR period;
		WAIT FOR period;
		WAIT FOR period;
	END LOOP;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------rst-----------
rst	<='1';
FOR J IN 0 TO 1 loop -- 2 keer loaden
	load	<='1';
	WAIT FOR period;
	load	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
	FOR JJ IN 0 TO 10 loop	-- 11 keer shiften
		shift	<='1';
		WAIT FOR period;
		shift	<='0';
		WAIT FOR period;
		WAIT FOR period;
		WAIT FOR period;
	END LOOP;
	rst	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
WAIT;
END PROCESS;
END;


