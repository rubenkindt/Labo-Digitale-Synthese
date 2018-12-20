-- Made by Ruben Kindt 21/11/2018

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity receiverMetClkDiv_b_tb is
end;

architecture bench of receiverMetClkDiv_b_tb is
component receiverMetClkDiv_b
port(	
	clk_100mhz:	in std_logic:='0';
	rst_b:		in std_logic:='1';
	sdi_spread:	in std_logic:='1';
	dips_in_b:	in std_logic_vector(1 downto 0):="11";
 	led_out_b:	out std_logic_vector(7 downto 0):=(others =>'1')	-- 7seg LED
	);
end component;

constant period: 	time := 100*1000 ns;
constant delay: 	time :=  10 ns;
signal end_of_sim:	boolean := false;

signal	clk:		std_logic:='0';
signal	rst_b:		std_logic:='1';
signal	sdi_spread:	std_logic:='1';
signal	dips_in_b:	std_logic_vector(1 downto 0):="11";
signal	led_out_b:	std_logic_vector(7 downto 0):=(others =>'0');

begin 
uut: receiverMetClkDiv_b
port map(
	clk_100mhz	=> clk,
	rst_b		=> rst_b,
	sdi_spread	=> sdi_spread,
	dips_in_b	=> dips_in_b,
	led_out_b	=> led_out_b
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
variable  preamble: std_logic_vector(0 to 6):="0111110";
variable  pn1: std_logic_vector(0 to 30):="0100001010111011000111110011010";
			-- controle	   0100001010111011000111110011010
variable  pn2: std_logic_vector(0 to 30):="1110000110101001000101111101100";
			-- controle 	   1110000110101001000101111101100
variable  gld: std_logic_vector(0 to 30):=pn1 xor pn2;
		-- zou dit moeten zijn     1010001100010010000010001110110, weinig nut voor controle
BEGIN
rst_b		<=not('0');
dips_in_b	<=not("00");
sdi_spread   	<='0'; 
wait for delay; --insert delay 10 ns
---------unencrypted----------
FOR I IN 0 TO 6 loop 			-- preamble door sturen
	sdi_spread	<=preamble(I);
	FOR J IN 1 TO 31*16 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR I IN 0 TO 3 loop 			-- data=1111 doorsturen
	sdi_spread	<='1';
	FOR J IN 1 TO 31*16 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;

FOR I IN 0 TO 6 loop 			-- preamble door sturen
	sdi_spread	<=preamble(I);
	FOR J IN 1 TO 31*16 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR I IN 0 TO 3 loop 			-- data=1111 doorsturen
	sdi_spread	<='1';
	FOR J IN 1 TO 31*16 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;

-----------pn1----------
dips_in_b		<=not("01");
	--- preamble = 0111110 ---
FOR I IN 0 TO 30 loop 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);	 	-- uitleg zie hier onder, let op hier staat geen NOT()
	FOR J IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR J IN 0 TO 4 LOOP	-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn1(I)); 	-- loopt over de variable pn1 zie lijn 63 en neemt daar het complement van het I'de bitje
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
FOR I IN 0 TO 30 loop 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 1001--
FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
	sdi_spread	<=not(pn1(I));
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
	sdi_spread	<=not(pn1(I));
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;




	--- preamble = 0111110 ---
FOR I IN 0 TO 30 loop 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR J IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;
END LOOP;
FOR J IN 0 TO 4 LOOP	-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn1(I));
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
FOR I IN 0 TO 30 loop 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 1001--
FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
	sdi_spread	<=not(pn1(I));
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
	sdi_spread	<=pn1(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
	sdi_spread	<=not(pn1(I));
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
-----------pn2----------
dips_in_b		<=not("10");

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=pn2(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;

FOR J IN 0 TO 4 LOOP				-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn2(I)); 	
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=pn2(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 0011--
FOR J IN 0 TO 1 LOOP
	FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
		sdi_spread	<=pn2(I);
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
FOR J IN 0 TO 1 LOOP
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn2(I));
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;



FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=pn2(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;

FOR J IN 0 TO 4 LOOP				-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn2(I)); 	
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=pn2(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 0011--
FOR J IN 0 TO 1 LOOP
	FOR I IN 0 TO 30 LOOP 	-- dit is een '0'-tje
		sdi_spread	<=pn2(I);
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
FOR J IN 0 TO 1 LOOP
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(pn2(I));
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
-----------detect match for gold----------
dips_in_b		<=not("11");

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=gld(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;

FOR J IN 0 TO 4 LOOP				-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(gld(I)); 	
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=gld(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 1111--
FOR J IN 0 TO 3 LOOP				-- dit zijn 4 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(gld(I));
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;


FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=gld(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;

FOR J IN 0 TO 4 LOOP				-- dit zijn 5 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(gld(I)); 	
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;

FOR I IN 0 TO 30 LOOP 				-- dit is een '0'-tje
	sdi_spread	<=gld(I);
	FOR JJ IN 0 TO 15 LOOP
		WAIT FOR period;
	END LOOP;	
END LOOP;
		-- DATA = 1111--
FOR J IN 0 TO 3 LOOP				-- dit zijn 4 '1'-tjes
	FOR I IN 0 TO 30 LOOP 	-- dit is een '1'-tje
		sdi_spread	<=not(gld(I));
		FOR JJ IN 0 TO 15 LOOP
			WAIT FOR period;
		END LOOP;	
	END LOOP;
END LOOP;
-----------rst test----------
rst_b	<=not('1');
FOR J IN 0 TO 150 LOOP
	WAIT FOR period;
END LOOP;
rst_b	<=('0');
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
WAIT FOR period;
----------END SIM--------------
end_of_sim <= true;
wait;
END PROCESS;
end;