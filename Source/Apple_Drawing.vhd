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
			Reset										:	in		std_logic;
			videoOn_apple  					:	in  	std_logic;               							-- 1 = Bildbereich
			vga_clk									:	in		std_logic;
			NewFrame_apple					:	in		std_logic;

		-- Inout ports

		-- Output ports
			Draw_Apple							: out 	std_logic := 	'0'
	);
end Apple_Drawing;

architecture beh_Apple_Drawing of Apple_Drawing is

	-- Declarations (optional)
	
		-- Declarations Own Var Types
			type 				x_pos_arr 					is array (0 to 41/*Nachrechnen*/) of integer range -100 to 1280;
			type 				y_pos_arr 					is array (0 to 40/*Nachrechnen*/) of integer range -100 to 1024;
			
		-- Constants
			constant		X_range								:		integer	range 0	to 1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
			constant		Y_range								:		integer	range 0 to 1024		:= 984;
			
			
		-- Declarations Signal
			signal			Update_Sig											:		std_logic	:= '0';																			--The update signal is responsible for updating the position of the snake. 
			signal			CLK_ENA_1												:		std_logic := '0';
			signal 			x_apple													:	x_pos_arr := (others => 0);
			signal 			y_apple													:	y_pos_arr := (others => 0);
begin

	-- Process Statement (optional)
	
	Apple_Drawing : process(all)
	
		begin
			
			if rising_edge(vga_clk)	then
			
			end if;
			
		end process Apple_Drawing;

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Apple_Drawing;
