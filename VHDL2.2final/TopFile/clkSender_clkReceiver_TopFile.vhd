-- Made by Ruben Kindt 22/11/2018
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity clk_16_TopFile_b is
port(	
	clk:		in std_logic:='0';	-- clk voor sender
	clk16Sneller:	in std_logic:='0';	-- clk voor receiver
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	up_in_b:	in std_logic:='1';	-- drukknop 
	down_in_b:	in std_logic:='1';	-- draaiknop
	syncha_b:	in std_logic:='1';
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_Sender_b:  out std_logic_vector(7 downto 0):=(others =>'0');	-- 7seg LED
	led_out_Receiver_b:out std_logic_vector(7 downto 0):=(others =>'0')
	);
end clk_16_TopFile_b;

architecture behav of clk_16_TopFile_b is

component sender_TopFile_b 
port(	
	clk:		in std_logic:='0';
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	up_in_b:	in std_logic:='1';
	down_in_b:	in std_logic:='1';
	syncha_b:	in std_logic:='1';
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1');
	sdo_spread_out:	out std_logic:='1'
	);
end component;

component receiver_TopFile_b
port(	
	clk:		in std_logic:='0';
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	sdi_spread:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1')
	);
end component;

signal sdo_spread_sig:	std_logic:='0';

-- left side= components signal
			-- right side=topfile signals
begin

sender: sender_TopFile_b			-- alles wordt geinverteerd op Verzender/receiver niveau
port map(
	clk		=> clk,
	rst_b		=> rst_b,
	clk_en		=> clk_en,
	up_in_b		=> up_in_b,
	down_in_b	=> down_in_b,
	dips_in_b	=> dips_in_b,
	syncha_b	=> syncha_b,
	synchb_b	=> synchb_b,
 	led_out_b	=> led_out_Sender_b,
	sdo_spread_out	=> sdo_spread_sig
	);

receiver: receiver_TopFile_b			-- alles wordt geinverteerd op Verzender/receiver niveau
port map(
	clk		=> clk16Sneller,
	rst_b		=> rst_b,
	clk_en		=> clk_en,
	sdi_spread	=> sdo_spread_sig,
	dips_in_b	=> dips_in_b,
	led_out_b	=> led_out_Receiver_b
	);

end behav;
