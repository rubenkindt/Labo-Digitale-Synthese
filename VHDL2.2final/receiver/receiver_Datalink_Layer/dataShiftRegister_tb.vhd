-- Made by Ruben Kindt	19/11/2018
-- testbench for the dataShiftRegester.vhd 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataShiftRegister_tb is
end dataShiftRegister_tb;

architecture structural of dataShiftRegister_tb is 
component dataShiftRegister
port (
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	databit		:IN  std_logic:='0';
	bit_sample	:IN  std_logic:='0';
	data_datalink	:OUT  std_logic_vector(0 to 10):=(others=>'0')
	);
end component;

for uut : dataShiftRegister use entity work.dataShiftRegister(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal rst:		std_logic:='0';
signal databit:		std_logic:='0';
signal bit_sample:	std_logic:='0';
signal data_datalink:	std_logic_vector(0 to 10):=(others=>'0');


BEGIN
uut: dataShiftRegister PORT MAP(
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	databit		=> databit,
	bit_sample	=> bit_sample,
	data_datalink	=> data_datalink
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
variable preable_data: std_logic_vector(0 to 10):="01111101111";
BEGIN
clk_en	<='1';
rst	<='0';
databit	<='1';
-----------2 keer normale cyclus---------- 
WAIT FOR period;
FOR I in 0 TO 10 LOOP
--	FOR J IN 0 TO 31*16-1 LOOP
--		WAIT FOR period;
--	END LOOP;
	WAIT FOR period;
	databit	<=preable_data(I);
	WAIT FOR period;
	bit_sample	<='1';
	WAIT FOR period;
	bit_sample	<='0';

END LOOP;
FOR I in 0 TO 10 LOOP
	WAIT FOR period;
	databit	<=preable_data(I);
	WAIT FOR period;
	bit_sample	<='1';
	WAIT FOR period;
	bit_sample	<='0';

END LOOP;
----------rst-----------
rst	<='1';
FOR J IN 0 TO 1 loop -- 2 keer
	bit_sample	<='1';
	WAIT FOR period;
	bit_sample	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
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


