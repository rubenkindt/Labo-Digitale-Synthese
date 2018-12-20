-- made by Ruben Kindt	14/11/2018
-- patroon zoeker voor de 4 patronen en hun complemnt er van
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY matchedFilter IS
PORT (	
	clk,rst		:IN  std_logic:='0';
	clk_en		:IN  std_logic:='1';
	chip_sample	:IN  std_logic:='0';	-- "het is vrij veilig om in te lezen"
	sdi_spread	:IN  std_logic:='0';
	dips_in		:IN  std_logic_vector(1 downto 0):="00";
	seq_det_MFilter	:OUT  std_logic:='0'
	);
END;

ARCHITECTURE behav OF matchedFilter IS
						-- we vullen van links naar rechts 
						-- bit 0 eerst vullen dan bit 1 enz.
CONSTANT 	 no_ptrn   	:std_logic_vector(0 to 30):=(others=>'0');
CONSTANT 	 no_ptrn_b 	:std_logic_vector(0 to 30):=not(no_ptrn);

CONSTANT 	ml1_ptrn   	:std_logic_vector(0 to 30):="0100001010111011000111110011010";
CONSTANT 	ml1_ptrn_b 	:std_logic_vector(0 to 30):=not(ml1_ptrn);
						-- controle  0100001010111011000111110011010

CONSTANT 	ml2_ptrn   	:std_logic_vector(0 to 30):="1110000110101001000101111101100";
CONSTANT 	ml2_ptrn_b 	:std_logic_vector(0 to 30):=not(ml2_ptrn);
						-- controle  1110000110101001000101111101100

CONSTANT 	gld_ptrn   	:std_logic_vector(0 to 30):=ml1_ptrn xor ml2_ptrn;
CONSTANT 	gld_ptrn_b 	:std_logic_vector(0 to 30):=not(gld_ptrn);
						-- 	     1010001100010010000010001110110

SIGNAL		check_ptrn	:std_logic_vector(0 to 30):=(others =>'0');
SIGNAL		check_ptrn_b	:std_logic_vector(0 to 30):=(others =>'1');
SIGNAL		shifRegi_pres	:std_logic_vector(0 to 30):="0000000000000000000000000000001";	
	-- stel dips "00" en de rst komt terug vrij, dat zou een seq_det geven indien er een 0binnen komt, die kans verkleint door die 1 er in te zetten;
SIGNAL		shifRegi_nxt	:std_logic_vector(0 to 30):="0000000000000000000000000000001";

BEGIN
mux: process (dips_in)
begin
case dips_in is
	when "00" =>	-- unencrypted
		check_ptrn	<= no_ptrn;
		check_ptrn_b	<= no_ptrn_b;
	when "01" =>	-- pn1 
		check_ptrn	<= ml1_ptrn;
		check_ptrn_b	<= ml1_ptrn_b;
	when "10" =>	-- pn2
		check_ptrn	<= ml2_ptrn;
		check_ptrn_b	<= ml2_ptrn_b;
	when "11" =>	-- gold
		check_ptrn	<= gld_ptrn;
		check_ptrn_b	<= gld_ptrn_b;
	when others =>	-- errors 
		check_ptrn	<= no_ptrn;
		check_ptrn_b	<= no_ptrn_b;
end case;
end process mux;

syn_shift: process(clk)
begin
if rising_edge(clk) and clk_en ='1' then
    if rst = '1'then	
          shifRegi_pres <= "0000000000000000000000000000001";	-- stel dips in unencrypted en de rst komt los, dat zou een seq_det geven bij 0
    else
	if chip_sample='1' then
        	shifRegi_pres <= shifRegi_nxt;			-- anders de volgende staat inladen
	else
	end if;
    end if;
else
end if;
end process syn_shift;

com_shift: process(chip_sample,shifRegi_pres,sdi_spread)
begin
shifRegi_nxt <= shifRegi_pres (1 to 30) & sdi_spread; -- naar links shiften
end process com_shift;

com_check: process (check_ptrn,check_ptrn_b,shifRegi_pres)	-- eleganter met 2 combinatorische delen
begin
if check_ptrn = shifRegi_pres or check_ptrn_b = shifRegi_pres then
	seq_det_MFilter <='1';
else 
	seq_det_MFilter <='0';
end if;
end process com_check;
END behav;





