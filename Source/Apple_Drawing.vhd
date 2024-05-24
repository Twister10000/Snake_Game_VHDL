-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
entity Apple_Drawing is

	port
	(
		-- Input ports
			xpos_apple     							:	in  	integer range 0 to 1300;   										-- Pixel Pos x Bildbereich
			ypos_apple     							:	in  	integer range 0 to 1033;    									-- Pixel Pos y Bildbereich
			Reset												:	in		std_logic	:= '0';															-- Button 00
			videoOn_apple  							:	in  	std_logic	:= '0';               							-- 1 = Bildbereich
			vga_clk											:	in		std_logic	:= '0';															-- Global CLK
			NewFrame_apple							:	in		std_logic	:= '0';															-- 1 = NewFrame on VGA	
			Apple_Update								:	in		std_logic	:= '0';															-- Signal for Update Apple Position

		-- Inout ports

		-- Output ports
			Draw_Apple									: out 	std_logic := 	'0';														-- Signal for Apple Drawing on VGA Output
			x_Apple_OUT									:	out		integer	range	0	to	2000	:=	0;							-- x Kordinate from Apple
			y_Apple_OUT									:	out		integer	range	0	to	2000	:=	0								-- y Kordinate from Apple
	);
end Apple_Drawing;

architecture beh_Apple_Drawing of Apple_Drawing is

	-- Declarations (optional)
	
		-- Declarations Own Var Types

			
		-- Constants
			constant		X_range													:		integer	range 0	to 	1280		:= 1240;			-- Moving Range for X
			constant		Y_range													:		integer	range 0 to 	1024		:= 984;				-- Moving Range for Y
			constant		Stepsize_x											:		integer range 0 to 40				:= 40;				-- Stepsize for X
			constant		Stepsize_y											:		integer range 0 to 41				:= 41;				-- Stepsize for Y
			constant		CNT_MAX_x												:		integer	range	0	to	40			:= 31;				-- Max CNT Value for Ranom Generator
			constant		CNT_MAX_y												:		integer	range	0	to	41			:= 24;				-- Max CNT Value for Ranom Generator
			
			
		-- Declarations Signal
			signal 			x_apple													:		integer	range 0 to	1280		:=	600;			-- x Kordinate from Apple
			signal 			y_apple													:		integer	range 0 to	1024		:=	492;			-- y Kordinate from Apple
			signal			Random_Num_x										:		integer	range	0	to	40			:=	20;				-- Random Number for Apple X 
			signal			Random_Num_y										:		integer	range	0	to	41			:=	20;				-- Random Number for Apple Y
begin

	-- Process Statement (optional)
	
	Apple_Drawing : process(all)
	
		begin
			
			if rising_edge(vga_clk)	then
				Draw_Apple	<=	'0';
				x_apple_OUT	<= 	x_Apple;
				y_apple_OUT	<=	y_apple;
				
				if videoOn_apple = '1'	then
					if xpos_apple	> x_apple and xpos_apple < (x_apple + 40) then
						if ypos_apple > y_apple and ypos_apple < (y_apple + 40) then -- Quadrat
							Draw_Apple <= '1';
						end if;
					end if;
				end if;
			end if;
			
		end process Apple_Drawing;
		
		
		
		/*Random Number Generator for randomized apple Position*/
		Random_GENI	:	process(all)
		
			begin
						
				if rising_edge(vga_clk)	then
						/*Counter*/
						Random_Num_x	<=	Random_Num_x	+	1;
						Random_Num_y	<=	Random_Num_y	+	1;
						
						if Random_Num_x	= CNT_MAX_x	then
							Random_Num_x	<= 0;
						end if;
						
						if Random_Num_y	= CNT_MAX_y	then
							Random_Num_y	<= 0;
						end if;
					
						if Apple_Update	=	'1'	then
							x_apple	<=	Random_Num_x*Stepsize_x;
							y_apple	<=	Random_Num_y*stepsize_y;
						end if;
				end if;
			
			end process Random_GENI;
end beh_Apple_Drawing;