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
end Game_Main;

architecture beh_Game_Main of Game_Main is

	-- Declarations (optional)
	-- Signal Declarations
	
	signal 			Draw_Apple_In						:	std_logic	:= '0';
	signal 			Draw_Snake_In						:	std_logic	:= '0';	

begin

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Game_Main;

