-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package Movement_PKG is

	-- Type Declaration (optional)
				type 				Direction											is	(Rechts, Links, UP, Down);												-- FSM STate for Snake Direction
				type 				x_pos_arr 										is array (0 to 41) of integer range -100 to 2000;			-- Array for X Kordinate for Snake
				type 				y_pos_arr 										is array (0 to 40) of integer range -100 to 2000;			-- Array for Y Kordinate for Snake

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Signal Declaration (optional)
	
			signal 			x_snake													:	x_pos_arr := (0,0,others => 1900);									-- Signal for X Kordinate for Snake
			signal 			y_snake													:	y_pos_arr := (0,0,others => 1900);									-- Signal for Y Kordinate for Snake
	-- Component Declaration (optional)
	
	-- Function Declaration
		function	Movement	(	BTN_Right			:	std_logic_vector	(1 downto 0);																-- Function Declaration for Snake Control
													BTN_Left			:	std_logic_vector	(1 downto 0);
													Current_Move	: Direction) return Direction;

end Movement_PKG;

package body Movement_PKG is
	
		/*FSM Direction END*/
		function	Movement	(BTN_Right	:	std_logic_vector	(1 downto 0);
												BTN_Left		:	std_logic_vector	(1 downto 0);
												Current_Move	: Direction) return Direction	is
		
			begin
			
				/*FSM for Snake Controll*/
			
				if BTN_RIGHT(1) = '0' and BTN_RIGHT(0) = '1' then
					case Current_Move is
						when Rechts							=>	return Down; 
						when Links							=>	return Up;
						when Up									=>	return Rechts;
						when Down								=>	return Links;
						when others							=>	return Current_Move;
					end case;
	
				elsif BTN_LEFT(1) = '0' and BTN_LEFT(0) = '1' then
					
					case Current_Move is
						when Up									=>	return Links;
						when Down								=>	return Rechts;
						when Links							=>	return Down;
						when Rechts							=>	return Up;
						when others							=>	return Current_Move;
					end case;
				else
					return Current_Move;
				end if;
				/*FSM for Snake Controll END*/
		end function;
end Movement_PKG;