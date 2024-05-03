-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity VGA_SNAKE_TOP is

	port
	(
		-- Input ports
			clk  					: 		in   	std_logic;                 -- vga clock 
			Reset    			: 		in   	std_logic;                 -- 1 = Reset
			BTN_LEFT    	:			in 		std_logic;
			BTN_RIGHT			:			in 		std_logic;

		-- Inout ports


		-- Output ports
		hsync_top    	: 		out  	std_logic;                 											-- Hsync Monitor
		vsync_top    	: 		out		std_logic;                 											-- Vsync Monitor
		R							:			out		std_logic_vector(3 downto 0);
		G							:			out		std_logic_vector(3 downto 0);
		B							:			out		std_logic_vector(3 downto 0)

	);
end VGA_SNAKE_TOP;


architecture VGA_DEMO_TOP of VGA_SNAKE_TOP is
		-- Declarations Own Var Types

		-- Declarations Constant

		-- Declarations Signal

		signal			xpos_top     					:  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
		signal			ypos_top     					:  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich	
		signal			videoOn_top  					:  	std_logic;               							-- 1 = Bildbereich
		signal			vga_clk								:		std_logic;
		signal			NewFrame_top					:		std_logic;
		signal			Draw_Snake						:		std_logic	:= '0';

begin
		/*VGA_SYNC Instantiation*/
	 VGA_SYNC : entity work.vga_sync
		
			port map(
				vga_clk	=> 	vga_clk,
				Reset		=>	Reset,
				hsync		=>	hsync_top,
				vsync		=>	vsync_top,
				xpos		=>	xpos_top,
				ypos		=>	ypos_top,
				NewFrame => NewFrame_top,
				videoOn	=>	videoOn_top);
				
		/*PLL Instantiation*/		
		PLL1	:	entity work.pll
		
		port map(
			
			inclk0 	=> clk,
			c0			=> vga_clk);
					
		/*Snake_Drawing Instantiation*/
		
		Snake_Drawing	:	entity	work.snake_Drawing
			port map (
					xpos_snake     				=>	xpos_top,
					ypos_snake     				=>	ypos_top,
					BTN_LEFT							=>	BTN_LEFT,
					BTN_RIGHT							=>	BTN_RIGHT,
					videoOn_snake  				=>	videoOn_top,
					vga_clk								=>	vga_clk,
					NewFrame_snake				=>	NewFrame_top,
					Draw_Snake						=>	Draw_Snake,
					Reset									=>	Reset);
		
	-- Process Statement (optional)
		Drawing	:	process(all)
		
		begin
		
			if rising_edge(vga_clk) then
				
				R <= x"0";
				G <= x"0";
				B	<= x"0";
				
				if videoOn_top = '1' then
					
					if xpos_top = 640 then
						R <= x"F";
					end if;
					
					if Draw_Snake = '1' then -- Schlange zeichnen
						G <= x"F";
					end if;
					if ypos_top	= 512 then
						B	<= x"F";
						R <= x"8";
					end if;
					if ypos_top = 0 then
						R		<= x"F";
						G		<= x"F";
						B		<= x"F";
					end if;
				end if;
			end if;
		end process Drawing;
		
	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end VGA_DEMO_TOP;