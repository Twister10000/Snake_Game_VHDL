-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use	work.Movement_PKG.all;
use work.Game_State_PKG.all;

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
			Draw_Snake_Out									: out 	std_logic := 	'0';
			Draw_Snake_Zero_Out							: out 	std_logic := 	'0';
			Draw_Apple_Out									:	out		std_logic	:=	'0');
end Game_Main;

architecture beh_Game_Main of Game_Main is

	-- Declarations (optional)
	-- Signal Declarations
	
	signal 			Draw_Apple_In										:	std_logic	:=	'0';
	signal 			Draw_Snake_In										:	std_logic	:=	'0';
	signal			Draw_Snake_Zero									:	std_logic	:=	'0';
	signal 			Add															:	std_logic	:=	'0';
	signal			BTN_RESET_SYNC									:	std_logic_vector (1 downto 0);
	signal			x_Apple_Game										:	integer range	0	to	2000 := 0;
	signal			y_Apple_Game										:	integer range	0	to	2000 := 0;

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
					Reset										=>	Reset,
					add_snake								=>	add);
					
	/*Apple_Drawing Instantiation*/
		Apple_Drawing	: entity	work.Apple_Drawing
			port map(
					xpos_apple     					=>	xpos_game,
					ypos_apple     					=>	ypos_game,
					videoOn_apple  					=>	videoOn_game,
					vga_clk									=>	vga_clk,
					NewFrame_apple					=>	NewFrame_game,
					Draw_apple							=>	Draw_Apple_In,
					Reset										=>	Reset,
					x_Apple_OUT							=>	x_apple_Game,
					y_apple_Out							=>	y_apple_Game
			);
			
					
				Game_Main : process(all)
				
				begin
						
						if rising_edge(vga_clk)	then
						
							Draw_Snake_Zero 			<= '0';
							Draw_Apple_Out 				<=	Draw_Apple_In;
							Draw_Snake_Out 				<=	Draw_Snake_In;
							Draw_Snake_Zero_Out		<=	Draw_Snake_Zero;
							
							
							BTN_RESET_SYNC(0) <= Reset;
							BTN_RESET_SYNC(1) <= BTN_RESET_SYNC(0);
--							/*Schlangen Wachstum wenn Schlange Apfel isst*/
--							if x_apple_Game = x_snake(0) and y_apple_Game = y_snake(0)	then
--								Add <= '1';
--							else
--								Add <= '0';
--							end if;
							
							if BTN_RESET_SYNC(1) = '0' and BTN_RESET_SYNC(0) = '1' then
								case	Game_State	is
									when	Startscreen		=> Game_State <= 	Game;
									when	Endscreen			=> Game_State	<=	startscreen;	
									when	others				=> Null;
								end case;
							end if;
							if Game_state	= Game	then
							
														/*Schlangen Wachstum wenn Schlange Apfel isst*/
								if x_apple_Game = x_snake(0) and y_apple_Game = y_snake(0)	then
									Add <= '1';
								else
									Add <= '0';
								end if;
							
																						/*Snake Crasch Detection*/
								if xpos_game	> x_snake(0) and xpos_game < (x_snake(0)+40) then
									if ypos_game > y_snake(0) and ypos_game < (y_snake(0)+40) then -- Quadrat
										Draw_Snake_Zero <= '1';
									end if;
								end if;
								if Draw_Snake_In and Draw_Snake_Zero	then	
										Game_state <= Endscreen;
								end if;
																						/*Snake Crasch Detection END*/
							end if;

						end if; -- VGA CLK
						
				end process Game_Main;
	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Game_Main;

