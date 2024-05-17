-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

package Movement_PKG is

	-- Type Declaration (optional)
				type 				Direction						is	(Rechts, Links, UP, Down);
				type 				x_pos_arr 					is array (0 to 41/*Nachrechnen*/) of integer range -100 to 2000;
				type 				y_pos_arr 					is array (0 to 40/*Nachrechnen*/) of integer range -100 to 2000;

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Signal Declaration (optional)
			signal 			x_snake													:	x_pos_arr := (0,0,others => 1900);
			signal 			y_snake													:	y_pos_arr := (0,0,others => 1900);
	-- Component Declaration (optional)
		function	Movement	(BTN_Right	:	std_logic_vector	(1 downto 0);
											 BTN_Left		:	std_logic_vector	(1 downto 0);
											 Current_Move	: Direction) return Direction;

end Movement_PKG;

package body Movement_PKG is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Function Declaration (optional)
	
		/*FSM Direction END*/
		function	Movement	(BTN_Right	:	std_logic_vector	(1 downto 0);
												BTN_Left		:	std_logic_vector	(1 downto 0);
												Current_Move	: Direction) return Direction	is
		
			begin
				if BTN_RIGHT(1) = '0' and BTN_RIGHT(0) = '1' then
					case Current_Move is
						when Rechts							=>	return Links; --Right and Left wechseln!
						when Links							=>	return Rechts;
						when Up									=>	return Rechts;
						when Down								=>	return Links;
						when others							=>	return Current_Move;
					end case;
	
				elsif BTN_LEFT(1) = '0' and BTN_LEFT(0) = '1' then
					
					case Current_Move is
						when Up									=>	return Down;
						when Down								=>	return Up;
						when Links							=>	return Up;
						when Rechts							=>	return Down;
						when others							=>	return Current_Move;
					end case;
				else
					return Current_Move;
				end if;
				/*FSM Direction END*/
		end function;

	-- Function Body (optional)

	-- Procedure Declaration (optional)

	-- Procedure Body (optional)

end Movement_PKG;
