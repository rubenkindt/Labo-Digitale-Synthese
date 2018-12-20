-- Made by Ruben Kindt 07/11/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sender_TopFile_b is
port(	
	clk:		in std_logic:='0';
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	up_in_b:	in std_logic:='1';	-- drukknop
	down_in_b:	in std_logic:='1';	
	syncha_b:	in std_logic:='1';	-- draaiknop
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1');	--7 seg LED
	sdo_spread_out:	out std_logic:='1'		-- de data om te versturen
	);
end sender_TopFile_b;

architecture behav of sender_TopFile_b is

component appLayer 
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	up_in, down_in:	in std_logic:='0';	-- druk
	syncha, synchb:	in std_logic:='0';	-- draai
	led_out:	out std_logic_vector(7 downto 0):=(others =>'0');	-- 7seg LED
	data_out:	out std_logic_vector(3 downto 0):=(others =>'0') 	-- data van udcounter
	);
end component;

component datalinkLayer
port (  
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	pn_start:	in std_logic:='0';
	udCounter:	in std_logic_vector(3 downto 0):="0000";
	unencrypted:	out std_logic:='0'		-- data van het dataregister om te encrypteren en te verzenden
	);
end component;

component accesLayer
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	information:	in std_logic:='0';		-- unencrypted van datalink
	dips_in:	in std_logic_vector(1 downto 0):="00";
	sdo_spread_out:	out std_logic:='0';
	pn_start:	out std_logic:='0'
	);
end component;

signal udCounterToDatalink:	std_logic_vector(3 downto 0):="0000";
signal pn_startToDatalink:	std_logic:='0';
signal unencryptedToAcces:	std_logic:='0';
signal rst_sig:			std_logic:='1';
signal up_in_sig:		std_logic:='1';
signal down_in_sig:		std_logic:='1';
signal A_sig:			std_logic:='1';	-- niet _b, actief laag meer 
signal B_sig:			std_logic:='1';

signal dips_in_sig:		std_logic_vector(1 downto 0):="00";
signal sdo_spread_out_sig:	std_logic:='1';

begin
rst_sig		<=not(rst_b);	-- actief laag naar actief hoog
up_in_sig	<=not(up_in_b);
down_in_sig	<=not(down_in_b);
A_sig		<=not(syncha_b);
B_sig		<=not(synchb_b);
dips_in_sig	<=not(dips_in_b);
sdo_spread_out	<=sdo_spread_out_sig;	-- te versturen data gaan we actief hoog houden
					-- de 7 seg LED is al actief laag geschreven

-- left side= components signal
-- right side=topfile signals
appLayer1: appLayer
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst_sig,
	up_in		=> up_in_sig,		-- drukknop
	down_in		=> down_in_sig,
	syncha		=> A_sig,		-- draai knop
	synchb		=> B_sig,
	led_out		=> led_out_b,		-- was al actief laag geschreven
	data_out	=> udCounterToDatalink	-- waarde van udCounter
	);


datalinkLayer1: datalinkLayer 
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst_sig,
	pn_start	=> pn_startToDatalink,	-- komt van access layer
	udCounter	=> udCounterToDatalink,	-- komt van app layer
	unencrypted	=> unencryptedToAcces	-- output van dataregister
	);

accesLayer1: accesLayer 
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst_sig,
	information	=> unencryptedToAcces,	-- te versleutelen info, komt van datalink
	dips_in		=> dips_in_sig,
	sdo_spread_out	=> sdo_spread_out_sig,	-- de (versleutelde) data
	pn_start	=> pn_startToDatalink	
	);

end behav;
