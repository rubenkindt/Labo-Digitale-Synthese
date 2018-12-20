-- Made by Ruben Kindt 22/11/2018
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity clk_16_TopFile_b_tb is
end;

architecture bench of clk_16_TopFile_b_tb is
component clk_16_TopFile_b
port (
	clk:		in std_logic:='0';	-- clk voor sender
	clk16Sneller:	in std_logic:='0';	-- clk voor receiver
	rst_b:		in std_logic:='1';
	clk_en:		in std_logic:='1';
	up_in_b:	in std_logic:='1';	-- drukknop 
	down_in_b:	in std_logic:='1';
	syncha_b:	in std_logic:='1';	-- draaiknop
	synchb_b:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_Sender_b:  out std_logic_vector(7 downto 0):=(others =>'0');	-- 7seg LED
	led_out_Receiver_b:out std_logic_vector(7 downto 0):=(others =>'0')
	);
end component;
constant period: 	time := 100 ns;		-- receiver 	periode
constant period16Langer:time := 16*100 ns;	-- sender 	periode
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal	clk:		std_logic:='0';
signal	clk16Sneller:	std_logic:='0';
signal	rst_b:		std_logic:='1';
signal	clk_en:		std_logic:='1';
signal	up_in_b:	std_logic:='1';
signal	down_in_b:	std_logic:='1';
signal	syncha_b:	std_logic:='1';
signal	synchb_b:	std_logic:='1';
signal	dips_in_b:	std_logic_vector(1 downto 0):="11";
signal	led_out_Sender:	std_logic_vector(7 downto 0):=(others =>'0');
signal	led_out_Receiver:std_logic_vector(7 downto 0):=(others =>'0');

begin 
uut: clk_16_TopFile_b
port map(
	clk		=> clk,
	clk16Sneller	=> clk16Sneller,
	rst_b		=> rst_b,
	clk_en		=> clk_en,
	up_in_b		=> up_in_b,
	down_in_b	=> down_in_b,
	dips_in_b	=> dips_in_b,
	syncha_b	=> syncha_b,
	synchb_b	=> synchb_b,
 	led_out_Sender_b=> led_out_Sender,
	led_out_Receiver_b=> led_out_Receiver	
	);

clock16: process
begin 
clk16Sneller <= '0';
wait for period/2;
loop
	clk16Sneller <= '0';
	wait for period/2;
	clk16Sneller <= '1';
	wait for period/2;
 	exit when end_of_sim;
end loop;
wait;
end process clock16;

clock : process
begin 
clk <= '0';
wait for period16Langer/2;
loop
	clk <= '0';
	wait for period16Langer/2;
	clk <= '1';
	wait for period16Langer/2;
 	exit when end_of_sim;
end loop;
wait;
end process clock;


tb : PROCESS 
BEGIN
clk_en    	<='1';
rst_b		<=not('0');
up_in_b		<=not('0');
down_in_b	<=not('0');
dips_in_b	<=not("00");
wait for delay; --insert delay 10 ns
wait for period16Langer;
-----------waarde op 3 zetten-----------	-- unencrypted
dips_in_b	<=not("00");	

FOR ii IN 0 TO 2 LOOP
	up_in_b		<=not('1');
	FOR J IN 0 TO 9 loop			-- minimum 4 waits anders ziet hij een bounce 
		WAIT FOR period16Langer;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 9 loop			-- minimum 4 waits anders ziet hij een bounce 
		WAIT FOR period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop		-- even stabiel houden
	WAIT FOR period16Langer;
END LOOP;
-----------waarde op 6 zetten-----------	-- pn1
dips_in_b	<=not("01");

FOR ii IN 0 TO 1 LOOP	-- stond op 4
	up_in_b		<=not('1');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop		-- even stabiel houden
	WAIT FOR period16Langer;
END LOOP;
-----------waarde op 10 zetten-----------	-- pn2
dips_in_b	<=not("10");

