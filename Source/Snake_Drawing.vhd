library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use	work.Movement_PKG.all;
use work.Game_State_PKG.all;


entity snake_drawing is
	generic	(Simulation	:	boolean	:= false);
	port
	(
		-- Input ports
			xpos_snake     					:	in  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
			ypos_snake     					:	in  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
			BTN_LEFT								:	in	 	std_logic;														-- Button 02
			BTN_RIGHT								:	in	 	std_logic;														-- Button 01
			Reset										:	in		std_logic;														-- Button 00
			vga_clk									:	in		std_logic;														-- Global CLK
			NewFrame_snake					:	in		std_logic;														-- 1 = NewFrame on VGA	
			Add_Snake								:	in 		std_logic;														-- Signal for Update Snake Length

		-- Inout ports


		-- Output ports
			Draw_Snake							: out 	std_logic := 	'0');										-- Signal for Snake Drawing on VGA Output
end snake_drawing;

architecture beh_snake_drawing of snake_drawing is

	-- Declarations (optional)
		-- Declarations Own Var Types
			
		-- Constants
			constant 		CLK_div1_MAX_Easy										:		integer range 0 to 108e6 	:= 40e6;										-- 	CLK MAX COUNTER for Difficulty: Easy
			constant 		CLK_div1_MAX_Mid										:		integer range 0 to 108e6 	:= 27e6;										--	CLK MAX COUNTER for Difficulty: Medium
			constant 		CLK_div1_MAX_Hard										:		integer range 0 to 108e6 	:= 16e6;										--	CLK MAX COUNTER for Difficulty: Hard
			constant 		CLK_div1_MAX_Simu										:		integer range 0 to 108e6 	:= 256;											--	CLK MAX COUNTER for Simulation
			constant		Stepsize_x													:		integer range 0 to 40			:= 40;											-- Stepsize for X
			constant		Stepsize_y													:		integer range 0 to 41			:= 41;											-- Stepsize for Y
			constant		X_range															:		integer	range 0	to 1280		:= 1240;										-- Moving Range for X
			constant		Y_range															:		integer	range 0 to 1024		:= 984;											-- Moving Range for Y
			constant		lange																:		integer range 0 to 40			:= 40;											-- MAX SNAKE Length
			
		-- Declarations Signal
			signal 			Move_Direction											:		Direction := Rechts;																	-- Current Moving Direction
			

			signal			BTN_LEFT_SYNC												:		std_logic_vector (1 downto 0)	:= "11";								-- Vektor for Syncing
			signal			BTN_RIGHT_SYNC											:		std_logic_vector (1 downto 0)	:= "11";								-- Vektor for Syncing
			signal			BTN_RESET_SYNC											:		std_logic_vector (1 downto 0)	:= "11";								-- Vektor for Syncing
			signal			Update_Sig													:		std_logic	:= '0';																			--The update signal is responsible for updating the position of the snake. 
			signal			CLK_ENA_Easy												:		std_logic := '0';																			-- Enabel Signal for CLK DIivder Easy
			signal			CLK_ENA_Mid													:		std_logic := '0';																				-- Enabel Signal for CLK DIivder Medium
			signal			CLK_ENA_Hard												:		std_logic := '0';																			-- Enabel Signal for CLK DIivder Hard
			signal			CLK_ENA_1														:		std_logic := '0';	
			signal			Update_length												:		std_logic	:=	'0';																		-- Signale for Update Snake Length
			signal			Test																:		integer	range	0	to 40	:= 2;														-- Current Snake Length
			
			signal			TB_xsnake														:		x_pos_arr := (0,0,others => 1900);
			signal			TB_ysnake														:		y_pos_arr := (0,0,others => 1900);
				
