-- Made by Ruben Kindt	11/10/2018
-- 6 bit u/d counter 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity correlator is
port (
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	rst:		in std_logic:='0';
	chip_sample:	in std_logic:='0';
	bit_sample:	in std_logic:='0';
	sdi_despread:	in std_logic:='0';
	databit:	out std_logic:='0'
	);
end correlator;

architecture behav of correlator is
signal pres_count, next_count: 	std_logic_vector(5 downto 0):="100000";
signal msb:		 	std_logic:='0';	-- een niet vertraagde databit
constant preset: 		std_logic_vector(5 downto 0):="100000";

begin
syn_count: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' or bit_sample ='1' then
          pres_count <= preset;			-- synchrone rst, terug naar preset
    else
	if chip_sample ='1' then
	          pres_count <= next_count;		-- anders de volgende staat inladen
	else
	end if;
    end if;
else 
end if;
end process syn_count;

com_count: process(pres_count,chip_sample,sdi_despread)	-- chip_sample zit hierin omdat
begin
IF(sdi_despread = '1') THEN
	next_count <= pres_count + "0001";
ELSIF (sdi_despread='0') THEN
	next_count <= pres_count - "0001";
ELSE 	next_count <= pres_count;
END IF;
end process com_count; 

com_output: process(pres_count)	-- pres_count staat hierin anders verandert nextcount niet, (bij een rst signaal zonder up,down signaal)
begin
if pres_count >= preset THEN	-- meer positieve sdi_despread gezien, dus 1 naar buiten. Hier zit == ook bij in
	msb <= '1';
elsif pres_count < preset THEN	-- meer negatieve sdi_despread gezien, dus 0 naar buiten
	msb <= '0';
else 	msb <= '0';		-- catch errors
end if;
end process com_output;

chip_delay: process(clk) 	-- anders waren we wat snel
begin
If rising_edge(clk) and clk_en='1' THEN
	databit		<= msb;
ELSE
END IF;
end process chip_delay;
end behav;
    