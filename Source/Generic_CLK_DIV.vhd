-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity GEN_Clockdivider is
	generic
	(
		
		CNT_MAX : integer range 0 to 108e6  := 108e6);


	port
	(
		-- Input ports
		CLK	: in  std_logic;
		RST	:	in 	std_logic;


		-- Inout ports


		-- Output ports
		Enable	: out std_logic);
end GEN_Clockdivider;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture Beh_GEN_Clockdivider of GEN_Clockdivider is

	-- Declarations (optional)
		signal	Divider					:	integer range 0 to CNT_MAX+1;
		
begin
		CLK_DIV	: process(all)
		begin
					
					if rising_edge(CLK)	then
						
						if RST = '0' then
							Divider <= 0;
						end if;
						
						Divider 		<= Divider + 1;
						
						if Divider	= CNT_MAX then
							Divider 	<= 0;
						end if;
						
						if Divider 	= 0 then
							Enable 		<= '1';
						else
							Enable		<= '0';
						end if;
					end if;

		end process CLK_DIV;
	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end Beh_GEN_Clockdivider;

