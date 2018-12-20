-- Made by Ruben Kindt 14/10/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity appLayer is
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	up_in, down_in:	in std_logic:='0';	-- drukknopjes
	syncha, synchb:	in std_logic:='0';	-- draaiknop
	led_out:	out std_logic_vector(7 downto 0):=(others =>'0');	-- 7seg LED
	data_out:	out std_logic_vector(3 downto 0):=(others =>'0')	-- data van udcounter
	);
end appLayer;

architecture behav of appLayer is
    
component debouncer
port (	
	clk,rst:    in std_logic:='0';
	clk_en:     in std_logic:='1';
	knop_a:     in std_logic:='0';  -- asynchroon drukknop, gaat er in
	syn_out:    out std_logic:='0'	-- drukknop synchroon, komt er uit
	);
end component;

component posenc		-- aangepast zodat UD counter er niet in zit, dan kunnen beide draaiknop en de drukknopjes werken
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	syncha		:IN  std_logic:='0';
	synchb		:IN  std_logic:='0';
	draaiKUp	:OUT std_logic:='0';	-- draaiknop zegt: "up"
	draaiKDown	:OUT std_logic:='0'	-- "down"
	);
end component;

component edge
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	syncha		:IN  std_logic:='0';
	edge_pos	:OUT std_logic:='0'	--,
--	edge_neg	:OUT std_logic:='0'
	);
end component;

component udcounter
port (	
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	up, down, rst:	in std_logic:='0';
	count_out: 	out std_logic_vector(3 downto 0):=(others => '0')
	);
end component;

component zevensegdecoder
port(
--	clk:		in  std_logic:='0'; -- puur combinatorisch, geen clk nodig
--	clk_en:		in  std_logic:='1';
--	rst:		in  std_logic:='0'; -- rst overbodig count wordt "0000" na rst synchroon hoog is, dat zorgt voor 0 op 7seg LED
	count:		in  std_logic_vector(3 downto 0):=(others => '0');
	led:	 	out std_logic_vector(7 downto 0):=(others => '0')
	);
end component;

signal channel_A_edge_signal: 	std_logic:='0';	-- channel doorgeven van debouncer naar posenc
signal channel_B_edge_signal: 	std_logic:='0';	-- analoog
signal debounced_up_signal: 	std_logic:='0';	-- debounced up signaal naar de edge
signal debounced_down_signal: 	std_logic:='0';	-- analoog

-- nodig voor het mixen van de 2 up's (van posenc en van edge_up)
signal up_udcounter: 		std_logic:='0';	-- de gemixed,voor naar de udcounter
signal down_udcounter: 		std_logic:='0';	-- analoog
signal up_geFlank_knopje: 	std_logic:='0';	-- van de drukknopjes, 
signal down_geFlank_knopje: 	std_logic:='0';	-- analoog
signal up_geFlank_draaiknop: 	std_logic:='0';	-- van de draaiknop
signal down_geFlank_draaiknop: 	std_logic:='0';	-- analoog

signal data_out_signal:		std_logic_vector(3 downto 0):=(others =>'0');


begin
data_out	<=data_out_signal;
    
debouncer_Up: debouncer	---------UP debouncer---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	knop_a	=> up_in,
	syn_out	=> debounced_up_signal
	);

debouncer_Down: debouncer	---------Down debouncer---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	knop_a	=> down_in,
	syn_out	=> debounced_down_signal
	);

edge_Up: edge		---------UP edge---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	syncha	=> debounced_up_signal,
	edge_pos=> up_geFlank_knopje
	);

edge_Down: edge		---------Down edge---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	syncha	=> debounced_down_signal,
	edge_pos=> down_geFlank_knopje
	);

debouncer_A: debouncer	---------Channel A debouncer---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	knop_a	=> syncha,
	syn_out	=> channel_A_edge_signal
	);

debouncer_B: debouncer	---------Channel B debouncer---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	knop_a	=> synchB,
	syn_out	=> channel_B_edge_signal
	);

posenc_1: posenc		---------position encoder---------
port map(
	clk       => clk,
	clk_en    => clk_en,
	rst       => rst,
	syncha    => channel_A_edge_signal,
	synchb    => channel_B_edge_signal,
	draaiKUp  => up_geFlank_draaiknop,
	draaiKDown => down_geFlank_draaiknop
	);

zevensegdecoder_inst: zevensegdecoder
port map(
	count 	=> data_out_signal,
	led	=> led_out
	);

udcounter_inst: udcounter
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	up	=> up_udcounter,
	down	=> down_udcounter,
	count_out=>data_out_signal
	);

mixen:process(up_geFlank_draaiknop,down_geFlank_draaiknop,up_geFlank_knopje,down_geFlank_knopje)
begin
if (up_geFlank_knopje='1' or up_geFlank_draaiknop='1') then		-- combineerd UP's
	up_udcounter	<='1';
else 	up_udcounter	<='0';
end if;

if (down_geFlank_knopje='1' or down_geFlank_draaiknop='1') then		-- combineerd DOWN's
	down_udcounter	<='1';
else 	down_udcounter	<='0';
end if;
end process mixen;
end behav;