-- Made by Ruben Kindt 07/10/2018
-- flank detector testbensh
-- aangepast naar een pos flankdetector
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity edge_tb is
end edge_tb;

architecture structural of edge_tb is 

-- Component Declaration: alle in/out
component edge
port (
  clk:          in std_logic;
  clk_en:       in std_logic;
  rst:          in std_logic;
  syncha:       in std_logic;
  edge_pos:     out std_logic
--  edge_neg:     out std_logic
  );
end component;
for uut : edge use entity work.edge(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       std_logic:='0';
signal clk_en:    std_logic:='1';
signal rst:       std_logic:='0';
signal syncha:    std_logic:='0';
signal edge_pos:   std_logic;
--signal edge_neg:   std_logic;

BEGIN
-- Code.vhd=> testbanch_tb.vhd
-- poorten (in/out) Code.vhd=> signalen testbanch_tb.vhd
  uut: edge PORT MAP(
	clk       => clk,
	clk_en    => clk_en,
	rst       => rst,
	syncha    => syncha,
	edge_pos  => edge_pos	--,
--	edge_neg  => edge_neg
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
wait for delay; --insert delay 10 ns 
wait for period;
wait for period;
-----------pos flank normaal----------
syncha	<='1';
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-------------neg flank normaal----------
--syncha	<='0';
--FOR J IN 0 TO 10 loop 			
--	WAIT FOR period;
--END LOOP;
-----------pos flank met rst ----------
rst	<='1';
syncha	<='1';
FOR J IN 0 TO 10 loop
	WAIT FOR period;
END LOOP;
------------neg flank met rst-----------
--rst	<='0';		-- normale positie
--WAIT FOR period;
--WAIT FOR period;
--WAIT FOR period;
--rst	<='1';
--syncha	<='0';
--FOR J IN 0 TO 10 loop
--	WAIT FOR period;
--END LOOP;
-----------pos flank met rst na 1 periode----------
rst	<='0';		-- normale positie
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst	<='1';
WAIT FOR period;
syncha	<='1';
FOR J IN 0 TO 10 loop
	WAIT FOR period;
END LOOP;
------------neg flank met rst na 1 periode-----------
--rst	<='0';		-- normale positie
--WAIT FOR period;
--WAIT FOR period;
--WAIT FOR period;
--rst	<='1';
--WAIT FOR period;
--syncha	<='0';
--FOR J IN 0 TO 10 loop
--	WAIT FOR period;
--END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS tb;
END;



