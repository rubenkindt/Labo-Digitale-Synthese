-- Made By Ruben Kindt	11/10/2018
-- hex to 7-segment decoder ACTIEF LAAG big endian
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

entity zevensegdecoderReceiver is
port (
	zevensegmData:	in  std_logic_vector(3 downto 0):=(others => '0');
	led:	 	out std_logic_vector(7 downto 0):=(others => '0')
	);
end zevensegdecoderReceiver;

architecture behav of zevensegdecoderReceiver is
begin

combinatorischLedDecoder:PROCESS (zevensegmData)	-- combinatorisch
VARIABLE temp_led :std_logic_vector(6 DOWNTO 0):=(OTHERS=>'0');
CONSTANT punt_led :std_logic:='1';	-- 7 segment led heeft een puntje, dit zetten we af
BEGIN
CASE zevensegmData IS
	WHEN "0000" =>
		temp_led :="0000001"; -- '0'
	WHEN "0001" =>
		temp_led :="1001111"; -- '1'
	WHEN "0010" =>
		temp_led :="0010010"; -- '2'
	WHEN "0011" =>
		temp_led :="0000110"; -- '3'
	WHEN "0100" =>
		temp_led :="1001100"; -- '4'
	WHEN "0101" =>
       		temp_led :="0100100"; -- '5'
	WHEN "0110" =>
       		temp_led :="0100000"; -- '6'
	WHEN "0111" =>
       		temp_led :="0001111"; -- '7'
	WHEN "1000" =>
       		temp_led :="0000000"; -- '8'
   	WHEN "1001" =>
       		temp_led :="0000100"; -- '9'
	WHEN "1010" =>
       		temp_led :="0001000"; -- 'a'
	WHEN "1011" =>
       		temp_led :="1100000"; -- 'b'
	WHEN "1100" =>
       		temp_led :="0110001"; -- 'c'
	WHEN "1101" =>
       		temp_led :="1000010"; -- 'd'
	WHEN "1110" =>
       		temp_led :="0110000"; -- 'e'
	WHEN "1111" =>
		temp_led :="0111000"; -- 'f'
	WHEN OTHERS =>
      		temp_led :="1111110"; -- '-' error
END CASE;
led <= temp_led & punt_led;
END PROCESS combinatorischLedDecoder;
end behav;
