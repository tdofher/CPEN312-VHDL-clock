LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY Lab_3 IS
	port(
	KEY0, KEY1, KEY2, KEY3, CLK_50	:IN 	STD_LOGIC;
	SetHighDigit, SetLowDigit : IN STD_LOGIC_VECTOR(3 downto 0);
	MSD, LSD, MMD, LMD, MHD, LHD:OUT STD_LOGIC_VECTOR (0 to 6) 
	);
END Lab_3;

ARCHITECTURE a of Lab_3 is
	SIGNAL ClkFlag:	STD_LOGIC;
	SIGNAL Internal_Count:	STD_LOGIC_VECTOR(28 downto 0);
	SIGNAL HighDigit, LowDigit, MinHighDigit, MinLowDigit, HourLowDigit, HourHighDigit: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL MSD_7SEG, LSD_7SEG, MMD_7SEG, LMD_7SEG, MHD_7SEG, LHD_7SEG: STD_LOGIC_VECTOR(0 to 6);
BEGIN

	LSD<=LSD_7SEG;
	MSD<=MSD_7SEG;
	LMD<=LMD_7SEG;
	MMD<=MMD_7SEG;
	LHD<=LHD_7SEG;
	MHD<=MHD_7SEG;

	PROCESS(CLK_50)
	BEGIN
		if(CLK_50'event and CLK_50='1') then
			if Internal_Count<25000000 then
				Internal_Count<=Internal_Count+1;
			else
				Internal_Count<=(others => '0'); 
				ClkFlag<=not ClkFlag;
			end if;
		end if;
	END PROCESS;

	PROCESS(ClkFlag, KEY0, KEY1, KEY2, KEY3)
	BEGIN
	
		if(KEY0='0') then -- reset
			LowDigit<="0000";
			HighDigit<="0000";
			MinLowDigit<="0000";
			MinHighDigit<="0000";
			HourLowDigit<="0001";
			HourHighDigit<="0000";
		elsif(ClkFlag'event and ClkFlag='1') then
			if (LowDigit=9) then
				LowDigit<="0000";
				if (HighDigit=5) then
					HighDigit<="0000";
					if(MinLowDigit=9) then
						MinLowDigit <= "0000";
						if(MinHighDigit=5) then
							MinHighDigit <= "0000";
							if(HourLowDigit = 2 and HourHighDigit = 1) then
								HourLowDigit <= "0001";
								HourHighDigit <= "0000";
							elsif(HourLowDigit = 9) then
								HourLowDigit <= "0000";
								HourHighDigit <= "0001";
							else HourLowDigit <= HourLowDigit + '1';
							end if;
						else MinHighDigit <= MinHighDigit + '1';
						end if;
					else MinLowDigit<=MinLowDigit +'1';
					end if;
				else HighDigit<=HighDigit+'1';
				end if;
			else
				LowDigit<=LowDigit+'1';
			end if;
		end if;
		
		if(KEY1 = '0') then
			LowDigit <= SetLowDigit;
			HighDigit <= SetHighDigit;
		end if;
		if(KEY2 = '0') then
			MinLowDigit <= SetLowDigit;
			MinHighDigit <= SetHighDigit;
		end if;
		if(KEY3 = '0') then
			HourLowDigit <= SetLowDigit;
			HourHighDigit <= SetHighDigit;
		end if;
		
	END PROCESS;

	PROCESS(LowDigit, HighDigit, MinHighDigit, MinLowDigit, HourLowDigit, HourHighDigit)
	BEGIN
		case LowDigit is
			when "0000" => LSD_7SEG <= "0000001";
			when "0001" => LSD_7SEG <= "1001111";
			when "0010" => LSD_7SEG <= "0010010";
			when "0011" => LSD_7SEG <= "0000110";
			when "0100" => LSD_7SEG <= "1001100";
			when "0101" => LSD_7SEG <= "0100100";
			when "0110" => LSD_7SEG <= "0100000";
			when "0111" => LSD_7SEG <= "0001111";
			when "1000" => LSD_7SEG <= "0000000";
			when "1001" => LSD_7SEG <= "0000100";
			when others => LSD_7SEG <= "1111111";
		end case;

		case HighDigit is
			when "0000" => MSD_7SEG <= "0000001";
			when "0001" => MSD_7SEG <= "1001111";
			when "0010" => MSD_7SEG <= "0010010";
			when "0011" => MSD_7SEG <= "0000110";
			when "0100" => MSD_7SEG <= "1001100";
			when "0101" => MSD_7SEG <= "0100100";
			when "0110" => MSD_7SEG <= "0100000";
			when "0111" => MSD_7SEG <= "0001111";
			when "1000" => MSD_7SEG <= "0000000";
			when "1001" => MSD_7SEG <= "0000100";
			when others => MSD_7SEG <= "1111111";
		end case;
		
		case MinLowDigit is
			when "0000" => LMD_7SEG <= "0000001";
			when "0001" => LMD_7SEG <= "1001111";
			when "0010" => LMD_7SEG <= "0010010";
			when "0011" => LMD_7SEG <= "0000110";
			when "0100" => LMD_7SEG <= "1001100";
			when "0101" => LMD_7SEG <= "0100100";
			when "0110" => LMD_7SEG <= "0100000";
			when "0111" => LMD_7SEG <= "0001111";
			when "1000" => LMD_7SEG <= "0000000";
			when "1001" => LMD_7SEG <= "0000100";
			when others => LMD_7SEG <= "1111111";
		end case;
		
		case MinHighDigit is
			when "0000" => MMD_7SEG <= "0000001";
			when "0001" => MMD_7SEG <= "1001111";
			when "0010" => MMD_7SEG <= "0010010";
			when "0011" => MMD_7SEG <= "0000110";
			when "0100" => MMD_7SEG <= "1001100";
			when "0101" => MMD_7SEG <= "0100100";
			when "0110" => MMD_7SEG <= "0100000";
			when "0111" => MMD_7SEG <= "0001111";
			when "1000" => MMD_7SEG <= "0000000";
			when "1001" => MMD_7SEG <= "0000100";
			when others => MMD_7SEG <= "1111111";
		end case;
		
		case HourLowDigit is
			when "0000" => LHD_7SEG <= "0000001";
			when "0001" => LHD_7SEG <= "1001111";
			when "0010" => LHD_7SEG <= "0010010";
			when "0011" => LHD_7SEG <= "0000110";
			when "0100" => LHD_7SEG <= "1001100";
			when "0101" => LHD_7SEG <= "0100100";
			when "0110" => LHD_7SEG <= "0100000";
			when "0111" => LHD_7SEG <= "0001111";
			when "1000" => LHD_7SEG <= "0000000";
			when "1001" => LHD_7SEG <= "0000100";
			when others => LHD_7SEG <= "1111111";
		end case;
		
		case HourHighDigit is
			when "0000" => MHD_7SEG <= "0000001";
			when "0001" => MHD_7SEG <= "1001111";
			when "0010" => MHD_7SEG <= "0010010";
			when "0011" => MHD_7SEG <= "0000110";
			when "0100" => MHD_7SEG <= "1001100";
			when "0101" => MHD_7SEG <= "0100100";
			when "0110" => MHD_7SEG <= "0100000";
			when "0111" => MHD_7SEG <= "0001111";
			when "1000" => MHD_7SEG <= "0000000";
			when "1001" => MHD_7SEG <= "0000100";
			when others => MHD_7SEG <= "1111111";
		end case;
		
		
	END PROCESS;

end a;

	
