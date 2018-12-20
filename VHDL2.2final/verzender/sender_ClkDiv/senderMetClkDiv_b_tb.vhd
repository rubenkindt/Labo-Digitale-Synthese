-- Made by Ruben Kindt 22/10/2018
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity senderMetCklDiv_b_tb is
end;

architecture bench of senderMetCklDiv_b_tb is
component senderMetCklDiv_b
port(	
	clk_100mhz:		in std_logic:='0';
	rst_b:			in std_logic:='1';
	up_in_b:		in std_logic:='1';
	down_in_b:		in std_logic:='1';
	syncha_b:		in std_logic:='1';
	synchb_b:		in std_logic:='1';
	dips_in_b:		in std_logic_vector(1 downto 0):="11";
 	led_out_b:		out std_logic_vector(7 downto 0):=(others =>'1');
	sdo_spread_out:		out std_logic:='1'		-- de data om te versturen
	);
end component;
constant period: 	time := 100*1000 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal clk:		std_logic:='0';
signal led_out_b:	std_logic_vector(7 downto 0):=(others =>'0');
signal rst_b:		std_logic:='1';
signal up_in_b:		std_logic:='1';
signal down_in_b:	std_logic:='1';
signal syncha_b:	std_logic:='1';
signal synchb_b:	std_logic:='1';
signal dips_in_b:	std_logic_vector(1 downto 0):="00";
signal sdo_spread_out:	std_logic:='1';

begin 
uut: senderMetCklDiv_b
port map(
	clk_100mhz	=> clk,
	rst_b		=> rst_b,
	up_in_b		=> up_in_b,
	down_in_b	=> down_in_b,
	syncha_b	=> syncha_b,
	synchb_b	=> synchb_b,
	dips_in_b	=> dips_in_b,
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


tb : PROCESS 
BEGIN
rst_b		<=not('1');
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
rst_b		<=not('0');
up_in_b		<=not('0');
syncha_b    	<='1';
synchb_b    	<='1';
down_in_b		<=not('0');
dips_in_b		<="00";		-- unencrypted
wait for delay; --insert delay 10 ns
wait for period;

-----------Test up '1' normaal optellen dips 00---------- er zit overflow in
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
-----------Test '1' normaal met dips 01----------
dips_in_b		<="01";
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
-----------Test '1' normaal met dips 10----------
dips_in_b		<="10";
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
-----------Test '1' normaal met dips 11----------
dips_in_b		<="11";
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

-----------Test '0' normaal aftellen met underflow----------
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
-----------Test '1' BOUNCE----------
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
-----------Test '0' BOUNCE----------
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
rst_b	<=not('1');			-- proberen +1, muslukt door rst
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
FOR J IN 0 TO 50000 loop	-- even stabiel houden
	WAIT FOR period;
END LOOP;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;