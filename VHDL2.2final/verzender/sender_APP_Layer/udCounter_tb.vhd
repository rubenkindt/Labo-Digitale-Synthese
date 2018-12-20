-- Made by Ruben Kindt	11/10/2018
-- 4 bit UP/DOWN counter 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity udcounter_tb is
end udcounter_tb;

architecture structural of udcounter_tb is 

-- Component Declaration alle In/out
component udcounter
port (
	clk: 		in std_logic:='0';
	clk_en:		in std_logic:='1';
	up,down: 	in std_logic:='0';
	rst: 		in std_logic;
	count_out: 	out std_logic_vector(3 downto 0)
	);
end component;

for uut : udcounter use entity work.udcounter(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal rst:		std_logic:='0';
signal up,down:		std_logic:='0';
signal count_out:	std_logic_vector(3 downto 0);

BEGIN
-- verbinden van alle in/out
uut: udcounter PORT MAP(
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	up		=> up,
	down		=> down,
	count_out	=> count_out
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
up	<='0';
down	<='0';
--wait for delay; -- overbodig want nu komt het binnen op de clkflank = synchroon
wait for period;
wait for period;
WAIT FOR period;
-----------16 UP normaal----------
FOR J IN 0 TO 15 loop	-- van 0 tot F
	up	<='1';
	WAIT FOR period;
	up	<='0';
	WAIT FOR period;
END LOOP;		-- we beginnen op 0 dus eindigen we er ook (overflow)
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------16 DOWN normaal----------
FOR J IN 0 TO 15 loop	-- van F tot 0	
	down	<='1';
	WAIT FOR period;
	down	<='0';
	WAIT FOR period;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------UP DOWN UP DOWN----------
FOR J IN 0 TO 10 loop	-- 10 = random getal
	up	<='1';
	WAIT FOR period;
	up	<='0';
	WAIT FOR period;

	down	<='1';
	WAIT FOR period;
	down	<='0';
	WAIT FOR period;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------16 keer OVERLAP----------- elke sig kan maar 1 clk lang zijn (edge_detec det zit er voor)
FOR J IN 0 TO 15 loop
	up	<='1';
	down	<='1';
	WAIT FOR period;

	up	<='0';
	down	<='0';
	WAIT FOR period;
	WAIT FOR period;
END LOOP;		-- UP domineert DOWN (zie if else. lijn 36 udcounter.vhd)
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------UP met rst halverwegen-----------
FOR J IN 0 TO 8 loop
	up	<='1';
	WAIT FOR period;
	up	<='0';
	WAIT FOR period;
END LOOP;
rst	<='1';
FOR J IN 0 TO 8 loop
	up	<='1';
	WAIT FOR period;
	up	<='0';
	WAIT FOR period;
END LOOP;
WAIT FOR period;
rst	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------DOWN met rst halverwegen-----------
FOR J IN 0 TO 8 loop
	DOWN	<='1';
	WAIT FOR period;
	DOWN	<='0';
	WAIT FOR period;
END LOOP;
rst	<='1';
FOR J IN 0 TO 8 loop
	DOWN	<='1';
	WAIT FOR period;
	DOWN	<='0';
	WAIT FOR period;
END LOOP;
WAIT FOR period;
rst	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
WAIT;
END PROCESS;
END;



