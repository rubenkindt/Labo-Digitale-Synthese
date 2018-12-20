-- Made By Ruben Kindt	05/12/2018
-- positiondecoder testbench
-- later changed to an testbench for a flank and decoder for a positionencoder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity posenc_tb is
end posenc_tb;

architecture structural of posenc_tb is 

component posenc
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	syncha		:IN  std_logic:='0';
	synchb		:IN  std_logic:='0';
	draaiKUp	:OUT std_logic:='0';
	draaiKDown	:OUT std_logic:='0'
  	);
end component;
for uut : posenc use entity work.posenc(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       std_logic:='0';
signal clk_en:    std_logic:='1';
signal rst:       std_logic:='0';
signal syncha:    std_logic:='0';
signal synchb:    std_logic:='0';
signal draaiKUp:   std_logic:='0';
signal draaiKDown: std_logic:='0';

BEGIN
uut: posenc PORT MAP(
	clk       => clk,
	clk_en    => clk_en,
	rst       => rst,
	syncha    => syncha,
	synchb    => synchb,
	draaiKUp   => draaiKUp,
	draaiKDown => draaiKDown
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
syncha    <='0';
synchb    <='0';
wait for delay; --insert delay 10 ns 
wait for period;
wait for period;
-----------flank normaal MET de clk mee draaien----------
for i in 0 to 5 loop
	syncha	<='1';
	Wait for period;
	synchb	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	syncha	<='0';
	Wait for period;
	synchb	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-----------flank normaal TEGEN de clk in draaien----------
for i in 0 to 5 loop
	synchb	<='1';
	Wait for period;
	syncha	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	synchb	<='0';
	Wait for period;
	syncha	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-----------RST met flank normaal TEGEN de clk in draaien----------
rst	<='1';

Wait for period;
synchb	<='1';
Wait for period;
syncha	<='1';
Wait for period;
Wait for period;
Wait for period;
synchb	<='0';
Wait for period;
syncha	<='0';
Wait for period;

rst	<='0';
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS tb;
END;



