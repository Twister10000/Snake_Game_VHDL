library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

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
			Draw_Snake							: out 	std_logic := '0'
	);
end snake_drawing;

architecture beh_snake_drawing of snake_drawing is

	-- Declarations (optional)
		-- Declarations Own Var Types
			type 				Direction						is	(Right, Left, UP, Down);
			
		-- Constants
			constant 		CLK_div1_MAX					:		integer range 0 to 108e6 	:= 27e6; 		-- CLK MAX COUNTER
			constant		X_Stepsize						:		integer range 0 to 128		:= 40;			-- Wie viel sich der Balken bewegen darf
			constant		Y_Stepsize						:		integer range 0 to 128		:= 41;	
			constant		X_range								:		integer	range 0	to 1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
			constant		Y_range								:		integer	range 0 to 1024		:= 984;
			
			
		-- Declarations Signal
			signal 			Move_Direction						:		Direction := Right;
			signal			SQ_xpos_snake_sig					:		integer	range 0 to 1240 := 0;
			signal			SQ_ypos_snake_sig					:		integer range 0 to 1024	:= 0;
			signal			BTN_LEFT_SYNC							:		std_logic_vector (1 downto 0);
			signal			BTN_RIGHT_SYNC						:		std_logic_vector (1 downto 0);
			signal			Update_Sig								:		std_logic	:= '0';																			--The update signal is responsible for updating the position of the snake. 
			signal			CLK_ENA_1									:		std_logic := '0';
				
begin


		/*CLK_DIV Instantiation*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX)
		port map(
		
			CLK  		=> 	vga_clk,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_1);
	
	Snake_drawing	: process	(all)
	
		begin
				-- Concurrent Signal Assignment (optional)
				
				if rising_edge(vga_clk) then
					BTN_LEFT_SYNC(0) <= BTN_LEFT;
					BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
					
					BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
					BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
					
					Draw_Snake 	<= 	'0';
					
					case CLK_ENA_1 is
						when '1'							=>	Update_sig	<= '1';
						when others						=>	Update_sig	<= Update_Sig;
					end case;
							
							/*FSM Direction*/ -- Update to Switch Case Statements!!!!
							if BTN_RIGHT_SYNC(1) = '0' and BTN_RIGHT_SYNC(0) = '1' then
								case Move_Direction is
									when Right			=>	Move_Direction <= Left;
									when Left				=>	Move_Direction <= Right;
									when Up					=>	Move_Direction <= Right;
									when Down				=>	Move_Direction <= Left;
									when others			=>	Move_Direction <= Move_Direction;
								end case;

							elsif BTN_LEFT_SYNC(1) = '0' and BTN_LEFT_SYNC(0) = '1' then
								
								case Move_Direction is
									when Up								=>	Move_Direction	<= Down;
									when Down							=>	Move_Direction	<= Up;
									when Left							=>	Move_Direction	<= Up;
									when Right						=>	Move_Direction	<= Down;
									when others						=>	Move_Direction	<= Move_Direction;
								end case;
							
							end if;
							/*FSM Direction END*/
				
					if videoOn_snake = '1' then
						
						if xpos_snake	> SQ_xpos_snake_sig and xpos_snake < (SQ_xpos_snake_sig+40) then
							if ypos_snake > SQ_ypos_snake_sig and ypos_snake < (SQ_ypos_snake_sig+40) then -- Quadrat
								Draw_Snake <= '1';
							end if;
						end if;
					end if;
					/*FSM Moving*/ -- Update to Switch Case Statements!!!!
					if NewFrame_snake = '1' then
						if Update_sig = '1' then
							Update_sig <= '0';
							case Move_Direction is
								when Left								=> 	SQ_xpos_snake_sig	<= SQ_xpos_snake_sig - X_Stepsize;
																						if sq_xpos_snake_sig = 0 then
																							SQ_xpos_snake_sig	<= x_Range;
																						end if;
								when Right							=> 	SQ_xpos_snake_sig	<= SQ_xpos_snake_sig + X_Stepsize;
																						if SQ_xpos_snake_sig >= x_Range then
																							SQ_xpos_snake_sig	<= 0;
																						end if;
								when Up									=> 	SQ_ypos_snake_sig <= SQ_ypos_snake_sig - Y_Stepsize;
																						if SQ_ypos_snake_sig = 0 then
																							SQ_ypos_snake_sig <= y_Range;
																						end if;
								when Down								=> SQ_ypos_snake_sig <= SQ_ypos_snake_sig + Y_Stepsize;
																						if SQ_ypos_snake_sig >= y_range then
																							SQ_ypos_snake_sig <= 0;
																						end if;
								when others							=> Null;
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
