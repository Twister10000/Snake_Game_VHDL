-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

package Game_State_PKG is

	-- Type Declaration (optional)
		type 				Game_FSM						is	(Startscreen, Game, Endscreen);  	-- FSM for Game-State
		type				Game_Level					is	(Easy,	Medium, Hard);
	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Signal Declaration (optional)
		signal			Game_State				:	Game_FSM 		:= Startscreen;							-- Signal for current Game_State
		
		
		attribute syn_encoding 								: string;
		attribute syn_encoding of Game_FSM 		: type is "safe"; 


		signal			Game_Difficulty						:	Game_Level	:= Hard;
		--attribute syn_encoding 								: string;
		attribute syn_encoding of Game_Level 	: type is "safe"; 	
	-- Component Declaration (optional)

end Game_State_PKG;

