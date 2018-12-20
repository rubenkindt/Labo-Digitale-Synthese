-- Made by Ruben Kindt 22/10/2018
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity sender_TopFile_b_tb is
end;

architecture bench of sender_TopFile_b_tb is
component sender_TopFile_b
port(	
	clk:		in std_logic:='0';
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	up_in_b:	in std_logic:='1';
	down_in_b:	in std_logic:='1';
	syncha_b:	in std_logic:='1';
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1');
	sdo_spread_out:	out std_logic:='1'		-- de data om te versturen
	);
end component;
constant period: 	time := 100 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal clk:		std_logic:='0';
signal clk_en:		std_logic:='1';
signal led_out_b:	std_logic_vector(7 downto 0):=(others =>'0');
signal rst_b:		std_logic:='1';
signal up_in_b:		std_logic:='1';
signal down_in_b:	std_logic:='1';
signal syncha_b:	std_logic:='1';	-- channal A actief laag
signal synchb_b:	std_logic:='1';	-- analoog
signal dips_in_b:	std_logic_vector(1 downto 0):="00";
signal sdo_spread_out:	std_logic:='1';

begin 
uut: sender_TopFile_b
port map(
	clk		=> clk,
	rst_b		=> rst_b,
	clk_en		=> clk_en,
	up_in_b		=> up_in_b,
	down_in_b	=> down_in_b,
	dips_in_b	=> dips_in_b,
	syncha_b	=> syncha_b,
	synchb_b	=> synchb_b,
 	led_out_b	=> led_out_b,
	sdo_spread_out	=> sdo_spread_out	
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


tb : PROCESS	-- ------------ eerst met de knopjes daarna met het draaiknopje
BEGIN
clk_en    	<='1';
rst_b		<=not('1');
wait for period;
wait for period;
wait for period;
wait for period;
wait for period;
wait for period;
wait for period;
rst_b		<=not('0');
syncha_b	<=not('0');
synchb_b	<=not('0');
up_in_b		<=not('0');
down_in_b		<=not('0');
dips_in_b		<=not("00");		-- unencrypted
wait for delay; --insert delay 10 ns
wait for period;

-----------Test up UP normaal optellen dips 00---------- er zit overflow in
FOR ii IN 0 TO 20 LOOP
	up_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test UP normaal met dips 01----------
dips_in_b		<=not("01");
FOR ii IN 0 TO 20 LOOP
	up_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test UP normaal met dips 10----------
dips_in_b		<=not("10");
FOR ii IN 0 TO 20 LOOP
	up_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test UP normaal met dips 11----------
dips_in_b		<=not("11");
FOR ii IN 0 TO 20 LOOP
	up_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;

-----------Test DOWN normaal aftellen met underflow----------
FOR ii IN 0 TO 25 LOOP			-- 25 want ik wil niet terug op 0000 eindigen
	down_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test up DOWN normaal optellen dips 00---------- er zit overflow in
FOR ii IN 0 TO 20 LOOP
	down_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test down normaal met dips 01----------
dips_in_b		<=not("01");
FOR ii IN 0 TO 20 LOOP
	down_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test down normaal met dips 10----------
dips_in_b		<=not("10");
FOR ii IN 0 TO 20 LOOP
	down_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test down normaal met dips 11----------
dips_in_b		<=not("11");
FOR ii IN 0 TO 20 LOOP
	down_in_b		<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	down_in_b		<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test UP BOUNCE----------
up_in_b		<=not('1');
WAIT FOR period;
WAIT FOR period;
up_in_b		<='0';
WAIT FOR period;
up_in_b		<=not('1');
Wait for period;
Wait for period;
Wait for period;
up_in_b		<=not('0');
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Test DOWN BOUNCE----------
down_in_b		<=not('1');
WAIT FOR period;
WAIT FOR period;
down_in_b		<=not('0');
WAIT FOR period;
Wait for period;
down_in_b		<=not('1');
Wait for period;
Wait for period;
Wait for period;
down_in_b		<=not('0');
FOR J IN 0 TO 50 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST UP normaal tijdens debounce en tijdens count!=0000------------
rst_b	<=not('0');
up_in_b	<=not('1');
Wait for period;
Wait for period;
rst_b	<=not('1');			-- proberen +1, mislukt door rst
FOR J IN 0 TO 6 loop 
	WAIT FOR period;
END LOOP;
rst_b	<=not('0');			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	WAIT FOR period;	-- volgende rst test willen we niet op 0000 beginnen, daarom +1
END LOOP;
up_in_b	<=not('0');
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST DOWN normaal tijdens debounce en tijdens count!=0000------------
rst_b	<=not('0');
down_in_b	<=not('1');
Wait for period;
Wait for period;
rst_b	<=not('1');			-- eerst proberen we -1 te doen, door rst mislukt dit
FOR J IN 0 TO 6 loop 
	WAIT FOR period;
END LOOP;
rst_b	<=not('0');			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	WAIT FOR period;	-- hier  springen we op 1111 omdat we niet op 0000 beginnen
END LOOP;
down_in_b	<=not('0');
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift UP------------
rst_b	<=not('0');
up_in_b	<=not('1');
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst_b	<=not('1');
WAIT FOR period;	-- hier gebeurd normaal een shift (moest er geen rst staan)
up_in_b	<=not('0');

WAIT FOR period;
rst_b	<=not('0');
FOR J IN 0 TO 100 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift DOWN------------
rst_b	<=not('0');
down_in_b	<=not('1');
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst_b	<=not('1');
WAIT FOR period;	-- hier gebeurd normaal een shift (moest er geen rst staan)
down_in_b	<=not('0');

WAIT FOR period;
rst_b	<=not('0');
FOR J IN 0 TO 50 loop	-- even stabiel houden
	WAIT FOR period;
END LOOP;
--------------------------------------------------------------------------------------------DRAAIKNOPJE--------------------------------------------------------------------DRAAIKNOPJE--------------------------DRAAIKNOPJE--------------------------
-----------Waarschijnlijk met de klok mee draaien------------
dips_in_b		<=not("00");
FOR ii IN 0 TO 22 LOOP	-- 22 = zonder betekenis, met oververflow
	WAIT FOR period;
	syncha_b	<=not('1');
	WAIT FOR period;
	synchb_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	syncha_b	<=not('0');
	WAIT FOR period;
	synchb_b	<=not('0');
	FOR J IN 0 TO 5 loop
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------Waarschijnlijk TEGEN de klok mee draaien------------
dips_in_b		<=not("11");			-- met encryptie
FOR ii IN 0 TO 20 LOOP	-- 21>16 => underflow
	WAIT FOR period;
	synchb_b	<=not('1');
	WAIT FOR period;
	syncha_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	synchb_b	<=not('0');
	WAIT FOR period;
	syncha_b	<=not('0');
	FOR J IN 0 TO 5 loop
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
-----------RST TEST tijdens shift DOWN------------
rst_b		<=not('0');
syncha_b	<=not('1');
WAIT FOR period;
synchb_b	<=not('1');
rst_b	<=not('1');

FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
	WAIT FOR period;
END LOOP;
syncha_b	<=not('0');
WAIT FOR period;
synchb_b	<=not('0');
FOR J IN 0 TO 5 loop
	WAIT FOR period;
END LOOP;	-- hier gebeurd normaal een shift (moest er geen rst staan)
rst_b		<=not('0');


FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
--------------------------------------------------------------------------------------------DRAAIKNOPJE EN drukKNOPJES--------------------------------------------------------------------DRAAIKNOPJE--------------------------EN KNOPJES--------------------------
------------UP langs beide kanten (knopjes en draaiknop)---------- ziet er ingewikkeld uit maar dat is om ze exact op dezelfde clk +1 te laten doen
dips_in_b		<=not("00");
FOR ii IN 0 TO 4 LOOP		-- lust maar 5 keer, en udcounter telt 5 keer  
	syncha_b	<=not('1');
	WAIT FOR period;
	synchb_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	syncha_b	<=not('0');
	up_in_b		<=not('1');
	WAIT FOR period;
	synchb_b	<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		WAIT FOR period;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR J IN 0 TO 1000 loop		-- even stabiel houden
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;