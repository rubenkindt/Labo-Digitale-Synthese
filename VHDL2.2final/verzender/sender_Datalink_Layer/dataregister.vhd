-- Made By Ruben Kindt	04/11/2018
-- dataregistor loads the value from the u/dcounter when load is high
-- shifts the preamble and the count value out, in that order
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dataregister IS
PORT (	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	load		:IN  std_logic:='0';
	shift		:IN  std_logic:='0';
	data		:IN  std_logic_vector(3 downto 0):="0000";
	sdo_posenc	:OUT std_logic:='0'
	);
END;

ARCHITECTURE behav OF dataregister IS
CONSTANT preamble		:std_logic_vector(6  DOWNTO 0):="0111110";
SIGNAL preambleData_pres	:std_logic_vector(10 DOWNTO 0):=preamble&"0000";
SIGNAL preambleData_next	:std_logic_vector(10 DOWNTO 0):=preamble&"0000";
BEGIN

sdo_posenc	<=preambleData_pres(10);
synchroon: Process(clk)
BEGIN
if rising_edge(clk) and clk_en='1' then
	if rst='1' then
		preambleData_pres	<=preamble & "0000";
	else	
		preambleData_pres	<=preambleData_next;
	end if;	
ELSE
END IF;
END PROCESS synchroon;

combinatorisch:PROCESS(shift,load,preambleData_pres,data)
BEGIN
if load='1' then
	preambleData_next	<=preamble & data;
elsif shift ='1' then
	preambleData_next	<=preambleData_pres(9 downto 0) & '1';
else	preambleData_next	<=preambleData_pres;	
end if;
END PROCESS combinatorisch;
END behav;