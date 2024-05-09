-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
entity Apple_Drawing is

	port
	(
		-- Input ports
		<name>	: in  <type>;
		<name>	: in  <type> := <default_value>;

		-- Inout ports
		<name>	: inout <type>;

		-- Output ports
		<name>	: out <type>;
		<name>	: out <type> := <default_value>
	);
end Apple_Drawing;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture beh_Apple_Drawing of Apple_Drawing is

	-- Declarations (optional)

begin

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end beh_Apple_Drawing;
