library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SSegment IS									
	PORT(					
        CLK      :  IN STD_LOGIC;   
				BCD_In   :  IN character;	
				Segment  : 	OUT STD_LOGIC_VECTOR(6 DOWNTO 0)			
		);																	
END SSegment;
--------------------------------------------------------------------
--                 Architecture of SSegment
--------------------------------------------------------------------

ARCHITECTURE Beh_SSegment OF SSegment IS			-- Counter = Entity Name
	signal SegmentInt  :  STD_LOGIC_VECTOR(6 DOWNTO 0)	;
BEGIN


	print_to_seg	:	process (all)
	
	begin
		if rising_edge(CLK)	then
		
			Case	BCD_In	is
				when	'e'					=>		Segment	<=	"0000110";
				when	'a'					=>		Segment	<=	"0001000";
				when	's'					=>		Segment	<=	"0010010";
				when	'y'					=>		Segment	<=	"0011001";
				when	'h'					=>		Segment	<=	"0001001";
				when	'r'					=>		Segment	<=	"1001110";
				when	'd'					=>		Segment	<=	"0100001";
				when	'o'					=>		Segment	<=	"1000000";
				when	'n'					=>		Segment	<=	"0101011";
				when	others				=>		Segment	<= (others	=>	'1');
			end case;
			
		end if;
	end process print_to_seg;
END Beh_SSegment;
