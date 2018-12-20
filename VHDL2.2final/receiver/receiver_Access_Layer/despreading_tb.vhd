-- Made by Ruben Kindt	17/11/2018
-- test bench for a simple synchroon xor gate that updates when chip_sample is high
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity despreading_tb is
end despreading_tb;

architecture structural of despreading_tb is 

component despreading
port (
	pn_seq:		in std_logic:='0';
	sdi_spread:	in std_logic:='0';
	chip_sample:	in std_logic:='0';
	xor_despread:	out std_logic:='0'
	);
end component;

for uut : despreading use entity work.despreading(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;

signal pn_seq:		std_logic:='0';
signal sdi_spread:	std_logic:='0';
signal chip_sample:	std_logic:='0';
signal xor_despread:	std_logic:='0';


BEGIN
uut: despreading PORT MAP(
	pn_seq 		=> pn_seq,
	sdi_spread 	=> sdi_spread,
	chip_sample 	=> chip_sample,
	xor_despread 	=> xor_despread
	);
	
tb : PROCESS
BEGIN
sdi_spread	<='1';
pn_seq	<='1';
chip_sample	<='0';
wait for delay;
wait for period;
wait for period;
WAIT FOR period;
----------- 1 xor 1 = 0----------
sdi_spread	<='1';
pn_seq		<='1';
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 		-- want er zitten ongeveer 16 clk's tussen elke chip_sample		
	WAIT FOR period;
END LOOP;
----------- 1 xor 0 = 1----------
sdi_spread	<='1';
pn_seq		<='0';
WAIT FOR period;		-- hier is de 16de
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 
	WAIT FOR period;
END LOOP;
----------- 0 xor 0 = 0----------
sdi_spread	<='0';
pn_seq		<='0';
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 
	WAIT FOR period;
END LOOP;
----------- 0 xor 1 = 1----------
sdi_spread	<='0';
pn_seq		<='1';
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 
	WAIT FOR period;
END LOOP;
----------- 1 xor 1 = 0----------
sdi_spread	<='1';
pn_seq		<='1';
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 
	WAIT FOR period;
END LOOP;
----------- 1 xor 0 = 1----------
sdi_spread	<='1';
pn_seq		<='0';
WAIT FOR period;
chip_sample	<='1';
WAIT FOR period;
chip_sample	<='0';
FOR I IN 0 TO 14 loop 
	WAIT FOR period;
END LOOP;


WAIT;
END PROCESS;
END;