FOR ii IN 0 TO 3 LOOP	-- stond op 6
	up_in_b		<=not('1');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------waarde op 15 zetten-----------	-- gold
dips_in_b	<=not("11");

FOR ii IN 0 TO 4 LOOP	-- stond op 10
	up_in_b		<=not('1');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 9 loop
		WAIT FOR period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------Overflow: van F naar 0-----------	-- unencrypted
dips_in_b	<=not("00");

up_in_b		<=not('1');
FOR J IN 0 TO 9 loop	
	WAIT FOR period16Langer;
END LOOP;
up_in_b		<=not('0');
FOR J IN 0 TO 9 loop
	WAIT FOR period16Langer;
END LOOP;


FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------rst Test----------
rst_b	<=not('1');		-- minimum 4 waits anders ziet hij een bounce 

FOR J IN 1 TO 500 loop
	WAIT FOR period16Langer;
END LOOP;
rst_b	<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------Underflow: van 0 naar 15-----------	-- gold
dips_in_b	<=not("11");

down_in_b	<=not('1');
FOR J IN 0 TO 9 loop			-- minimum 4 waits anders ziet hij een bounce 
	WAIT FOR period16Langer;
END LOOP;
down_in_b		<=not('0');
FOR J IN 0 TO 9 loop
	WAIT FOR period16Langer;
END LOOP;

FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------Test '1' BOUNCE----------
dips_in_b	<=not("00");
up_in_b		<=not('1');
WAIT FOR period16Langer;
WAIT FOR period16Langer;
up_in_b		<=not('0');
WAIT FOR period16Langer;
up_in_b		<=not('1');
Wait for period16Langer;
Wait for period16Langer;
Wait for period16Langer;
up_in_b		<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------Test '0' BOUNCE----------
down_in_b		<=not('1');
WAIT FOR period16Langer;
WAIT FOR period16Langer;
down_in_b		<=not('0');
WAIT FOR period16Langer;
Wait for period16Langer;
down_in_b		<=not('1');
Wait for period16Langer;
Wait for period16Langer;
Wait for period16Langer;
down_in_b		<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;


-----------RST TEST UP normaal tijdens debounce en tijdens count!=0000------------
rst_b	<=not('0');
up_in_b	<=not('1');
Wait for period16Langer;
Wait for period16Langer;
rst_b	<=not('1');			-- proberen +1, mislukt door rst
FOR J IN 0 TO 6 loop 
	Wait for period16Langer;
END LOOP;
rst_b	<=not('0');			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	Wait for period16Langer;	-- volgende rst test willen we niet op 0000 beginnen, daarom +1
END LOOP;
up_in_b	<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------RST TEST DOWN normaal tijdens debounce en tijdens count!=0000------------
up_in_b		<=not('1');	-- count !=0000
FOR J IN 0 TO 9 loop	
	WAIT FOR period16Langer;
END LOOP;
up_in_b		<=not('0');
FOR J IN 0 TO 9 loop
	WAIT FOR period16Langer;
END LOOP;

rst_b	<=not('0');
down_in_b	<=not('1');
Wait for period16Langer;
Wait for period16Langer;
rst_b	<=not('1');			-- eerst proberen we -1 te doen, door rst mislukt dit
FOR J IN 0 TO 6 loop 
	Wait for period16Langer;
END LOOP;
rst_b	<=not('0');			-- hier staan we op 0000

FOR J IN 0 TO 6 loop 
	Wait for period16Langer;	-- hier  springen we op 1111 omdat we niet op 0000 beginnen
END LOOP;
down_in_b	<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------RST TEST tijdens shift UP------------
rst_b	<=not('0');
up_in_b	<=not('1');
Wait for period16Langer;
Wait for period16Langer;
Wait for period16Langer;
rst_b	<=not('1');
Wait for period16Langer;	-- hier gebeurd normaal een shift (moest er geen rst staan)
up_in_b	<=not('0');

