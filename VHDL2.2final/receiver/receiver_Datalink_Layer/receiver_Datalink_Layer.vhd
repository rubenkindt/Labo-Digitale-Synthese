-- Made by Ruben Kindt 20/11/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity receiver_datalinkLayer is
port (  
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	databit:	in std_logic:='0';
	bit_sample:	in std_logic:='0';
	data_datalink:	out std_logic_vector(0 to 10):=(others=>'0')
	);
end receiver_datalinkLayer;

architecture behav of receiver_datalinkLayer is

component dataShiftRegister IS
port(
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	databit		:IN  std_logic:='0';
	bit_sample	:IN  std_logic:='0';
	data_datalink	:OUT  std_logic_vector(0 to 10):=(others=>'0')
	);
end component;
BEGIN

dataShiftRegister_1: dataShiftRegister			---------dataregister---------
port map (	
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	databit		=> databit,
	bit_sample	=> bit_sample,
	data_datalink	=> data_datalink
	);
end behav;

