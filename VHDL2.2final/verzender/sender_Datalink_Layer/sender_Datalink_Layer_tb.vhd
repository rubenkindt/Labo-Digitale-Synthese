-- Made by Ruben Kindt 05/11/2018
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity datalinkLayer_tb is
end;

architecture bench of datalinkLayer_tb is
component datalinkLayer
port (  
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	pn_start:	in std_logic:='0';
	udCounter:	in std_logic_vector(3 downto 0):="0000";
	unencrypted:	out std_logic:='0'
	);
end component;
constant period: 	time := 100 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal clk,rst:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal pn_start:	std_logic:='0';
signal udCounter:	std_logic_vector(3 downto 0):="0000";
signal unencrypted:	std_logic:='0';

begin
uut: datalinkLayer 
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst,
	pn_start	=> pn_start,
	udCounter	=> udCounter,
	unencrypted	=> unencrypted
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
rst		<='1';
udCounter	<="1010";
pn_start	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst		<='0';
wait for period;
wait for period;
------------2 keer pn_start---------- 62=2*31 keer het dataregister legen
FOR J IN 0 TO 62 loop		-- 62 want dan zien we de 3de keer net beginnen
	FOR JJ IN 0 TO 30 LOOP
		WAIT FOR period;
	END LOOP;
	pn_start	<='1';
	WAIT FOR period;
	pn_start	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------- udcounter laten veranderen------------
pn_start	<='1';	-- load is hier gebeurd
WAIT FOR period;
pn_start	<='0';
WAIT FOR period;
WAIT FOR period;
udCounter	<="1111";
WAIT FOR period;
FOR J IN 0 TO 24 loop
	pn_start	<='1';
	WAIT FOR period;
	pn_start	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------RST TEST------------
rst		<='1';
Wait for period;
Wait for period;
FOR J IN 0 TO 24 loop
	pn_start	<='1';
	WAIT FOR period;
	pn_start	<='0';
	WAIT FOR period;
	WAIT FOR period;
	WAIT FOR period;
END LOOP;
rst	<='0';
Wait for period;
Wait for period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;

