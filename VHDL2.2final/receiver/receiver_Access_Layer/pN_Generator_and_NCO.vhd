-- Made by Ruben Kindt 3BaE-ICT 18/10/2018
-- Changed at 15/11/2018: name changes and added a positive pulse detection
-- PN Generator with NCO
-- we shiften van link naar rechts
--      0 1 0 0 0+ clk=>  00100
--      ^bit0   ^bit4
--        vector(0 upto 4)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pngeneratorAndNCO is
port (
	clk:      	in std_logic;
	clk_en:   	in std_logic:='1';
 	rst:      	in std_logic:='0';
	chip_sampleD1: 	in std_logic:='0';
	seq_det:	in std_logic:='0';
	bit_sample:	out std_logic:='0';
  	pn1_receiver:	out std_logic:='0';
  	pn2_receiver:	out std_logic:='0';
  	gold_receiver:	out std_logic:='0'
	);
end pngeneratorAndNCO;

architecture behav of pngeneratorAndNCO is
signal full_seq: 		std_logic:='0'; -- wanneer we de sequens opnieuw terug tegen komen komt deze op 1
signal regi_pn1, regi_next_pn1: std_logic_vector(0 to 4):= "00010"; -- init
signal regi_pn2, regi_next_pn2: std_logic_vector(0 to 4):= "00111"; -- init

TYPE state IS (WaitFor1, WaitFor0, Puls1, Puls0);	-- voor de pos flank detector
SIGNAL present_state,next_state : state;
SIGNAL bit_sample_nco_sig:	 std_logic:='0';

begin
pn1_receiver   <= regi_pn1(4);
pn2_receiver   <= regi_pn2(4);
gold_receiver  <= regi_pn1(4) xor regi_pn2(4);

syn_shift: process(clk)
begin
if rising_edge(clk) and clk_en ='1'  then
        if rst = '1' or seq_det='1' then
            regi_pn1 <= "00010";	-- reset= gekende toestand zetten: 00010, dit voor een sequentie vqn 31 clk's
            regi_pn2 <= "00111";	-- reset= gekende toestand zetten: 00111
        else
		if chip_sampleD1='1' then
			regi_pn1 <= regi_next_pn1;	-- anders nieuwe inladen
            		regi_pn2 <= regi_next_pn2;	-- anders nieuwe inladen
		else
		end if;
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
--      ^bit0   ^bit4
--        vector(0 tot 4)
if regi_next_pn1 = "00010" -- verandert op de clk slag want regi_pn1 en 2 veranderen synchroon en regi_next_pn1 verandert enkel hier
then 
	full_seq <= '1';
else
	full_seq <= '0';
end if;
end process com_count;

synchroon_Pflank: Process(clk)
BEGIN
If rising_edge(clk) and clk_en='1' THEN
	IF (rst = '1') THEN
		present_state <= WaitFor1; 	-- geen pulsen
	ELSE 	
		if chip_sampleD1='1' then
			present_state <= next_state;	-- anders volgende inladen
		else
			present_state	<=present_state;
		end if;
	END IF;
ELSE
END IF;
END PROCESS synchroon_Pflank;

combinatorisch_posFlankDetec:PROCESS(present_state,full_seq)
BEGIN
CASE present_state IS
	WHEN WaitFor1=>		-- wachten tot er een 1 binnen komt
		bit_sample_nco_sig	<='0';
		IF (full_seq='1') THEN 
			next_state <=Puls1;	-- '1' gezien, naar puls1 gaan
		ELSE 	next_state <=WaitFor1;	-- niets gevonden, verder wachten op '1'
		END IF;	
	WHEN Puls1=>		-- Pos puls genereren, dan op '0' wachten
		bit_sample_nco_sig	<='1';
		next_state <= WaitFor0;			-- we staan op 1, nu wachten we op '0'
	WHEN WaitFor0=>		-- wachten tot er een 0 binnen komt
		bit_sample_nco_sig	<='0';
		IF (full_seq='0') THEN
			next_state <=Puls0;	-- '0' gezien naar puls0 gaan
		ELSE	next_state <=WaitFor0;	-- niets gevonden, verder zoeken achter '0'
		END IF;
	WHEN Puls0 =>		-- Neg puls is overbodig dus op '0'
		bit_sample_nco_sig	<='0';
		next_state <= WaitFor1;
	WHEN OTHERS=>
		bit_sample_nco_sig	<='0';
		next_state <=WaitFor1;
END CASE;
END PROCESS combinatorisch_posFlankDetec;

delay_bit_sample: Process(clk)		-- deze delay toegevoed omdat bit_sample te vroeg in de correlator binnen kwam
BEGIN
If rising_edge(clk) and clk_en='1' THEN
	if chip_sampleD1='1' then
		bit_sample <= bit_sample_nco_sig;	-- anders volgende inladen
	else
		bit_sample <= '0';
	end if;
ELSE
END IF;
END PROCESS delay_bit_sample;
end behav;
