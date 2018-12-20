-- Made by Ruben Kindt 3BaE-ICT 25/10/2018
-- sequenceController_tb
-- Changes in this document must also be made in /receiver/receiver_Access_Layer/pN_generator_and_NCO.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pngenerator is
port (
	clk:      in std_logic;
	clk_en:   in std_logic:='1';
 	rst:      in std_logic:='0';
  	pn_start: out std_logic:='0'; -- wanneer we de sequencie opnieuw terug tegen komen komt deze op 1
  	pn1:      out std_logic:='0';
  	pn2:      out std_logic:='0';
  	gold:     out std_logic:='0' -- xor van bovenste 2
	);
end pngenerator;

architecture behav of pngenerator is
    
signal regi_pn1, regi_next_pn1: std_logic_vector(0 to 4):= "00010"; -- init, zo gekozen voor sequentie van 31 lang
signal regi_pn2, regi_next_pn2: std_logic_vector(0 to 4):= "00111"; -- init

begin
pn1   <= regi_pn1(4);
pn2   <= regi_pn2(4);
gold  <= regi_pn1(4) xor regi_pn2(4);

syn_shift: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
        if rst = '1' then
            regi_pn1 <= "00010";	-- reset= gekende toestand zetten: 00010
            regi_pn2 <= "00111";	-- reset= gekende toestand zetten: 00111
        else
            regi_pn1 <= regi_next_pn1;	-- anders nieuwe inladen
            regi_pn2 <= regi_next_pn2;	-- anders nieuwe inladen
        end if;
else
end if;
end process syn_shift;

com_count: process(regi_pn1, regi_pn2, regi_next_pn1) 
begin
regi_next_pn1 <= (regi_pn1(1) xor regi_pn1(4))& regi_pn1(0 to 3); 	-- (laatste xor met 2de) + eerste tot voorlaatste één opschuiven
regi_next_pn2 <= (((regi_pn2(4) xor regi_pn2(3)) xor regi_pn2(1)) xor regi_pn2(0)) & regi_pn2(0 to 3); 	-- ((4 xor 3) xor 1 )xor 0 +  eerste tot voorlaatste één opschuiven
-- we shiften van link naar rechts
--      0 1 0 0 0+ clk=>  00100
--      ^bit0   ^bit4 		vector(0 tot 4)
if regi_next_pn1 = "00010" -- verandert op de clk slag want regi_pn1 en 2 veranderen synchroon en regi_next_pn1 verandert enkel hier
then 
	pn_start <='1';
else
	pn_start <='0';
end if;
end process com_count;
end behav;




