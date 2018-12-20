-- Made by Ruben Kindt 3BaE-ICT 25/10/2018
-- sequenceController
-- geeft de eerste pn_start door naar load, de andere 11 door naar shift
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sequenceController is
port (
	clk:      in std_logic;
	clk_en:   in std_logic:='1';
 	rst:      in std_logic:='0';
  	pn_start: in std_logic:='0';
  	shift:    out std_logic:='0';
  	load:     out std_logic:='0'
	);
end sequenceController;

architecture behav of sequenceController is
signal shift_next:	std_logic:='0';
signal load_next:	std_logic:='0';
signal count_next:	std_logic_vector(3 downto 0):=(others=>'0');
signal shift_pres:	std_logic:='0';
signal load_pres:	std_logic:='0';
signal count_pres:	std_logic_vector(3 downto 0):=(others=>'0');

begin
shift	<=shift_pres;
load	<=load_pres;


syn_shift: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
        if rst = '1' then
            	count_pres	<= "0000";	-- reset= gekende toestand zetten: 0000
		shift_pres	<= '0';
		load_pres	<= '0';
        else
		count_pres	<= count_next;
            	shift_pres	<= shift_next;
		load_pres	<= load_next ;
        end if;
else
end if;
end process syn_shift;

com_count: process(pn_start, count_pres)
begin
if (pn_start='1')then	
	case count_pres is 
		when "0000" => 		-- dus loaden
			count_next	<= count_pres + 1;
			shift_next	<= '0';
			load_next	<= '1';
		when "1010" => 		-- 1010 bin is 10 dec, heeft 10 keer ge-shift, dus nu de laatste keer: komt op een totaal van 11
			count_next	<= (others=>'0'); --  TELLER reseten
			shift_next	<= pn_start;
			load_next	<= '0';
		when others =>		-- ergens tussen 0000 en 1010 pulsen of als de teller kapot gaat (>1010 , XXXX)
			count_next	<= count_pres + 1;
			shift_next	<= pn_start;	-- dus shiften
			load_next	<= '0';
	end case;
else
	count_next	<= count_pres;
	shift_next	<= '0';
	load_next	<= '0';
end if;
end process com_count;
end behav;



