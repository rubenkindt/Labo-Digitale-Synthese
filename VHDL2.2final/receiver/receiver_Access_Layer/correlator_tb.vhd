-- Made by Ruben Kindt	17/11/2018
-- test bench for 6 bit u/d counter 
-- to remove some spikes
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity correlator_tb is
end correlator_tb;

architecture structural of correlator_tb is 

component correlator
port (
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	rst:		in std_logic:='0';
	chip_sample:	in std_logic:='0';
	bit_sample:	in std_logic:='0';
	sdi_despread:	in std_logic:='0';
	databit:	out std_logic:='0'
	);
end component;

for uut : correlator use entity work.correlator(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal rst:		std_logic:='0';
signal chip_sample:	std_logic:='0';
signal bit_sample:	std_logic:='0';
signal sdi_despread:	std_logic:='0';
signal databit:		std_logic:='0';

BEGIN
uut: correlator PORT MAP(
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	chip_sample 	=> chip_sample,
	bit_sample 	=> bit_sample,
	sdi_despread 	=> sdi_despread,
	databit 	=> databit
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
sdi_despread    <='0';  
wait for delay; --insert delay 10 ns
wait for period;
wait for period;
-----------perfect geval 31 '1'-tjes----------
sdi_despread    <='1';
wait for period;
FOR I IN 0 TO 30 loop 			
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
WAIT FOR period;
WAIT FOR period;
bit_sample	<='1';
chip_sample	<='1';	-- zonder chip_sample '1' zou geen bit_sample nooit '1' mogen zijn
WAIT FOR period;
chip_sample	<='0';
bit_sample	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------perfect geval 31 '0'-tjes----------
sdi_despread    <='0';
wait for period;
FOR I IN 0 TO 30 loop 			
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
bit_sample	<='1';
chip_sample	<='1';	-- zonder chip_sample '1' zou geen bit_sample nooit '1' mogen zijn
WAIT FOR period;
chip_sample	<='0';
bit_sample	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------onstabiel geval 15 '0'-tjes 16 '1'-tjes----------
sdi_despread    <='0';
wait for period;
FOR I IN 0 TO 14 loop 			
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
sdi_despread    <='1';
WAIT FOR period;
WAIT FOR period;
FOR I IN 0 TO 15 loop 			
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
WAIT FOR period;
bit_sample	<='1';
chip_sample	<='1';	-- zonder chip_sample '1' zou geen bit_sample nooit '1' mogen zijn
WAIT FOR period;
chip_sample	<='0';
bit_sample	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------rst test----------
rst	<='1';
FOR I IN 0 TO 10 loop 			
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
rst	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
WAIT;
END PROCESS;
END;
