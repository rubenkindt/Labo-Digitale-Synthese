-- Made by Ruben Kindt 14/10/2018

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity appLayer_tb is
end;

architecture bench of appLayer_tb is
component appLayer
port (
	clk,rst:	in std_logic:='0';
	clk_en:		in std_logic:='1';
	up_in, down_in:	in std_logic:='0';
	syncha, synchb:	in std_logic:='0';
	led_out:	out std_logic_vector(7 downto 0):=(others =>'0');
	data_out:	out std_logic_vector(3 downto 0):=(others =>'0')	-- data van udcounter
	);
end component;
constant period: 	time := 100 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	 boolean := false;

signal clk,rst:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal up_in, down_in:	std_logic:='0';
signal syncha, synchb:	std_logic:='0';
signal led_out:		std_logic_vector(7 downto 0):=(others =>'0');
signal data_out:	std_logic_vector(3 downto 0):=(others =>'0');

begin
uut: appLayer 
port map(
	clk		=> clk,
	clk_en		=> clk_en,
	rst		=> rst,
	up_in		=> up_in,
	down_in		=> down_in,
	syncha		=> syncha,
	synchb		=> synchb,
	led_out		=> led_out,
	data_out	=> data_out
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
rst       	<='0';
up_in		<='0';
down_in		<='0';
syncha    	<='0';
synchb    	<='0';
wait for delay; --insert delay 10 ns 
wait for period;
wait for period;
-----------Test '1' normaal optellen met overflow------------------------------------------NORMALE KNOPJES-----------------------------------------------------
FOR ii IN 0 TO 20 LOOP
	up_in		<='1';
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in		<='0';
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test '0' normaal aftellen met underflow----------
FOR ii IN 0 TO 25 LOOP			-- 25 want ik wil niet terug op 0000 eindigen
	down_in		<='1';
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in		<='0';
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test '1' BOUNCE----------
up_in		<='1';
WAIT FOR period;
WAIT FOR period;
up_in		<='0';
WAIT FOR period;
up_in		<='1';
Wait for period;
Wait for period;
Wait for period;
up_in		<='0';
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test '0' BOUNCE----------
down_in		<='1';
WAIT FOR period;
WAIT FOR period;
down_in		<='0';
WAIT FOR period;
Wait for period;
down_in		<='1';
Wait for period;
Wait for period;
Wait for period;
down_in		<='0';
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST UP normaal tijdens debounce en tijdens count!=0000------------
rst	<='0';
up_in	<='1';
Wait for period;
Wait for period;
rst	<='1';			-- proberen +1, muslukt door rst
FOR J IN 0 TO 6 loop 
	WAIT FOR period;
END LOOP;
rst	<= '0';			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	WAIT FOR period;	-- volgende rst test willen we niet op 0000 beginnen, daarom +1
END LOOP;
up_in	<='0';
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST DOWN normaal tijdens debounce en tijdens count!=0000------------
rst	<='0';
down_in	<='1';
Wait for period;
Wait for period;
rst	<='1';			-- eerst proberen we -1 te doen, door rst mislukt dit
FOR J IN 0 TO 6 loop 
	WAIT FOR period;
END LOOP;
rst	<= '0';			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	WAIT FOR period;	-- hier  springen we op 1111 omdat we niet op 0000 beginnen
END LOOP;
Down_in	<='0';
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift UP------------
rst	<='0';
up_in	<='1';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst	<='1';
WAIT FOR period;	-- hier gebeurd normaal een shift (moest er geen rst staan)
up_in	<='0';

WAIT FOR period;
rst	<='0';
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift DOWN------------
rst	<='0';
down_in	<='1';
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst	<='1';
WAIT FOR period;	-- hier gebeurd normaal een shift (moest er geen rst staan)
down_in	<='0';

WAIT FOR period;
rst	<='0';
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------flank normaal MET de clk mee draaien---------------------------------------DRAAIKNOP-----------------------------------
for i in 0 to 5 loop

	syncha	<='1';
	Wait for period;
	synchb	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	syncha	<='0';
	Wait for period;
	synchb	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-----------hetzelfde maar overflow----------
for i in 0 to 16 loop

	syncha	<='1';
	Wait for period;
	synchb	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	syncha	<='0';
	Wait for period;
	synchb	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-----------flank normaal TEGEN de clk in draaien----------
for i in 0 to 5 loop
	synchb	<='1';
	Wait for period;
	syncha	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	synchb	<='0';
	Wait for period;
	syncha	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
-----------hetzelfde maar onderflow----------
for i in 0 to 16 loop
	synchb	<='1';
	Wait for period;
	syncha	<='1';
	Wait for period;
	Wait for period;
	Wait for period;
	synchb	<='0';
	Wait for period;
	syncha	<='0';
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
	Wait for period;
end loop;
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;

-----------RST met flank normaal (waarschijnlijk TEGEN de clk in draaien)----------
rst	<='1';

Wait for period;
synchb	<='1';
Wait for period;
syncha	<='1';
Wait for period;
Wait for period;
Wait for period;
synchb	<='0';
Wait for period;
syncha	<='0';
Wait for period;

rst	<='0';
FOR J IN 0 TO 10 loop 			
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;
