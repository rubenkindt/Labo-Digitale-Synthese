-- Made by Ruben Kindt 22/10/2018
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity accesLayer_tb is
end;

architecture bench of accesLayer_tb is
component accesLayer
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	information:	in std_logic:='0';
	dips_in:	in std_logic_vector(1 downto 0):="00";
	sdo_spread_out:	out std_logic:='0';
	pn_start:	out std_logic:='0'
	);

end component;
constant period: 	time := 100 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal clk,rst:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal information:	std_logic:='0';
signal dips_in:		std_logic_vector(1 downto 0):="00";
signal sdo_spread_out:	std_logic:='0';
signal pn_start:	std_logic:='0';

begin
uut: accesLayer 
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst,
	information	=> information,
	dips_in		=> dips_in,
	sdo_spread_out	=> sdo_spread_out,
	pn_start	=> pn_start
	);

  clock : process
   begin 
       clk <= '0';
       wait for period/2;
     loop
       clk <= '0';
       wait for period/2;
       clk <= '1';
       wait for period/2;
       exit when end_of_sim;
     end loop;
     wait;
   end process clock;
  
tb : PROCESS 
BEGIN
clk_en    	<='1';
rst			<='0';
dips_in		<="00";
----------------------info op 0----------
information	<='0';
wait for delay; --insert delay 10 ns
wait for period;
-----------dips on 00----------
dips_in		<="00";

FOR ii IN 0 TO 20 LOOP
	wait for period;	
END LOOP;


FOR ii IN 0 TO 30 LOOP
	information	<= '1';		-- anders zie je hier niet veel gebeuren 
	wait for period;
	wait for period;
	information	<= '0';
	wait for period;
	wait for period;	
END LOOP;

-----------dips on 01----------
dips_in		<="01";
FOR ii IN 0 TO 50 LOOP
	wait for period;
END LOOP;

-----------dips on 10----------
dips_in		<="10";
FOR ii IN 0 TO 50 LOOP
	wait for period;
END LOOP;

-----------dips on 11----------
dips_in		<="11";
FOR ii IN 0 TO 50 LOOP
	wait for period;
END LOOP;
----------------------info op 1----------
information	<='1';
-----------dips on 00----------
dips_in		<="00";
FOR ii IN 0 TO 20 LOOP
	wait for period;	
END LOOP;

FOR ii IN 0 TO 30 LOOP
	information	<= '0';		-- anders zie je hier niet veel gebeuren, dat is saai
	wait for period;
	wait for period;
	information	<= '1';
	wait for period;
	wait for period;	
END LOOP;

-----------dips on 01----------
dips_in		<="01";
FOR ii IN 0 TO 50 LOOP
	wait for period;
END LOOP;

-----------dips on 10----------
dips_in		<="10";
FOR ii IN 0 TO 50 LOOP
	wait for period;
END LOOP;

-----------dips on 11----------
dips_in		<="11";
FOR ii IN 0 TO 50 LOOP
	WAIT FOR period;
END LOOP;

-----------RST TEST------------
rst		<='1';
Wait for period;
Wait for period;
FOR J IN 0 TO 20 loop 
	WAIT FOR period;
END LOOP;
rst	<='0';
Wait for period;

---- hier pesten we de software -----------Mux = XX------------
--dips_in		<="XX";		-- manueel dips_in op don't know zetten, om te testen wat het gaat doen
--Wait for period;
--Wait for period;
--FOR J IN 0 TO 20 loop 
--	WAIT FOR period;
--END LOOP;
--dips_in		<="00";
Wait for period;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;

