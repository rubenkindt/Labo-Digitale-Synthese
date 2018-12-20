-- by Ruben Kindt
-- 23/11/2018
-- based on a version writen by Jan Meel

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY clkdiv IS
PORT   (
	divClk:		IN  std_logic:='0';
	divClk_en:	OUT  std_logic:='0'
	);
END clkdiv;

ARCHITECTURE behav OF clkdiv IS
SIGNAL count_pres,count_nxt:	std_logic_vector(0 to 9):=(OTHERS=>'1');
CONSTANT nulletjes: 		std_logic_vector(0 to 9):=(others=>'0');

BEGIN

div : PROCESS (divClk)
BEGIN
IF rising_edge(divClk) then
	count_pres <= count_nxt;
else
END IF;
END PROCESS div;

comb: process(count_pres)
begin
if (count_pres=nulletjes) then
	divClk_en	<='1';
	count_nxt	<=(others=>'1');
else
	divClk_en	<='0';
	count_nxt	<=count_pres - 1;
end  if;
end process comb;
END behav;