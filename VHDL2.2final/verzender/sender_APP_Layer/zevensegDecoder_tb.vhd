-- Made by Ruben Kindt 13/10/2018
-- 4bit naar 7-segment converter
-- puur combinatorisch process
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity zevensegdecoder_tb is
end zevensegdecoder_tb;

architecture structural of zevensegdecoder_tb is 

-- Component Declaration: alle In/Out
component zevensegdecoder
port (
--  clk:		in std_logic;	-- puur combinatorisch proces
--  clk_en:		in std_logic;
--  rst:		in std_logic;	-- rst zorgt in de udcounter voor count= "0000", hier overbodig
  count:	in  std_logic_vector(3 downto 0):=(others => '0');
  led:		out std_logic_vector(7 downto 0):=(others => '0')
  );
end component;

for uut : zevensegdecoder use entity work.zevensegdecoder(behav);
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

--signal clk:	std_logic:='0';
--signal clk_en:std_logic:='1';
--signal rst:	std_logic:='0';
signal count:	std_logic_vector(3 downto 0):=(others => '0');
signal led:	std_logic_vector(7 downto 0):=(others => '0');


BEGIN
--  alle in/out koppelen
uut: zevensegdecoder PORT MAP(
--	clk	=> clk,
--	clk_en	=> clk_en,
--	rst	=> rst,
	count	=> count,
	led	=> led
	);

--
--  clock : process
--   begin 
--       clk <= '0';
--       wait for period/2;
--     loop
--       clk <= '0';
--       wait for period/2;
--       clk <= '1';
--       wait for period/2;
--       exit when end_of_sim;
--     end loop;
--     wait;
--   end process clock;
  
tb : PROCESS 
BEGIN
----------- van 0 naar F normaal----------
count	<="0000";
WAIT FOR period;
count	<="0001";
WAIT FOR period;
count	<="0010";
WAIT FOR period;
count	<="0011";
WAIT FOR period;
count	<="0100";
WAIT FOR period;
count	<="0101";
WAIT FOR period;
count	<="0110";
WAIT FOR period;
count	<="0111";
WAIT FOR period;
count	<="1000";
WAIT FOR period;
count	<="1001";
WAIT FOR period;
count	<="1010";
WAIT FOR period;
count	<="1011";
WAIT FOR period;
count	<="1100";
WAIT FOR period;
count	<="1101";
WAIT FOR period;
count	<="1110";
WAIT FOR period;
count	<="1111";
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
-------------when others test----------
--count	<="----"; -- '-' is het don't care-teken
--WAIT FOR period;
--WAIT FOR period;
--count	<="0000";
--
--WAIT FOR period;
--WAIT FOR period;
wait;
END PROCESS;
END;




