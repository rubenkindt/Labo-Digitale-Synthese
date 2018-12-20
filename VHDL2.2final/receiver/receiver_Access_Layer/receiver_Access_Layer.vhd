-- Made by Ruben Kindt 17/11/2018
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity receiver_AccesLayer is
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	sdi_spread:	in std_logic:='0';
	dips_in:	in std_logic_vector(1 downto 0):="00";
	databit:	out std_logic:='0';
	bit_sample_receiver:	out std_logic:='0'
	);
end receiver_AccesLayer;

architecture behav of receiver_AccesLayer is
    
component correlator
port (
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	rst:		in std_logic:='0';
	chip_sample:	in std_logic:='0';
	bit_sample:	in std_logic:='0';
	sdi_despread:	in std_logic:='0';
	databit:	out std_logic:='0'
	);
end component;

component despreading	-- de fancy xor
port (
	clk:		in std_logic:='0'; 
	clk_en:		in std_logic:='1';
	rst:		in std_logic:='0';
	pn_seq:		in std_logic:='0';
	sdi_spread:	in std_logic:='0';
	chip_sample:	in std_logic:='0';
	xor_despread:	out std_logic:='0'
	);
end component;

component dpll
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	sdi_spread	:IN  std_logic:='0';	-- ingangssignaal, wat hoort de ontvanger
	extb		:OUT std_logic:='0';	-- transitie gedetecteerd
	chip_sample	:OUT std_logic:='0';	-- 'sample maar'-signaal
	chip_sampleD1	:OUT std_logic:='0';
	chip_sampleD2	:OUT std_logic:='0'
	);
end component;

component matchedFilter
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	chip_sample	:IN  std_logic:='0';
	sdi_spread	:IN  std_logic:='0';
	dips_in		:IN  std_logic_vector(1 downto 0):="00";
	seq_det_MFilter	:OUT  std_logic:='0'
	);
end component;

component pngeneratorAndNCO
PORT (	
	clk:      	in std_logic;
	clk_en:   	in std_logic:='1';
 	rst:      	in std_logic:='0';
	chip_sampleD1: 	in std_logic:='0';
	seq_det:	in std_logic:='0';
	bit_sample:	out std_logic:='0';
  	pn1_receiver:	out std_logic:='0';
  	pn2_receiver:	out std_logic:='0';
  	gold_receiver:	out std_logic:='0'
	);
end component;

signal seq_det_sig: 		std_logic:='0';	-- mux: seq_det_mux
signal pn_seq_sig:		std_logic:='0';	-- mux: pn_seq_mux
signal xor_despread: 		std_logic:='0';	-- mux: despread_mux

signal seq_det_MFilter_sig:	std_logic:='0';	-- van matched Filter naar mux: seq_det_mux
signal pn1_receiver_sig:	std_logic:='0';	-- van PN generator and NCO naar mux: pn_seq_mux
signal pn2_receiver_sig:	std_logic:='0';	-- van PN generator and NCO naar mux: pn_seq_mux
signal gold_receiver_sig:	std_logic:='0';	-- van PN generator and NCO naar mux: pn_seq_mux
signal sdi_despread_sig:	std_logic:='0';	-- van despreading naar mux: despread_mux

signal extb_receiver_sig: 	std_logic:='0'; -- van dpll naar pn generator and nco
signal chip_sample_sig:		std_logic:='0';	-- van dpll naar matched Filter
signal chip_sampleD1_sig:	std_logic:='0';	-- van DPLL naar PN generator and NCO
signal chip_sampleD2_sig:	std_logic:='0';	-- van dpll naar Correlator and despreading
signal bit_sample_sig:		std_logic:='0';	-- van PN generator and NCO naar correlator and naar datalink Layer

begin
bit_sample_receiver	<= bit_sample_sig;
    
correlator_1: correlator	---------correlator---------
port map(
	clk 		=> clk,
	clk_en		=> clk_en,	
	rst 		=> rst,
	chip_sample 	=> chip_sampleD2_sig,
	bit_sample 	=> bit_sample_sig,
	sdi_despread 	=> sdi_despread_sig,
	databit 	=> databit
	);

despreading_1: despreading	---------despread---------xor
port map(
	clk       	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	pn_seq 		=> pn_seq_sig,
	sdi_spread 	=> sdi_spread,
	chip_sample 	=> chip_sampleD1_sig,
	xor_despread 	=> xor_despread
	);

dpll_1: dpll			---------dpll---------
port map(
	clk       	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	sdi_spread	=> sdi_spread,
	extb	  	=> extb_receiver_sig,
	chip_sample	=> chip_sample_sig,
	chip_sampleD1	=> chip_sampleD1_sig,
	chip_sampleD2	=> chip_sampleD2_sig
	);

matchedFilter_1: matchedFilter	---------matchedFilter---------
port map(
	clk       	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	chip_sample	=> chip_sample_sig,
	sdi_spread	=> sdi_spread,
	dips_in		=> dips_in,
	seq_det_MFilter	=> seq_det_MFilter_sig
	);

pngeneratorAndNCO_1: pngeneratorAndNCO	---------pngeneratorAndNCO---------
port map(
	clk      	=> clk,
	clk_en    	=> clk_en,
	rst       	=> rst,
	chip_sampleD1	=> chip_sampleD1_sig,
	seq_det		=> seq_det_sig,			-- komt uit de mux
	bit_sample	=> bit_sample_sig,
	pn1_receiver	=> pn1_receiver_sig,
	pn2_receiver	=> pn2_receiver_sig,
	gold_receiver	=> gold_receiver_sig
	);

seq_det_mux: process(dips_in,extb_receiver_sig,seq_det_MFilter_sig)
begin
case dips_in is
	when "00" =>
		seq_det_sig <= extb_receiver_sig;		-- begin van unencrypted
	when others =>
		seq_det_sig <= seq_det_MFilter_sig;		-- begin van pn1,pn2 of gold
end case; 
end process seq_det_mux;

pn_seq_mux: process(dips_in,pn1_receiver_sig,pn2_receiver_sig,gold_receiver_sig)
begin
case dips_in is
	when "00" =>
		pn_seq_sig <= '0';
	when "01" =>
		pn_seq_sig <= pn1_receiver_sig;
	when "10" =>	
		pn_seq_sig <= pn2_receiver_sig;
	when "11" =>
		pn_seq_sig <= gold_receiver_sig;
	when others =>
		pn_seq_sig <= '1';
end case; 
end process pn_seq_mux;

despread_mux: process(dips_in,sdi_spread,xor_despread)
begin
case dips_in is
	when "00" =>
		sdi_despread_sig <= sdi_spread;		-- begin van unencrypted
	when others =>
		sdi_despread_sig <= xor_despread;	-- begin van pn1,pn2 of gold
end case; 
end process despread_mux;
end behav;