begin


		/*CLK_DIV Instantiations start*/
		CLK_DIV	:	if Simulation	= false generate
		/*Easy Mode*/
		CLK_div1_Easy	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX_Easy)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_Easy);
			
		/*Medium Mode*/	
		CLK_div1_Medium	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX_Mid)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_Mid);
			
			
		
		/*Hard Mode*/
		CLK_div1_Hard	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX_Hard)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_Hard);
			
			end generate Clk_DIV;
			
		Simu_CLK_DIV	:	if SImulation	= true	generate
		
					CLK_div1_Easy	:	entity work.GEN_Clockdivider
					generic map(
						
					CNT_MAX => CLK_div1_MAX_Simu)
					port map(
					
						CLK  		=> 	vga_clk,
						RST			=>	Reset,
						Enable	=>	CLK_ENA_Hard);
					
		end generate Simu_CLK_DIV;
	/*CLK_DIV Instantiation end*/
	
	Snake_drawing	: process	(all)
	
		begin
				-- Concurrent Signal Assignment (optional)
				
				if rising_edge(vga_clk) then
					
					/*TB Hilfssignale*/
					TB_xsnake	<= x_snake;
					TB_ysnake	<= y_snake;
					
					Draw_Snake 				<= 	'0';
					
					if Add_Snake	= '1'	then
						Update_length	<= '1';
					end if;
					
					/*Buttons Synchronisieren*/
					BTN_LEFT_SYNC(0) <= BTN_LEFT;
					BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
					
					BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
					BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
					
					BTN_RESET_SYNC(0) <= Reset;
					BTN_RESET_SYNC(1) <= BTN_RESET_SYNC(0);
					
					
					/*Default Values befor a new game Starts*/
					if Game_state = startscreen	then
						Test	<= 2;
						Move_Direction	<= Rechts;
						x_snake <= (others 		=>	1900);
						y_snake	<= (others		=>	1900);
						x_snake(0)	<= 	40;
						x_snake(1)	<=	0;
						y_snake(0)	<= 	0;
						y_snake(1)	<=	0;
					end if;
					/*Default Values befor a new game Starts END*/
					
					/*Select degree of difficulty*/

						case Game_Difficulty	is
							when	Easy							=>	CLK_ENA_1	<=	CLK_ENA_Easy;
							when	Medium						=>	CLK_ENA_1	<=	CLK_ENA_Mid;					
							when	Hard							=>	CLK_ENA_1	<=	CLK_ENA_Hard;
							when	others						=>	CLK_ENA_1	<=	CLK_ENA_Mid;			-- Deafult is Medium
						end case;
						
					/*Select degree of difficulty END*/
					
					/*Actual Game Logic*/
					if Game_state	= Game then
						
						/*Check for need to Update Snake*/
						case CLK_ENA_1 is
							when '1'							=>	Update_sig	<= '1';
							when others						=>	Null;
						end case;
						
						/*Function call for changing directions*/
						Move_Direction <= Movement(BTN_RIGHT_SYNC(1 downto 0), BTN_LEFT_SYNC(1 downto 0), Move_Direction);	

						
						/*Das Zeichen fÃ¼r das Zeichnen der schlange wird hier erzeugt*/
						for i in 1 to lange	loop
							if xpos_snake	> x_snake(i) and xpos_snake < (x_snake(i)+40) then
								if ypos_snake > y_snake(i) and ypos_snake < (y_snake(i)+40) then -- Quadrat
									Draw_Snake <= '1';
								end if;
							end if;
						end loop;
						
						/*Das Zeichen fÃ¼r das Zeichnen der schlange wird hier erzeugt END*/
						
						
						/*Update Snake*/
						if Update_sig = '1' then
							Update_sig <= '0';
							
							/*Check for Snake Growing*/
							
							if Update_length = '1' then
								Test <= Test + 1;
								Update_length	<= '0';
							end if;
							
							/*Check for Snake Growing END*/
							
							/*Snake moving*/
							for i in 1 to lange loop
								if	i < Test	then
									x_snake(i)	<=	x_snake(i-1);
									y_snake(i)	<=	y_snake(i-1);	
								end if;
							end loop;

							case Move_Direction is
								when Links								=> 	x_snake(0) <=	x_snake(0) - stepsize_x;
																							y_snake(0) <= y_snake(0);
																							/*Detection for Left Screen Border*/
																							if x_snake(0) < 40 then
																								x_snake(0) <= x_range;
																							end if;
																						
								when Rechts								=> 	x_snake(0) <=	x_snake(0) + stepsize_x;
																							y_snake(0) <= y_snake(0);
																							/*Detection for Right Screen Border*/
																							if x_snake(0) > (x_range-40)	then
																								x_snake(0) <= 0;
																							end if;
																						
								when Up										=> 	y_snake(0)	<=	y_snake(0) - stepsize_y;
																							x_snake(0)	<=	x_snake(0);
																							/*Detection for Upper Screen Border*/
																							if	y_snake(0) < 40	then
																								y_snake(0)	<= y_range;
																							end if;
																							
								when Down									=> 	y_snake(0)	<=	y_snake(0) + stepsize_y;
																							x_snake(0)	<=	x_snake(0);
																							/*Detection for lower Screen Border*/
																							if y_snake(0) > (y_range-40)	then
																								y_snake(0)	<= 0;
																							end if;
																							
								when others								=> Null;
							end case;
							/*Snake moving END*/
						end if;
						/*Update Snake*/
					end if;
					/*Actual Game Logic END*/
				end if; -- rising_edge vga_clk 
		end process Snake_drawing;
end beh_snake_drawing;