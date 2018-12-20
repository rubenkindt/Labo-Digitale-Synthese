-- Made by Ruben Kindt	11/10/2018
-- 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity udcounter is
port (	
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	up, down, rst:	in std_logic:='0';
	count_out: 	out std_logic_vector(3 downto 0):=(others => '0')
	);
end udcounter;

architecture behav of udcounter is
signal pres_count, next_count: std_logic_vector(3 downto 0):=(others => '0');

begin
count_out <= pres_count;

syn_count: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' then
          pres_count <= (others => '0');	-- synchrone rst, terug naar 0
    else
          pres_count <= next_count;		-- anders de volgende staat inladen
    end if;
else
end if;
end process syn_count;

com_count: process(pres_count, up, down)	-- pres_count staat hierin anders verandert nextcount niet, (bij een rst signaal zonder up,down signaal)
begin
if(up = '1') then
	next_count <= pres_count + "0001";
elsif (down='1') THEN
	next_count <= pres_count - "0001";

else 	next_count <= pres_count;	-- geen van beide geeft een puls, dus niets verander
end if;
end process com_count; 
end behav;
    