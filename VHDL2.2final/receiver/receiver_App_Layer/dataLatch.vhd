-- Made By Ruben Kindt	20/11/2018
-- data Latch to check if the data given from the datalink layer contains the preamble, if so the latch gives the 'latch' to the 7seg. decoder
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dataLatch IS
PORT (
	clk		:in std_logic:='0';
	clk_en		:in std_logic:='1';
	rst		:in std_logic:='0';
	bit_sample	:IN  std_logic:='0';
	data		:IN  std_logic_vector(0 to 10):=(others=>'0');
	latch_data	:OUT std_logic_vector(0 to 3):="0000"
	);
END;

ARCHITECTURE behav OF dataLatch IS
CONSTANT ctePreamble			:std_logic_vector(0 to 6):="0111110";
signal preabmle 			:std_logic_vector(0 to 6):="0000000";
signal latch	 			:std_logic_vector(0 to 3):="0000";
signal pre_latch,nxt_latch		:std_logic_vector(0 to 3):="0000";

BEGIN
preabmle	<=data(0 to 6);
latch		<=data(7 to 10);

latch_data	<=pre_latch;

latch_proccess_syn:process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1' then
		pre_latch	<= "0000";		
    else
	 if bit_sample ='1' and preabmle=ctePreamble  then
		pre_latch 	<= nxt_latch;
	else
	end if;
    end if;
else
end if;
end process latch_proccess_syn;

latch_proccess: Process(pre_latch,latch)
BEGIN
nxt_latch	<= latch;
END PROCESS latch_proccess;
END behav;