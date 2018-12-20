-- Made by Ruben Kindt 04/10/2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer_tb is
end debouncer_tb;

architecture structural of debouncer_tb is 

-- Component Declaration: wat heeft onze black box(onze debouncer.vhdl) nodig?
component debouncer
port (
  clk:          in std_logic;
  clk_en:       in std_logic;
  rst:          in std_logic;
  knop_a:       in std_logic;
  syn_out:     out std_logic
  );
end component;
-- hier maken we van alle in/outgangen signalen om ze dan te koppelen
for uut : debouncer use entity work.debouncer(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       std_logic:='0';
signal clk_en:    std_logic:='1';
signal rst:       std_logic:='0';
signal knop_a:    std_logic:='0';
signal syn_out:   std_logic;


BEGIN
-- poorten (in/out) Code.vhd=> signalen testbanch_tb.vhd
uut: debouncer PORT MAP(
	clk       => clk,
	clk_en    => clk_en,
	rst       => rst,
	knop_a    => knop_a,
	syn_out	  => syn_out
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
knop_a    <='0';  
wait for delay; --insert delay 10 ns
wait for period;
-----------Test '1' normaal----------
knop_a	<='1';
FOR J IN 0 TO 30 loop 			
	WAIT FOR period;
END LOOP;
-----------Test '0' normaal----------
knop_a	<='0';
FOR J IN 0 TO 30 loop 			
	WAIT FOR period;
END LOOP;
-----------Test '1' BOUNCE----------
knop_a	<='1';
WAIT FOR period;
WAIT FOR period;
knop_a	<='0';
WAIT FOR period;
knop_a	<='1';
FOR J IN 0 TO 30 loop	-- even stabiel	houden
	WAIT FOR period;
END LOOP;
-----------Test '0' BOUNCE----------
knop_a	<='0';
WAIT FOR period;
WAIT FOR period;
knop_a	<='1';
WAIT FOR period;
knop_a	<='0';
FOR J IN 0 TO 30 loop	-- even stabiel	houden
	WAIT FOR period;
END LOOP;

-----------RST TEST normaal------------
rst	<='0';
knop_a	<='1';	-- rst naar 0000 dus even naar 1111
FOR J IN 0 TO 6 loop 	-- 6 zodat rst test volledig op één beeld past	
	WAIT FOR period;
END LOOP;
rst	<= '1';
FOR J IN 0 TO 30 loop 			
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift------------
rst	<='0';
knop_a	<='1';	-- rst naar 0000 dus even naar 1111
FOR J IN 0 TO 6 loop 	-- 6 zodat rst test volledig op één beeld past
	
	WAIT FOR period;
END LOOP;
knop_a	<='0';		-- zat 1111 in regi, dus shift wordt 1
WAIT FOR period;
WAIT FOR period;
rst	<= '1';		-- rst voor clk regi = 0011 
WAIT FOR period;	--     na   clk regi = 0000
WAIT FOR period;
knop_a <= '1'; 		-- zal regi veranderen? NEEN, (regi-next wel)
FOR J IN 0 TO 30 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
END;
