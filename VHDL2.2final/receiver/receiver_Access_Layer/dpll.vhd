-- made by Ruben Kindt	11/11/2018
-- gestopt voor het SEMAFOOR deel
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dpll IS
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	sdi_spread	:IN  std_logic:='0';	-- ingangssignaal, wat hoort de ontvanger
	extb		:OUT std_logic:='0';	-- transitie gedetecteerd
	chip_sample	:OUT std_logic:='0';	-- 'sample maar'-signaal
	chip_sampleD1	:OUT std_logic:='0';
	chip_sampleD2	:OUT std_logic:='0'
	);
END;

ARCHITECTURE behav OF dpll IS
TYPE state IS (WaitFor1, WaitFor0, Puls1, Puls0);				-- voor de transitie detector
SIGNAL present_state,next_state : state;

SIGNAL pres_count, next_count: std_logic_vector(3 downto 0):=(others=>'0');	-- voor de transitie counter
SIGNAL extb_sig: 	std_logic:='0';
SIGNAL chip_sample_sig:	std_logic:='0';	
SIGNAL chip_sampleD1_sig:std_logic:='0';	
SIGNAL chip_sampleD2_sig:std_logic:='0';	
	
TYPE   seg is (a,b,c,d,e,nu11);							-- voor de decoders
SIGNAL segment_before_samafoor: seg;
SIGNAL segment_after_samafoor:  seg;

SIGNAL pres_countNCO	: std_logic_vector (4 downto 0):="00111";	-- voor het NCO-deel. - start waarde proberen we zo juist mogelijk te zetten, dus op 7
SIGNAL next_countNCO	: std_logic_vector (4 downto 0):="10000";	-- deze start waarde in onbelangrijk, wordt upgedate waneer pres_countNCO op nul komt
SIGNAL preloadNCO	: std_logic_vector (4 downto 0):="01111";	-- zetten we op 15 want de nul wordt ook mee geteld

TYPE   semafoor is(waitforExtb,waitforChip,pulsSegm_C,pulsSegmBefore_ToAfter); 	-- voor het semafoor
SIGNAL semafoor_pres,semafoor_nxt: semafoor;

BEGIN
extb		<= extb_sig;
chip_sample	<= chip_sample_sig;
chip_sampleD1 	<= chip_sampleD1_sig;
chip_sampleD2 	<= chip_sampleD2_sig;

chip_delay: process(clk) 			-- ---------------------------------------Delay voor Chip_samples------------------------------------------------
begin
If rising_edge(clk) and clk_en='1' THEN
	chip_sampleD1_sig	<= chip_sample_sig;
	chip_sampleD2_sig 	<= chip_sampleD1_sig;
ELSE
END IF;
end process chip_delay;

synchroon_transitie: Process(clk)		-- ---------------------------------------TRANSITIE----------------------------------------------------
BEGIN
If rising_edge(clk) and clk_en='1' THEN
	IF (rst = '1') THEN
		present_state <= WaitFor1; 	-- geen pulsen
	ELSE 	present_state <= next_state;	-- anders volgende inladen
	END IF;
ELSE
END IF;
END PROCESS synchroon_transitie;

combinatorisch_transitie:PROCESS(present_state,sdi_spread)	
BEGIN
CASE present_state IS
	WHEN WaitFor1=>		-- wachten tot er een 1 binnen komt
		extb_sig	<='0';
		IF (sdi_spread='1') THEN 
			next_state <=Puls1;	-- '1' gezien, naar puls1 gaan
		ELSE 	next_state <=WaitFor1;	-- niets gevonden, verder wachten op '1'
		END IF;	
	WHEN Puls1=>		-- Pos puls genereren, dan op '0' wachten
		extb_sig	<='1';
		next_state <= WaitFor0;			-- we staan op 1, nu wachten we op '0'
	WHEN WaitFor0=>		-- wachten tot er een 0 binnen komt
		extb_sig	<='0';
		IF (sdi_spread='0') THEN
			next_state <=Puls0;	-- '0' gezien naar puls0 gaan
		ELSE	next_state <=WaitFor0;	-- niets gevonden, verder zoeken achter '0'
		END IF;
	WHEN Puls0 =>		-- Neg puls genereren, dan op '1' wachten
		extb_sig	<='1';
		next_state <= WaitFor1;
	WHEN OTHERS=>
		extb_sig	<='0';
		next_state <=WaitFor1;
END CASE;
END PROCESS combinatorisch_transitie;

syn_count: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' or extb_sig ='1' then
          pres_count <= (others=>'0');		-- synchrone rst, terug naar 0
    else
          pres_count <= next_count;		-- anders de volgende staat inladen
    end if;
else
end if;
end process syn_count;

com_count: process(pres_count)
begin
next_count <= pres_count + "0001";
end process com_count; 

