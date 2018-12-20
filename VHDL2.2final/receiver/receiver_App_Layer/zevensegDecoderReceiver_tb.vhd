-- Made by Ruben Kindt 13/10/2018
-- 4bit naar 7-segment converter
-- puur combinatorisch process
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity zevensegdecoderReceiver_tb is
end zevensegdecoderReceiver_tb;

architecture structural of zevensegdecoderReceiver_tb is 


component zevensegdecoderReceiver
port (
  zevensegmData:in  std_logic_vector(3 downto 0):=(others => '0');
  led:		out std_logic_vector(7 downto 0):=(others => '0')
  );
end component;

for uut : zevensegdecoderReceiver use entity work.zevensegdecoderReceiver(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;


signal zevensegmData:	std_logic_vector(3 downto 0):=(others => '0');
signal led:		std_logic_vector(7 downto 0):=(others => '0');


BEGIN
uut: zevensegdecoderReceiver PORT MAP(
	zevensegmData	=> zevensegmData,
	led	=> led
	);

  
tb : PROCESS 
BEGIN
----------- van 0 naar F normaal----------
zevensegmData	<="0000";
WAIT FOR period;
zevensegmData	<="0001";
WAIT FOR period;
zevensegmData	<="0010";
WAIT FOR period;
zevensegmData	<="0011";
WAIT FOR period;
zevensegmData	<="0100";
WAIT FOR period;
zevensegmData	<="0101";
WAIT FOR period;
zevensegmData	<="0110";
WAIT FOR period;
zevensegmData	<="0111";
WAIT FOR period;
zevensegmData	<="1000";
WAIT FOR period;
zevensegmData	<="1001";
WAIT FOR period;
zevensegmData	<="1010";
WAIT FOR period;
zevensegmData	<="1011";
WAIT FOR period;
zevensegmData	<="1100";
WAIT FOR period;
zevensegmData	<="1101";
WAIT FOR period;
zevensegmData	<="1110";
WAIT FOR period;
zevensegmData	<="1111";
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-----------when others test----------
--zevensegmData	<="----"; -- '-' is het don't care-teken
--WAIT FOR period;
--WAIT FOR period;
--zevensegmData	<="0000";

WAIT FOR period;
WAIT FOR period;
wait;
END PROCESS;
END;