Wait for period16Langer;
rst_b	<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------RST TEST tijdens shift DOWN------------
rst_b	<=not('0');
down_in_b	<=not('1');
Wait for period16Langer;
Wait for period16Langer;
Wait for period16Langer;
rst_b	<=not('1');
Wait for period16Langer;	-- hier gebeurd normaal een shift (moest er geen rst staan)
down_in_b	<=not('0');

Wait for period16Langer;
rst_b	<=not('0');
FOR J IN 1 TO 5000 loop
	WAIT FOR period16Langer;
END LOOP;


--------------------------------------------------------------------------------------------DRAAIKNOPJE--------------------------------------------------------------------DRAAIKNOPJE--------------------------DRAAIKNOPJE--------------------------
-----------met de klok mee draaien------------
dips_in_b		<=not("00");
FOR ii IN 0 TO 22 LOOP	-- 22 = zonder betekenis, met oververflow
	Wait for period16Langer;
	Wait for period16Langer;	-- waarom 2 periods ?, wel het duurt 1 clk voor de edge om de pos (actief hoog) flank te vinden van b
	syncha_b	<=not('1');	-- en pas na de edge kijken we naar A om de (zin) de UP of DOWN te bepalen, dus mogen we A niet te snel aanpassen
	Wait for period16Langer;
	Wait for period16Langer;
	synchb_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		Wait for period16Langer;
	END LOOP;
	syncha_b	<=not('0');
	Wait for period16Langer;
	Wait for period16Langer;
	synchb_b	<=not('0');
	FOR J IN 0 TO 5 loop
		Wait for period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------TEGEN de klok mee draaien------------
dips_in_b		<=not("00");			-- met encryptie
FOR ii IN 0 TO 20 LOOP	-- 21>16 => underflow
	Wait for period16Langer;
	Wait for period16Langer;
	synchb_b	<=not('1');
	Wait for period16Langer;
	Wait for period16Langer;
	syncha_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		Wait for period16Langer;
	END LOOP;
	synchb_b	<=not('0');
	Wait for period16Langer;
	Wait for period16Langer;
	syncha_b	<=not('0');
	FOR J IN 0 TO 5 loop
		Wait for period16Langer;
	END LOOP;
END LOOP;

FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
-----------RST TEST tijdens shift DOWN------------
rst_b		<=not('0');
syncha_b	<=not('1');
Wait for period16Langer;
Wait for period16Langer;
synchb_b	<=not('1');
rst_b	<=not('1');
FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
	Wait for period16Langer;
END LOOP;
syncha_b	<=not('0');
Wait for period16Langer;
Wait for period16Langer;
synchb_b	<=not('0');
FOR J IN 0 TO 5 loop
	Wait for period16Langer;
END LOOP;	-- hier gebeurd normaal een shift (moest er geen rst staan)
rst_b		<=not('0');
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
--------------------------------------------------------------------------------------------DRAAIKNOPJE EN drukKNOPJES--------------------------------------------------------------------DRAAIKNOPJE--------------------------EN KNOPJES--------------------------
------------UP langs beide kanten (knopjes en draaiknop)---------- ziet er ingewikkeld uit maar dat is om ze exact op dezelfde clk "+1" te laten doen
dips_in_b		<=not("00");
FOR ii IN 0 TO 4 LOOP		-- lust maar 5 keer, en udcounter telt 5 keer  
	syncha_b	<=not('1');
	Wait for period16Langer;
	Wait for period16Langer;
	synchb_b	<=not('1');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		Wait for period16Langer;
	END LOOP;
	syncha_b	<=not('0');
	Wait for period16Langer;
	Wait for period16Langer;
	up_in_b		<=not('1');
	synchb_b	<=not('0');
	FOR J IN 0 TO 5 loop			-- minimum 4 waits anders geen shift 
		Wait for period16Langer;
	END LOOP;
	up_in_b		<=not('0');
	FOR J IN 0 TO 5 loop
		Wait for period16Langer;
	END LOOP;
END LOOP;
FOR J IN 1 TO 1000 loop
	WAIT FOR period16Langer;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;