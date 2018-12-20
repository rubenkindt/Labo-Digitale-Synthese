-- Made by Ruben Kindt 20/11/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity receiver_AppLayer is
port (  
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	bit_sample:	in std_logic:='0';
	data_datalink:	in std_logic_vector(0 to 10):=(others=>'0');
	led:		out std_logic_vector(0 to 7):=(others=>'1')
	);
end receiver_AppLayer;

architecture behav of receiver_AppLayer is

component dataLatch
PORT (	
	clk		:in std_logic:='0';
	clk_en		:in std_logic:='1';
	rst		:in std_logic:='0';
	bit_sample	:IN  std_logic:='0';
	data		:IN  std_logic_vector(0 to 10):=(others=>'0');
	latch_data	:OUT std_logic_vector(0 to 3):="0000"
	);
end component;

component zevensegDecoderReceiver IS
port (
	zevensegmData:	in  std_logic_vector(3 downto 0):=(others => '0');
	led:	 	out std_logic_vector(7 downto 0):=(others => '0')
	);
end component;

signal latch_data_to_decoder:	std_logic_vector(0 to 3):="0000";

BEGIN
dataLatch_1: dataLatch	---------dataLatch---------
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst,
	bit_sample	=> bit_sample,
	data		=> data_datalink,
	latch_data	=> latch_data_to_decoder
	);

zevensegDecoderReceiver_1: zevensegDecoderReceiver	---------zevensegDecoderReceiver---------
port map (	
	zevensegmData 	=> latch_data_to_decoder,
	led		=> led
	);
end behav;

