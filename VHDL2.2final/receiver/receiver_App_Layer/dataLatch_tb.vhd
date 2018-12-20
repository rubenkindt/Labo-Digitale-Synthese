-- Made by Ruben Kindt	20/11/2018
-- testbench for the data 'Latch' 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dataLatch_tb is
end dataLatch_tb;

architecture structural of dataLatch_tb is 
component dataLatch
port (
	bit_sample	:IN  std_logic:='0';
	data		:IN  std_logic_vector(0 to 10):=(others=>'0');
	latch_data	:OUT std_logic_vector(0 to 3):="0000"
	);
end component;

for uut : dataLatch use entity work.dataLatch(behav);
constant period : time := 100 ns;

signal bit_sample	:std_logic:='0';
signal data		:std_logic_vector(0 to 10):=(others=>'0');
signal latch_data	:std_logic_vector(0 to 3):="0000";

BEGIN
uut: dataLatch PORT MAP(
	bit_sample	=> bit_sample,
	data		=> data,
	latch_data	=> latch_data
	);

tb : PROCESS
BEGIN
data	<="10101010101";
----------- ----------
FOR J IN 0 TO 20 loop
	WAIT FOR period;
END LOOP;
FOR J IN 0 TO 20 loop
	bit_sample	<='0';
	WAIT FOR period;
	bit_sample	<='1';
		WAIT FOR period;
END LOOP;

----------- ---------- 
data	<="01111101111";
FOR J IN 0 TO 20 loop
	WAIT FOR period;
END LOOP;
FOR J IN 0 TO 20 loop
	bit_sample	<='0';
	WAIT FOR period;
	bit_sample	<='1';
	WAIT FOR period;
END LOOP;
----------- ---------- 
data	<=(others=>'0');
FOR J IN 0 TO 20 loop
	WAIT FOR period;
END LOOP;
FOR J IN 0 TO 20 loop
	bit_sample	<='0';
	WAIT FOR period;
	bit_sample	<='1';
	WAIT FOR period;
END LOOP;


WAIT;
END PROCESS;
END;


