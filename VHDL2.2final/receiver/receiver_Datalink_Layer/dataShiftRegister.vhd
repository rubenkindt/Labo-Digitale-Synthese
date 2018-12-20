-- Made By Ruben Kindt	19/11/2018
-- dataShiftRegistor loads the value from the databit when bit_sample is high

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dataShiftRegister IS
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	databit		:IN  std_logic:='0';
	bit_sample	:IN  std_logic:='0';
	data_datalink	:OUT  std_logic_vector(0 to 10):=(others=>'0')
	);
END;

ARCHITECTURE behav OF dataShiftRegister IS
SIGNAL data_pres	:std_logic_vector(0 to 10):=(others=>'0');
SIGNAL data_next	:std_logic_vector(0 to 10):=(others=>'0');

BEGIN
data_datalink	<=data_pres;

synchroon: Process(clk)
BEGIN
if rising_edge(clk) and clk_en='1' then --and bit_sample='1'then
	if rst='1' then
		data_pres	<=(others=>'0');
	else	
		if bit_sample='1' then
			data_pres	<=data_next;
		else
		end if;
	end if;	
ELSE
END IF;
END PROCESS synchroon;

combinatorisch:PROCESS(databit,data_pres)
BEGIN
data_next	<=data_pres(1 to 10) & databit;
END PROCESS combinatorisch;
END behav;