-- Made by Ruben Kindt 14/11/2018
-- tb for the matchedFilter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity matchedFilter_tb is
end matchedFilter_tb;

architecture structural of matchedFilter_tb is 

-- Component Declaration: alle in/out
component matchedFilter
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	chip_sample	:IN  std_logic:='0';
	sdi_spread	:IN  std_logic:='0';
	dips_in		:IN  std_logic_vector(1 downto 0):="00";
	seq_det_MFilter	:OUT  std_logic:='0'
	);
end component;
for uut : matchedFilter use entity work.matchedFilter(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:      	std_logic:='0';
signal clk_en:    	std_logic:='1';
signal rst:       	std_logic:='0';
signal chip_sample:	std_logic:='0';
signal sdi_spread:	std_logic:='0';
signal dips_in:		std_logic_vector(1 downto 0):="00";
signal seq_det_MFilter:	std_logic:='0';

BEGIN
uut: matchedFilter PORT MAP(
	clk       	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	chip_sample	=> chip_sample,
	sdi_spread	=> sdi_spread,
	dips_in		=> dips_in,
	seq_det_MFilter	=> seq_det_MFilter
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
variable  pn1: std_logic_vector(0 to 30):="0100001010111011000111110011010";
			-- controle	   0100001010111011000111110011010
variable  pn2: std_logic_vector(0 to 30):="1110000110101001000101111101100";
			-- controle 	   1110000110101001000101111101100
variable  gld: std_logic_vector(0 to 30):=pn1 xor pn2;
		-- zou dit moeten zijn:    1010001100010010000010001110110
BEGIN
clk_en	<='1';
rst       	<='0';
sdi_spread    	<='0'; 
dips_in		<="00";
wait for period;
wait for period;
-----------detect match for unencrypted----------
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<='1';
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for unencrypted COMPLEMENT----------
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<='0';
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for pn1----------
dips_in		<="01";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=pn1(I); 	-- loopt over de variable pn1 zie lijn 63 en neemt daar de I'de bit van
	WAIT FOR period;		 
	chip_sample	<='1';		
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for NOT(pn1)----------
dips_in		<="01";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=NOT(pn1(I)); 	-- loopt over de variable pn1 zie lijn 63 en neemt daar het complement van (I'de bit) van
	WAIT FOR period;			
	chip_sample	<='1';			
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for pn2----------
dips_in		<="10";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=pn2(I); 		-- loopt over de variable pn2 zie lijn 64 en neemt daar de I'de bit van
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for NOT(pn2)----------
dips_in		<="10";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=NOT(pn2(I)); 	-- loopt over de variable pn2 zie lijn 64 en neemt daar complement van(I'de bit) van
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------detect match for gold----------
dips_in		<="11";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=gld(I); 		-- loopt over de variable gld zie lijn 65 en neemt daar de I'de bit van
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-------------detect match for NOT(gold)----------
dips_in		<="11";
FOR I IN 0 TO 30 loop 			
	WAIT FOR period;
	sdi_spread	<=NOT(gld(I)); 	-- loopt over de variable gld zie lijn 65 en neemt daar het complement van(I'de bit) van
	WAIT FOR period;
	chip_sample	<='1';
	WAIT FOR period;
	chip_sample	<='0';
END LOOP;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------rst test----------
rst	<='1';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
rst	<='0';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS tb;
END;