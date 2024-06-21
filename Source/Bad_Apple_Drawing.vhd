-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use	work.Movement_PKG.all;
use work.Game_State_PKG.all;

entity Bad_Apple_Drawing is

	generic	(Simulation	:	boolean	:= false);

	port
	(
		-- Input ports
			xpos_bad_apple     							:	in  	integer range 0 to 1300;   										-- Pixel Pos x Bildbereich
			ypos_bad_apple     							:	in  	integer range 0 to 1033;    									-- Pixel Pos y Bildbereich
			Reset												:	in		std_logic	:= '0';															-- Button 00
			videoOn_bad_apple  							:	in  	std_logic	:= '0';               							-- 1 = Bildbereich
			vga_clk											:	in		std_logic	:= '0';															-- Global CLK
			NewFrame_bad_apple							:	in		std_logic	:= '0';															-- 1 = NewFrame on VGA	
			Bad_Apple_Update								:	in		std_logic	:= '0';													-- Signal for Update Bad_Apple Position

		-- Inout ports

		-- Output ports
			Draw_Bad_Apple											: out 	std_logic := 	'0'														-- Signal for Bad Apple Drawing on VGA Output
	);
end Bad_Apple_Drawing;

architecture beh_Bad_Apple_Drawing of Bad_Apple_Drawing is

	-- Declarations (optional)
	
		-- Declarations Own Var Types

			
		-- Constants
			constant		X_range													:		integer	range 0	to 	1280		:= 1240;			-- Moving Range for X
			constant		Y_range													:		integer	range 0 to 	1024		:= 984;				-- Moving Range for Y
			constant		Stepsize_x											:		integer range 0 to 40				:= 40;				-- Stepsize for X
			constant		Stepsize_y											:		integer range 0 to 41				:= 41;				-- Stepsize for Y
			constant		CNT_MAX_x												:		integer	range	0	to	40			:= 29;				-- Max CNT Value for Ranom Generator
			constant		CNT_MAX_y												:		integer	range	0	to	41			:= 22;				-- Max CNT Value for Ranom Generator
			constant		Max_Amount											:		integer range 0 to 40				:= 40;				-- MAX SNAKE Length
			constant 		CLK_div1_MAX										:		integer range 0 to 108e6 		:= 73e6;			-- 	CLK MAX COUNTER
			constant 		CLK_div1_MAX_Simu								:		integer range 0 to 108e6 	:= 256;											--	CLK MAX COUNTER for Simulation
			
			
			
		-- Declarations Signal
			signal			Random_Num_x										:		integer	range	0	to	40			:=	20;						-- Random Number for Bad Apple X 
			signal			Random_Num_y										:		integer	range	0	to	41			:=	20;						-- Random Number for Bad Apple Y
			signal			Amount													:		integer	range	0	to	40			:=	1;
			signal			Update													:		std_logic	:= '0';
			signal			CLK_ENA													:		std_logic := '0';															-- Enabel Signal for CLK DIivder
			
			signal 			x_bad_apple											:	x_pos_arr := (others => 1900);									-- Signal for X Kordinate for bad_Apple
			signal 			y_bad_apple											:	y_pos_arr := (others => 1900);									-- Signal for Y Kordinate for bad_Apple
begin

		/*CLK_DIV Instantiations*/
		CLK_DIV	:	if Simulation	= false generate
		/*Easy Mode*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA);

		end generate Clk_DIV;
		
		
		Simu_CLK_DIV	:	if Simulation	= true generate
		/*Easy Mode*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX_Simu)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA);

		end generate Simu_CLK_DIV;
	-- Process Statement (optional)
	
	Apple_Drawing : process(all)
	
		begin
			
			if rising_edge(vga_clk)	then
				Draw_Bad_Apple	<=	'0';
				

				
				if videoOn_bad_apple = '1'	then
						for i in 1 to Max_Amount	loop
							if xpos_bad_apple	> x_bad_apple(i) and xpos_bad_apple < (x_bad_Apple(i)+40) then
								if ypos_bad_apple > y_bad_apple(i) and ypos_bad_apple < (y_bad_apple(i)+40) then -- Quadrat
									Draw_Bad_Apple <= '1';
								end if;
							end if;
						end loop;
				end if;
			end if;
			
		end process Apple_Drawing;
		
		
		
		/*Random Number Generator for randomized apple Position*/
		Random_GENI	:	process(all)
		
			begin
						
				if rising_edge(vga_clk)	then
						/*Counter*/
						if CLK_ENA	= '1' then
						Random_Num_x	<=	Random_Num_x	+	1;
						Random_Num_y	<=	Random_Num_y	+	1;
						end if;
						if Game_State = startscreen	then
							x_bad_apple	<= (others => 1900);
							y_bad_apple	<= (others => 1900);
						end if;
						
						if Random_Num_x	>= CNT_MAX_x	then
							Random_Num_x	<= 0;
						end if;
						
						if Random_Num_y	>= CNT_MAX_y	then
							Random_Num_y	<= 0;
						end if;
					
						if Bad_Apple_Update	=	'1'	then
							
							Update	<= '1';
						end if;
						if Update	= '1' then
							Update	<= '0';
							Amount	<= Amount	+	1;
							x_bad_apple(Amount)	<=	Random_Num_x*Stepsize_x + stepsize_x;
							y_bad_apple(Amount)	<=	Random_Num_y*stepsize_y + stepsize_y;
						end if;
				end if;
			
			end process Random_GENI;
end beh_Bad_Apple_Drawing;