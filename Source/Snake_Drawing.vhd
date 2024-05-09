library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity snake_drawing is
	
	port
	(
		-- Input ports
			xpos_snake     					:	in  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
			ypos_snake     					:	in  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
			BTN_LEFT								:	in	 	std_logic;
			BTN_RIGHT								:	in	 	std_logic;
			Reset										:	in		std_logic;
			videoOn_snake  					:	in  	std_logic;               							-- 1 = Bildbereich
			vga_clk									:	in		std_logic;
			NewFrame_snake					:	in		std_logic;

		-- Inout ports


		-- Output ports
			Draw_Snake							: out 	std_logic := 	'0'
	);
end snake_drawing;

architecture beh_snake_drawing of snake_drawing is

	-- Declarations (optional)
		-- Declarations Own Var Types
			type 				Direction						is	(Rechts, Links, UP, Down);
			type 				x_pos_arr 					is array (0 to 41/*Nachrechnen*/) of integer range -100 to 1280;
			type 				y_pos_arr 					is array (0 to 40/*Nachrechnen*/) of integer range -100 to 1024;
			
		-- Constants
			constant 		CLK_div1_MAX					:		integer range 0 to 108e6 	:= 56e6;--27e6; 		-- CLK MAX COUNTER
			constant		Stepsize_x						:		integer range 0 to 128		:= 40;			-- Wie viel sich der Balken bewegen darf
			constant		Stepsize_y						:		integer range 0 to 128		:= 41;	
			constant		X_range								:		integer	range 0	to 1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
			constant		Y_range								:		integer	range 0 to 1024		:= 984;
			
			
		-- Declarations Signal
			signal 			Move_Direction									:		Direction := Rechts;
			signal			BTN_LEFT_SYNC										:		std_logic_vector (1 downto 0);
			signal			BTN_RIGHT_SYNC									:		std_logic_vector (1 downto 0);
			signal			Update_Sig											:		std_logic	:= '0';																			--The update signal is responsible for updating the position of the snake. 
			signal			CLK_ENA_1												:		std_logic := '0';
			signal 			x_snake													:	x_pos_arr := (others => 0);
			signal 			y_snake													:	y_pos_arr := (others => 0);
			signal			lange														:		integer range 0 to 50	:= 2;
				
begin


		/*CLK_DIV Instantiation start*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_1);
	/*CLK_DIV Instantiation end*/
	
	Snake_drawing	: process	(all)
	
		begin
				-- Concurrent Signal Assignment (optional)
				
				if rising_edge(vga_clk) then
					
					/*Buttons Synchronisieren*/
					BTN_LEFT_SYNC(0) <= BTN_LEFT;
					BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
					
					BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
					BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
					
					Draw_Snake 	<= 	'0';			
					
					case CLK_ENA_1 is
						when '1'							=>	Update_sig	<= '1';
						when others						=>	Null;
					end case;
							
							/*FSM Direction*/
							if BTN_RIGHT_SYNC(1) = '0' and BTN_RIGHT_SYNC(0) = '1' then
								case Move_Direction is
									when Rechts							=>	Move_Direction <= Links; --Right and Left wechseln!
									when Links							=>	Move_Direction <= Rechts;
									when Up									=>	Move_Direction <= Rechts;
									when Down								=>	Move_Direction <= Links;
									when others							=>	Null;
								end case;

							elsif BTN_LEFT_SYNC(1) = '0' and BTN_LEFT_SYNC(0) = '1' then
								
								case Move_Direction is
									when Up									=>	Move_Direction	<= Down;
									when Down								=>	Move_Direction	<= Up;
									when Links							=>	Move_Direction	<= Up;
									when Rechts							=>	Move_Direction	<= Down;
									when others							=>	Null;
								end case;
							
							end if;
							/*FSM Direction END*/
				
					if videoOn_snake = '1' then		
						
						for i in 0 to lange	loop
							if xpos_snake	> x_snake(i) and xpos_snake < (x_snake(i)+40) then
								if ypos_snake > y_snake(i) and ypos_snake < (y_snake(i)+40) then -- Quadrat
									Draw_Snake <= '1';
								end if;
							end if;
						end loop;
					end if;
					/*FSM Moving*/ -- Update to Switch Case Statements!!!!
					if NewFrame_snake = '1' then
						if Update_sig = '1' then
							Update_sig <= '0';
							
							for i in 1 to lange loop
								x_snake(i)	<=	x_snake(i-1);
								y_snake(i)	<=	y_snake(i-1);	
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
						end if;
						
						

						
					end if;
					/*FSM Moving ENDE*/
					
					
					
				end if;
		
		end process Snake_drawing;
	
	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_snake_drawing;
