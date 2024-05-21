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
			xpos_apple     					:	in  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
			ypos_apple     					:	in  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
			Reset										:	in		std_logic	:= '0';
			videoOn_apple  					:	in  	std_logic	:= '0';               							-- 1 = Bildbereich
			vga_clk									:	in		std_logic	:= '0';
			NewFrame_apple					:	in		std_logic	:= '0';
			Apple_Update						:	in		std_logic	:= '0';

		-- Inout ports

		-- Output ports
			Draw_Apple									: out 	std_logic := 	'0';
			x_Apple_OUT									:	out		integer	range	0	to	2000	:=	0;
			y_Apple_OUT									:	out		integer	range	0	to	2000	:=	0
	);
end Apple_Drawing;

architecture beh_Apple_Drawing of Apple_Drawing is

	-- Declarations (optional)
	
		-- Declarations Own Var Types

			
		-- Constants
			constant		X_range								:		integer	range 0	to 	1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
			constant		Y_range								:		integer	range 0 to 	1024		:= 984;
			constant		CNT_MAX								:		integer	range	0	to	41			:= 0;
			
			
		-- Declarations Signal
			signal			Update_Sig											:		std_logic	:= '0';																			--The update signal is responsible for updating the position of the snake. 
			signal			CLK_ENA_1												:		std_logic := '0';
			signal 			x_apple													:		integer	range 0 to 1280		:= 600;
			signal 			y_apple													:		integer	range 0 to 1024		:= 492;
			signal			Random_Num											:		integer	range	0	to 41			:= 20;
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
		
		
		
		
		Random_GENI	:	process(all)
		
			begin
			
				if rising_edge(vga_clk)	then
					
				end if;
			
			end process Random_GENI;

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Apple_Drawing;
