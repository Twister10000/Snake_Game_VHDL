-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
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
			BTN_LEFT					:	in	 	std_logic;
			BTN_RIGHT					:	in	 	std_logic;
			videoOn_snake  					:	in  	std_logic;               							-- 1 = Bildbereich
			vga_clk									:	in		std_logic;
			CLK_ENA_1								:	in		std_logic;
			NewFrame_snake					:	in		std_logic;
			--SQ_xpos_snake									:	in		integer range 0 to 1240 := 0;
			--SQ_ypos_snake									:	in	 	integer range 0 to 1024 := 0;
			Update									:	in		std_logic := '0'; 										--The update signal is responsible for updating the position of the snake. 


		-- Inout ports


		-- Output ports
			Draw_Snake							: out 	std_logic := '0'
	);
end snake_drawing;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture beh_snake_drawing of snake_drawing is

	-- Declarations (optional)
		-- Declarations Own Var Types
			type 				Direction						is	(Right, Left, UP, Down);
		-- Constants
			constant		X_Stepsize						:		integer range 0 to 128		:= 40;			-- Wie viel sich der Balken bewegen darf
			constant		Y_Stepsize						:		integer range 0 to 128		:= 41;	
			constant		X_range								:		integer	range 0	to 1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
			constant		Y_range								:		integer	range 0 to 1024		:= 984;
			
			
		-- Declarations Signal
			signal 			Move_Direction						:		Direction := Right;
			signal			BTN_LEFT_SYNC							:		std_logic_vector (1 downto 0);
			signal			BTN_RIGHT_SYNC						:		std_logic_vector (1 downto 0);
			signal			Update_Sig								:		std_logic	:= '0';
			signal			SQ_xpos_snake_sig					:		integer	range 0 to 1240 := 0;
			signal			SQ_ypos_snake_sig					:		integer range 0 to 1024	:= 0;
				
begin

	
	Snake_drawing	: process	(all)
	
		begin
				-- Concurrent Signal Assignment (optional)
				
				
				
				if rising_edge(vga_clk) then
				
				
							BTN_LEFT_SYNC(0) <= BTN_LEFT;
							BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
							
							BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
							BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
							
							/*FSM Moving Direction*/
							if BTN_RIGHT_SYNC(1) = '0' and BTN_RIGHT_SYNC(0) = '1' then
							
								if Move_Direction = Right then
									Move_Direction <= Left;
								else
									Move_Direction <= Right;
								end if;
							elsif BTN_LEFT_SYNC(1) = '0' and BTN_LEFT_SYNC(0) = '1' then
								
								if Move_Direction = Up then
									
									Move_Direction <= Down;
								elsif Move_Direction = Down then
									Move_Direction <= Up;
								else 
									Move_Direction <= Up;
								end if;
							
							end if;
				
				
				
				
					Draw_Snake 	<= 	'0';
					if videoOn_snake = '1' then
						
						if xpos_snake	> SQ_xpos_snake_sig and xpos_snake < (SQ_xpos_snake_sig+40) then
							if ypos_snake > SQ_ypos_snake_sig and ypos_snake < (SQ_ypos_snake_sig+40) then -- Quadrat
								Draw_Snake <= '1';
							end if;
						end if;
					end if;
					
					if NewFrame_snake = '1' then
							if Update = '1' then
								--Update_sig <= '0';
								if Move_Direction = Left then
									SQ_xpos_snake_sig <= SQ_xpos_snake_sig - X_Stepsize;
									if sq_xpos_snake_sig = 0 then
										SQ_xpos_snake_sig	<= x_Range;
									end if;
								elsif Move_Direction = Right then
										SQ_xpos_snake_sig	<= SQ_xpos_snake_sig + X_Stepsize;
										if SQ_xpos_snake_sig >= x_Range then
											SQ_xpos_snake_sig	<= 0;
										end if;
								elsif Move_Direction = Up then
										SQ_ypos_snake_sig <= SQ_ypos_snake_sig - Y_stepsize;
										if SQ_ypos_snake_sig = 0 then
											SQ_ypos_snake_sig <= y_Range;
										end if;
								elsif	Move_Direction = Down then
										SQ_ypos_snake_sig <= SQ_ypos_snake_sig + Y_stepsize;
										
										if SQ_ypos_snake_sig >= y_range then
											SQ_ypos_snake_sig <= 0;
										end if;
								else
									
								end if;
							end if;
						end if;
					
					
				end if;
		
		end process Snake_drawing;
	
	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_snake_drawing;
