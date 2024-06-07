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
			xpos_game     													:	in  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
			ypos_game     													:	in  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
			BTN_LEFT																:	in	 	std_logic;														-- Button 02	
			BTN_RIGHT																:	in	 	std_logic;														-- Button 01
			Reset																		:	in		std_logic;														-- Button 00
			videoOn_game  													:	in  	std_logic;               							-- 1 = Bildbereich
			vga_clk																	:	in		std_logic;														-- Global CLK
			NewFrame_game														:	in		std_logic;														-- 1 = NewFrame on VGA	
				
		-- Inout ports				
				
				
		-- Output ports				
			Draw_Snake_Out													: out 	std_logic := 	'0';										-- Signal for Snake-Body Drawing on VGA Output
			Draw_Snake_Zero_Out											: out 	std_logic := 	'0';										-- Signal for Snake-Head Drawing on VGA Output
end Game_Main;

architecture beh_Game_Main of Game_Main is

	-- Declarations (optional)
	-- Signal Declarations
	
	signal 			Draw_Apple_In										:	std_logic	:=	'0';													-- Signal for Apple Drawing on VGA Output
	signal 			Draw_Snake_In										:	std_logic	:=	'0';													-- Signal for Snake-Body Drawing on VGA Output
	signal			Draw_Snake_Zero									:	std_logic	:=	'0';													-- Signal for Snake-Head Drawing on VGA Output
	signal 			Add															:	std_logic	:=	'0';													-- Signal for Snake Growing
	signal			Apple_Update										:	std_logic	:=	'0';													-- Signal for Update Apple Position
	signal			BTN_RESET_SYNC									:	std_logic_vector (1 downto 0) := "11";			-- Vektor for Syncing
	signal			BTN_RIGHT_SYNC									:	std_logic_vector (1 downto 0) := "11";			-- Vektor for Syncing 
	signal			BTN_LEFT_SYNC										:	std_logic_vector (1 downto 0) := "11";			-- Vektor for Syncing 	
	signal			x_Apple_Game										:	integer range	0	to	2000 := 0;							-- x Kordinate from Apple
	signal			y_Apple_Game										:	integer range	0	to	2000 := 0;							-- y Kordinate from Apple
	signal			Seg0														:	character;
	signal			Seg1														:	character;
	signal			Seg2														:	character;
	signal			Seg3														:	character;

begin

	/*Snake_Drawing Instantiation*/
		
		Snake_Drawing	:	entity	work.snake_Drawing
			port map (
					xpos_snake     					=>	xpos_game,
					ypos_snake     					=>	ypos_game,
					BTN_LEFT								=>	BTN_LEFT,
					BTN_RIGHT								=>	BTN_RIGHT,
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
					Apple_Update						=>	Apple_Update,
					y_apple_Out							=>	y_apple_Game
			);
		
	
		/*Proccess for everything that happens in the Startscreen*/
		Game_Start	:	process(all)
		
			begin
					if rising_edge	(vga_clk)	then
					
					/*Difficulty Setting*/
					if Game_State = startscreen	then

						if BTN_RIGHT_SYNC(1) = '0' and BTN_RIGHT_SYNC(0) = '1' then
							case Game_Difficulty	is
								when	Easy				=>		Game_Difficulty	<= Medium;
								when	Medium			=>		Game_Difficulty	<= Hard;
								when	Hard				=>		Game_Difficulty	<= Easy;
								when others				=>		Game_Difficulty	<= Medium;
							end case;
						end if;
						
						if BTN_LEFT_SYNC(1) = '0' and BTN_LEFT_SYNC(0) = '1' then
							case Game_Difficulty	is
								when	Easy				=>		Game_Difficulty	<= Hard;
								when	Medium			=>		Game_Difficulty	<= Easy;
								when	Hard				=>		Game_Difficulty	<= Medium;
								when others				=>		Game_Difficulty	<= Medium;
							end case;
						end if;
					end if;
					/*Difficulty Setting END*/
					
					/*7-Segment Output*/
						case	Game_Difficulty	is
							when	Easy					=>	Null;		
							when	Medium				=>	Null;		
							when	Hard					=>	Null;		
							when	others				=>	Null;		
						end case;
					end if;
		
		end process	Game_Start;
		
		/*Proccess for everything that happens in the actual Game*/
		Game_Main : process(all)
		
		begin
				
				if rising_edge(vga_clk)	then
				
					Draw_Snake_Zero 			<=	'0';
					Apple_Update					<=	'0';
					Draw_Apple_Out 				<=	Draw_Apple_In;
					Draw_Snake_Out 				<=	Draw_Snake_In;
					Draw_Snake_Zero_Out		<=	Draw_Snake_Zero;
					
					BTN_LEFT_SYNC(0) <= BTN_LEFT;
					BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
					
					BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
					BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
					
					BTN_RESET_SYNC(0) <= Reset;
					BTN_RESET_SYNC(1) <= BTN_RESET_SYNC(0);
					
					SLD_Easy_SYNC(0)	<=	SLD_Easy_Game;
					SLD_Easy_SYNC(1)	<=	SLD_Easy_SYNC(0);
					
					SLD_Mid_SYNC(0)	<=	SLD_Mid_Game;
					SLD_Mid_SYNC(1)	<=	SLD_Mid_SYNC(0);
					
					SLD_Hard_SYNC(0)	<=	SLD_Hard_Game;
					SLD_Hard_SYNC(1)	<=	SLD_Hard_SYNC(0);
					
					/*GameState Change*/
					
					if BTN_RESET_SYNC(1) = '0' and BTN_RESET_SYNC(0) = '1' then
						case	Game_State	is
							when	Startscreen		=> Game_State <= 	Game;
							when	Endscreen			=> Game_State	<=	startscreen;	
							when	others				=> Null;
						end case;
					end if;
					
					/*GameState Change END*/
					
					/*Code for Actual Game*/
					if Game_state	= Game	then
					
												/*Schlangen Wachstum wenn Schlange Apfel isst*/
						if x_apple_Game = x_snake(0) and y_apple_Game = y_snake(0)	then
						
							Add 					<=	'1';
							Apple_Update	<=	'1';
							
						else
						
							Add 					<=	'0';
							Apple_Update	<=	'0';
							
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
					/*Code for Actual Game END*/
				end if; -- VGA CLK
				
		end process Game_Main;
end beh_Game_Main;

