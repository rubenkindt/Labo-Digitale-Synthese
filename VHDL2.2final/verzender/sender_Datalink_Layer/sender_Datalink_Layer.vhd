-- Made by Ruben Kindt 05/11/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalinkLayer is
port (  
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	pn_start:	in std_logic:='0';
	udCounter:	in std_logic_vector(3 downto 0):="0000";
	unencrypted:	out std_logic:='0'
	);
end datalinkLayer;

architecture behav of datalinkLayer is

signal load_toDatareg: 	std_logic:='0';
signal shift_toDatareg: std_logic:='0';

component sequenceController
port (	
	clk:      in std_logic;
	clk_en:   in std_logic:='1';
 	rst:      in std_logic:='0';
  	pn_start: in std_logic:='0';
  	shift:    out std_logic:='0';
  	load:     out std_logic:='0'
	);
end component;

component dataregister IS
port(	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	load		:IN  std_logic:='0';
	shift		:IN  std_logic:='0';
	data		:IN  std_logic_vector(3 downto 0):="0000";
	sdo_posenc	:OUT std_logic:='0'
	);
end component;
BEGIN

sequenceController_1: sequenceController	---------sequenceController---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	pn_start=> pn_start,
	load	=> load_toDatareg,	
	shift	=> shift_toDatareg
	);

dataregister_1: dataregister			---------dataregister---------
port map (	
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	shift		=> shift_toDatareg,
	load		=> load_toDatareg,
	data		=> udCounter,
	sdo_posenc	=> unencrypted
	);
end behav;

