-- Made by Ruben Kindt 20/11/2018

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity receiver_AppLayer_tb is
end;

architecture bench of receiver_AppLayer_tb is
component receiver_AppLayer
port (  
--	clk,rst:	in std_logic:='0';	-- overbodig
--	clk_en:		in std_logic:='1';
	bit_sample:	in std_logic:='0';
	data_datalink:	in std_logic_vector(0 to 10):=(others=>'0');
	led:		out std_logic_vector(0 to 7):=(others=>'1')
	);
end component;
constant period: 	time := 100 ns;
--signal end_of_sim:	boolean := false;

--signal clk,rst:	std_logic:='0';
--signal clk_en:	std_logic:='1';
signal bit_sample:	std_logic:='0';
signal data_datalink:	std_logic_vector(0 to 10):=(others=>'0');
signal led:		std_logic_vector(0 to 7):=(others=>'1');

begin
uut: receiver_AppLayer 
port map(
--	clk		=> clk,
--	clk_en		=> clk_en,
--	rst		=> rst,
	bit_sample	=> bit_sample,
	data_datalink	=> data_datalink,
	led		=> led
	);

--clock : process
--begin 
--clk <= '0';
--wait for period/2;
--loop
--	clk <= '0';
--	wait for period/2;
--       	clk <= '1';
--     	wait for period/2;
--       	exit when end_of_sim;
--end loop;
--wait;
--end process clock;
  
tb : PROCESS 
BEGIN
data_datalink	<="10101010101";
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
data_datalink	<="01111101111";
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
data_datalink	<=(others=>'0');
FOR J IN 0 TO 20 loop
	WAIT FOR period;
END LOOP;
FOR J IN 0 TO 20 loop
	bit_sample	<='0';
	WAIT FOR period;
	bit_sample	<='1';
	WAIT FOR period;
END LOOP;
----------END SIM--------------
--end_of_sim <= true;
wait;
END PROCESS;
end;

