-- Made by Ruben Kindt 22/10/2018

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accesLayer is
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	information:	in std_logic:='0'; -- de output bit van het dataregister, al dan niet nog te versleutelen
	dips_in:	in std_logic_vector(1 downto 0):="00";
	sdo_spread_out:	out std_logic:='0';	-- het signaal
	pn_start:	out std_logic:='0'	-- true=nieuwe sequentie gezien
	);
end accesLayer;

architecture behav of accesLayer is
    
component pngenerator
port (	
	clk,rst:   	in std_logic:='0';
	clk_en:  	in std_logic:='1';
	pn_start: 	out std_logic:='0';
 	pn1:		out std_logic:='0';
	pn2:		out std_logic:='0';
	gold:		out std_logic:='0'
	);
end component;

signal pn1_xor: 	std_logic:='0';
signal pn2_xor: 	std_logic:='0';
signal gold_xor: 	std_logic:='0';
signal pn1_sig: 	std_logic:='0';
signal pn2_sig: 	std_logic:='0';
signal gold_sig: 	std_logic:='0';


begin

pn1_xor	<= pn1_sig  xor information;	-- versleutelen van de informatie
pn2_xor	<= pn2_sig  xor information;	-- voor bij dips 01,10 en 11
gold_xor<= gold_sig xor information;

pngenerator_1: pngenerator	---------pn_generator---------
port map(
	clk	=> clk,
	clk_en	=> clk_en,
	rst	=> rst,
	pn_start=> pn_start,
	pn1	=> pn1_sig,	-- verbinden van pn1 (is een output) naar het signaal pn1_sig
	pn2	=> pn2_sig,	-- om het signaal te lezen bij (de xor) 
	gold	=> gold_sig
	);

mux: process(dips_in,information,pn1_xor,pn2_xor,gold_xor)	-- encrypter blok
begin
case dips_in is
	when "00" =>
		sdo_spread_out <= information; -- unencrypted
	when "01" =>
		sdo_spread_out <= pn1_xor; -- pn1_xor is de pn1 xor met information
	when "10" =>
		sdo_spread_out <= pn2_xor;
	when "11" =>
		sdo_spread_out <= gold_xor;
	when others =>
		sdo_spread_out <= information;	-- wanneer het niet werkt, doe de 'unencrypted'/ die van "00"
end case; 
end process mux;
end behav;











