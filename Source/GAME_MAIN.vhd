-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)
entity Game_Main is

	port
	(
		-- Input ports
			xpos_game     					:	in  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
			ypos_game     					:	in  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
			BTN_LEFT								:	in	 	std_logic;
			BTN_RIGHT								:	in	 	std_logic;
			Reset										:	in		std_logic;
			videoOn_game  					:	in  	std_logic;               							-- 1 = Bildbereich
			vga_clk									:	in		std_logic;
			NewFrame_game						:	in		std_logic;	

		-- Inout ports


		-- Output ports
			Draw_Snake_Out							: out 	std_logic := 	'0';
			Draw_Apple_Out							:	out		std_logic	:=	'0');
end Game_Main;

architecture beh_Game_Main of Game_Main is

	-- Declarations (optional)
	-- Signal Declarations
	
	signal 			Draw_Apple_In						:	std_logic	:= '0';
	signal 			Draw_Snake_In						:	std_logic	:= '0';	

begin

	/*Snake_Drawing Instantiation*/
		
		Snake_Drawing	:	entity	work.snake_Drawing
			port map (
					xpos_snake     					=>	xpos_game,
					ypos_snake     					=>	ypos_game,
					BTN_LEFT								=>	BTN_LEFT,
					BTN_RIGHT								=>	BTN_RIGHT,
					videoOn_snake  					=>	videoOn_game,
					vga_clk									=>	vga_clk,
					NewFrame_snake					=>	NewFrame_game,
					Draw_Snake							=>	Draw_Snake_In,
					Reset										=>	Reset);
					
					
					
				Game_Main : process(all)
				
				begin
						
						if rising_edge(vga_clk)	then
							
							Draw_Apple_Out <= Draw_Apple_In;
							Draw_Snake_Out <=	Draw_Snake_In;
							
							
						end if;
						
				end process Game_Main;
	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Game_Main;

