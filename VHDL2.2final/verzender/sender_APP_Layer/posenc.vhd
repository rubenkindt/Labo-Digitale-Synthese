-- Made By Ruben Kindt	05/12/2018
-- positiondecoder
-- 
--
--						READ ME !!!!!!!!!!!
--
--
--	http://telescript.denayer.be/~kvb/Labo_Digitale_Synthese/3e-ict_Laboratorium%20Digitale%20Synthese.pdf
--	Pagina 9
--	Ik wil beide de draaiknop en de normale knopjes werkend hebben
--	Dus heb ik het schema bewerkt naar door de u/d counter er af te knipen, want de counter zit in de sender_app_layer.vhd ge"implementeerd
--	In dit .vhd bestand vind de flanken en decodeering plaats van de rotaty encoder
--	het samenvoegen van de UP's (draaiknop en drukknop) gebeurd in de appLayer
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY posenc IS
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	syncha		:IN  std_logic:='0';
	synchb		:IN  std_logic:='0';
	draaiKUp		:OUT std_logic:='0';
	draaiKDown	:OUT std_logic:='0'
	);
END;

ARCHITECTURE behav OF posenc IS
SIGNAL 	edge_up:	std_logic:='0';
SIGNAL 	edge_down:	std_logic:='0';

TYPE state IS (WaitFor1, WaitFor0, PulsDown, PulsUp);		-- alle mogelijke states voor edge detection
SIGNAL Bpresent_state, Bnext_state : state;

--signal zin: 	std_logic:='1';	-- dit kan perfect een variable zijn in de mux
-- het signaal "zin" is de oorzaal van veel spikes

BEGIN

B_synchroon_edge: Process(clk)		-- ---------------------------------------Synchroon voor Cha B----------------------------------------------------
BEGIN
If rising_edge(clk) and clk_en='1' THEN
	IF (rst = '1') THEN
		Bpresent_state <= WaitFor1; 	-- geen pulsen
	ELSE 	Bpresent_state <= Bnext_state;	-- anders volgende inladen
	END IF;
ELSE
END IF;
END PROCESS B_synchroon_edge;

B_combinatorisch_edge:PROCESS(Bpresent_state,synchb)	-- -----------------combinatorisch voor Cha B----------------------------------------------------
BEGIN
CASE Bpresent_state IS
	WHEN WaitFor1=>			-- wachten tot er een 1 binnen komt
		IF (synchb='1') THEN 
			Bnext_state <=PulsDown;	-- '1' gezien, naar pulsDown gaan
		ELSE 	
			Bnext_state <=WaitFor1;	-- niets gevonden, verder wachten op '1'
		END IF;	
		edge_up		<='0';	
		edge_down	<='0';
	WHEN PulsDown=>
		Bnext_state <= WaitFor0;
		edge_up		<='0';	
		edge_down	<='1';
	WHEN WaitFor0=>		-- wachten tot er een 0 binnen komt
		IF (synchb='0') THEN
			Bnext_state <=PulsUp;	-- '0' gezien naar pulsUp gaan
		ELSE	
			Bnext_state <=WaitFor0;	-- niets gevonden, verder zoeken achter '0'
		END IF;
		edge_up		<='0';
		edge_down	<='0';
	WHEN PulsUp =>
		Bnext_state <= WaitFor1;
		edge_up		<='1';			
		edge_down	<='0';
	WHEN OTHERS=>
		edge_up		<='0';			
		edge_down	<='0';
		Bnext_state <=WaitFor1;
END CASE;
END PROCESS B_combinatorisch_edge;

Zin_en_Mooie_uitgangen: Process(edge_up,edge_down,syncha)	-- -----------------zin----------------------------------------------------
variable zin:		std_logic:='0';	-- indien we hier met een signaal werken krijgen we spikes wanneer de zin weizigd 
BEGIN
if (edge_down='1') then
	if (syncha='0') then
		zin	:='0';
	else	zin	:='1';
	end if;
else
end if;
if (zin='1') then			-- indien wisselen van (tegen de klok in/met de klok mee) gewenst verander dit naar 0
	draaiKUp	<=edge_up;
	draaiKDown	<='0';
else	
	draaiKUp	<='0';
	draaiKDown	<=edge_down;
end if;
END PROCESS Zin_en_Mooie_uitgangen;
END behav;