com_Transitie_to_Segment_decoder: process(pres_count)	-- --------------------------------------------------DECODER: Counter naar a,b,c,d,e---------------------------
begin
case pres_count is 
	when "0000"|"0001"|"0010"|"0011"|"0100" =>
		segment_before_samafoor	<= a;
	when "0101"|"0110"  =>
		segment_before_samafoor	<= b;
	when "0111"|"1000"  =>
		segment_before_samafoor	<= c;
	when "1001"|"1010" =>
		segment_before_samafoor	<= d;
	when "1011"|"1100"|"1101"|"1110"|"1111" =>
		segment_before_samafoor	<= e;
	when others =>
		segment_before_samafoor <= nu11;
end case;
end process com_Transitie_to_Segment_decoder;

syn_semafoor: process(clk)					-- ------------------------------------SEMAFOOR----------------------------------------------------
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' then
	semafoor_pres	<= waitforExtb;		
    else
	semafoor_pres 	<= semafoor_nxt;
    end if;
else
end if;
end process syn_semafoor;

com_semafoor: process(semafoor_pres,extb_sig,chip_sample_sig,segment_before_samafoor)
begin
CASE semafoor_pres IS
	WHEN waitforExtb=>
		IF (extb_sig ='1') then			-- 'normale' state, eerst extb dan chip
			semafoor_nxt	<= waitforChip;
		elsif (chip_sample_sig='1') then	-- eerst de chip_sample_sig gezien dan moet je seg c aan zetten, gebeurd later 
			semafoor_nxt	<= pulsSegm_C;
		else semafoor_nxt <=waitforExtb;
		end if;		
		segment_after_samafoor	<= nu11;
	WHEN waitforChip=>
		if (chip_sample_sig='1') then		-- 'normale' state, gewoon doorgeven van de segmenten
			semafoor_nxt		<= pulsSegmBefore_ToAfter;
			--segment_after_samafoor	<= segment_before_samafoor;	-- door deze te activeren kan je nog een clk vertraging uitsparen
		else	semafoor_nxt		<= waitforChip;
		end if;
		segment_after_samafoor	<= nu11;
	WHEN pulsSegmBefore_ToAfter=>
		segment_after_samafoor	<= segment_before_samafoor;	-- we doen deze berekeningen een clk-je vroeger zodat onze preload werkt met de nieuwe waarde ipv de vorige transitie waarde
		semafoor_nxt		<= waitforExtb;
	WHEN pulsSegm_C=>
		segment_after_samafoor	<= c;	-- omdat we geen extb hebben gezien was er geen overgang in het signaal dat de ontvanger heeft gezien, dit gebeurd bij 2 sequentiele 0-en of 1-en
						-- daarom zetten we deze vast op 'c'	-- zie lijn 30 dit signaal kan enkel a,b,c,d,e bevatten
		semafoor_nxt		<= waitforExtb;
	WHEN OTHERS=>
		semafoor_nxt 	<= waitforExtb;
		segment_after_samafoor	<= nu11;
END CASE;
end process com_semafoor;

com_Segment_To_Transitie_decoder: process(segment_after_samafoor)	-- -------------------------DECODER segment naar een wacht tijd-----------------------
begin
case segment_after_samafoor is 		-- down counter designed to count 16 clk's down
	when a =>			-- 				15->0 = 16 clk's
		preloadNCO	<= "01111"+"00011";	-- 15+3 clk's
	when b  =>
		preloadNCO	<= "01111"+"00001";	-- 15+1 clk's
	when c  =>
		preloadNCO	<= "01111"        ;	-- 15   clk's 
	when d =>
		preloadNCO	<= "01111"-"00001";	-- 15-1 clk's
	when e =>
		preloadNCO	<= "01111"-"00011";	-- 15-3 clk's
	when others =>
		preloadNCO	<= "01111";		-- catch errors
end case;
end process com_Segment_To_Transitie_decoder;

syn_countNCO: process(clk)	-- ------------------------------------Synchroon NCO----------------------------------------------------------------------
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' then
	pres_countNCO <= "00111";		-- synchrone rst, terug naar 7, want we proberen zo dicht mogelijk tot het midden te zitten
    else
	pres_countNCO <= next_countNCO;		-- anders de volgende staat inladen
    end if;
else
end if;
end process syn_countNCO;

com_countNCO: process(pres_countNCO,preloadNCO)
begin
if (pres_countNCO =0) then
	chip_sample_sig	<= '0';
	next_countNCO	<= preloadNCO;
elsif (pres_countNCO =1)then
	chip_sample_sig	<= '1';		-- chip_sample sturen we iets te vroeg door naar de semafoor zodat wanneer pres_countNCO op 0 komt te staan dat we de nieuwste preload hebben
	next_countNCO 	<= pres_countNCO - "00001";
else
	chip_sample_sig	<= '0';
	next_countNCO 	<= pres_countNCO - "00001";
end if;
end process com_countNCO; 
END behav;
