-- Made by Ruben Kindt 21/11/2018
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity receiverMetClkDiv_b is
port(	
	clk_100mhz :	in std_logic:='0';
	rst_b:		in std_logic:='1';
	sdi_spread:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1')	-- 7seg LED
	);
end receiverMetClkDiv_b;

architecture behav of receiverMetClkDiv_b is

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

component clkdiv
PORT(
	divClk:		IN  std_logic:='0';
	divClk_en:	OUT  std_logic:='0'
	);
END component;

signal clk_en_sig 	:std_logic:='0';
begin

clkdiv_1: clkdiv 
port map(
	divClk		=> clk_100mhz,
	divClk_en	=> clk_en_sig
	);

receiver_TopFile_b_1: receiver_TopFile_b
port map(
	clk			=> clk_100mhz,
	clk_en			=> clk_en_sig,
	rst_b			=> rst_b,
	sdi_spread		=> sdi_spread,
	dips_in_b		=> dips_in_b,
	led_out_b		=> led_out_b
	);
end behav;
