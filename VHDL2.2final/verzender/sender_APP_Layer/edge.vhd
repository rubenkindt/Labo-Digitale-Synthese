-- Made By Ruben Kindt	08/10/2018
-- flankdetector
-- later (09/10/2018) aangepast naar een pos flank detector
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY edge IS
PORT (	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	syncha		:IN  std_logic:='0';
	edge_pos	:OUT std_logic:='0'
-- 	edge_neg	:OUT std_logic:='0' -- indien we er een neg flank detectie willen, deze en in 5 andere lijnen "--" weghalen
	);
END;

ARCHITECTURE behav OF edge IS
SIGNAL present_state	:std_logic_vector(1 DOWNTO 0):="00";
SIGNAL next_state	:std_logic_vector(1 DOWNTO 0):="00";

CONSTANT WaitFor1	:std_logic_vector(1 DOWNTO 0):="00";-- inhoud van deze constants is onbelangrijk
CONSTANT WaitFor0	:std_logic_vector(1 DOWNTO 0):="11";-- duid enkel aan in welke state we zijn
CONSTANT Puls1		:std_logic_vector(1 DOWNTO 0):="01";
CONSTANT Puls0		:std_logic_vector(1 DOWNTO 0):="10";	-- ik heb een betere gevonden via TYPE, maar soms moeten we de geschiedenis behouden
								-- TYPE state IS (WaitFor1, WaitFor0, Puls1, Puls0);

BEGIN

synchroon: Process(clk)
BEGIN
If rising_edge(clk) and clk_en='1'
	THEN
	IF (rst = '1') THEN
		present_state <= "00"; 		-- geen pulsen
	ELSE 	present_state <= next_state;	-- anders volgende inladen
	END IF;
ELSE
END IF;
END PROCESS synchroon;

combinatorisch:PROCESS(present_state,syncha)
BEGIN
CASE present_state IS
	WHEN WaitFor1=>		-- wachten tot er een 1 binnen komt
		edge_pos<='0';
--		edge_neg<='0';
		IF (syncha='1') THEN 
			next_state <=Puls1;	-- '1' gezien, naar puls1 gaan
		ELSE 	next_state <=WaitFor1;	-- niets gevonden, verder wachten op '1'
		END IF;	
	WHEN Puls1=>		-- Pos puls genereren, dan op '0' wachten
		edge_pos<='1';
--		edge_neg<='0';
		next_state <= WaitFor0;			-- we staan op 1, nu wachten we op '0'
	WHEN WaitFor0=>		-- wachten tot er een 0 binnen komt
		edge_pos<='0';
--		edge_neg<='0';
		IF (syncha='0') THEN
			next_state <=Puls0;	-- '0' gezien naar puls0 gaan
		ELSE	next_state <=WaitFor0;	-- niets gevonden, verder zoeken achter '0'
		END IF;
	WHEN Puls0 =>		-- Neg puls genereren, dan op '1' wachten
		edge_pos<='0';
--		edge_neg<='1';
		next_state <= WaitFor1;
	WHEN OTHERS=>
		edge_pos<='0';
--		edge_neg<='0';
		next_state <=WaitFor1;
END CASE;
END PROCESS combinatorisch;
END behav;