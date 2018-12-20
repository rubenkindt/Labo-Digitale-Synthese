-- Made by Ruben Kindt 3BaE-ICT 2018
-- we shiften van link naar rechts
--  1     0 0 0 0 + clk=> x 1000
--  ^knop ^bit0 ^bit3
--     vector(0 tot 3)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity debouncer is
port (
	clk:        in std_logic;
	clk_en:     in std_logic:='1';
	knop_a:     in std_logic:='0';  -- asynchroon
	rst:        in std_logic:='0';
	syn_out:    out std_logic:='0'
	);
end debouncer;

architecture behav of debouncer is
    
signal regi, regi_next: std_logic_vector(0 to 3):= (others => '0');
signal shift: std_logic:='0';

begin
shift   <= regi(3) xor knop_a; -- toont of we moeten shiften
syn_out <= regi(3);
 
syn_shift: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' then
      regi <= (others => '0');	-- reset= gekende toestand zetten: 0000
    else
      regi <= regi_next;	-- anders nieuwe inladen
    end if;
else
end if;
end process syn_shift;

com_count: process(knop_a, shift, regi)
begin
if (shift ='1') then
	regi_next <= knop_a & regi(0 to 2); 	-- shift  
	--  1     0 0 0 0   +   clk wordt x 	1 0 0 0
	--  ^knop ^bit0 ^bit3		  ^knop ^bit0 ^bit 3
else 
	regi_next <= (others => regi(3));   	-- parallell load
end if;     
end process com_count;
end behav;




