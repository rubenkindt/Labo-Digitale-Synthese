-- Made by Ruben Kindt 11/11/2018
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity dpll_tb is
end dpll_tb;

architecture structural of dpll_tb is 

-- Component Declaration: alle in/out
component dpll
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	sdi_spread	:IN  std_logic:='0';	-- ingangssignaal, wat hoort de ontvanger
	extb		:OUT std_logic:='0';	-- transitie gedetecteerd
	chip_sample	:OUT std_logic:='0';	-- is true, dan is het het meest veilig om de bit in te lezen
	chip_sampleD1	:OUT std_logic:='0';	-- delayed by 1 clk
	chip_sampleD2	:OUT std_logic:='0'	-- delayed by another clk
	);
end component;
for uut : dpll use entity work.dpll(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:       	std_logic:='0';
signal clk_en:    	std_logic:='1';
signal rst:       	std_logic:='0';
signal sdi_spread:	std_logic:='0';
signal extb:		std_logic:='0';
signal chip_sample:	std_logic:='0';	
signal chip_sampleD1:	std_logic:='0';	
signal chip_sampleD2:	std_logic:='0';

BEGIN
uut: dpll PORT MAP(
	clk       	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	sdi_spread	=> sdi_spread,
	extb	  	=> extb,
	chip_sample	=> chip_sample,
	chip_sampleD1	=> chip_sampleD1,
	chip_sampleD2	=> chip_sampleD2
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
sdi_spread    <='0';  
wait for delay; --insert delay 10 ns
wait for period;
wait for period;
-----------flank detectie + ittereren  we naar het correcte segment----------
FOR I IN 0 TO 10 loop 			
	sdi_spread	<='1';
	FOR J IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
	sdi_spread	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
-----------expres segment fout zetten----------	rond 36000ns gebeurd dit
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------Ittereren naar correcte segment----------
FOR I IN 0 TO 5 loop 			
	sdi_spread	<='1';
	FOR J IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
	sdi_spread	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
-----------rst test----------
rst	<='1';
FOR I IN 0 TO 10 loop 			
	sdi_spread	<='1';
	FOR J IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
	sdi_spread	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
rst	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------ittereren naar juist segment na rst--------------
FOR I IN 0 TO 5 loop 			
	sdi_spread	<='1';
	FOR J IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
	sdi_spread	<='0';
	FOR jj IN 0 TO 15 loop 			
		WAIT FOR period;
	END LOOP;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS tb;
END;



