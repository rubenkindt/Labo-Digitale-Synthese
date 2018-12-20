-- Made by Ruben Kindt 07/11/2018
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity senderMetCklDiv_b is
port(	
	clk_100mhz:	in std_logic:='0';
	rst_b:		in std_logic:='1';
	up_in_b:	in std_logic:='1';
	down_in_b:	in std_logic:='1';
	syncha_b:	in std_logic:='1';
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1');
	sdo_spread_out:	out std_logic:='1'		-- de data om te versturen
	);
end senderMetCklDiv_b;

architecture behav of senderMetCklDiv_b is

component sender_TopFile_b 
port (
	clk:			in std_logic:='0';
	clk_en:			in std_logic:='1';
	rst_b:			in std_logic:='1';
	up_in_b:		in std_logic:='1';
	down_in_b:		in std_logic:='1';
	syncha_b:		in std_logic:='1';
	synchb_b:		in std_logic:='1';
	dips_in_b:		in std_logic_vector(1 downto 0):="11";
 	led_out_b:		out std_logic_vector(7 downto 0):=(others =>'1');
	sdo_spread_out:		out std_logic:='1'		-- de data om te versturen
	);
end component;

component clkdiv
port (
	divClk:		IN  std_logic:='0';
	divClk_en:	OUT  std_logic:='0'
	);
end component;

signal clk_en_sig:		std_logic:='1';

-- left side= components signal
-- right side=topfile signals
begin

sender_TopFile_1: sender_TopFile_b
port map(
	clk		=> clk_100mhz,
	clk_en		=> clk_en_sig,
	rst_b		=> rst_b,
	up_in_b		=> up_in_b,
	down_in_b	=> down_in_b,
	syncha_b	=> syncha_b,
	synchb_b	=> synchb_b,
	dips_in_b	=> dips_in_b,
	led_out_b	=> led_out_b,
	sdo_spread_out	=> sdo_spread_out
	);

clkdiv_1: clkdiv 
port map(
	divClk		=> clk_100mhz,
	divClk_en	=> clk_en_sig
	);
end behav;
