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
			clk  				: 		in   	std_logic;                 -- vga clock 
			Reset    		: 		in   	std_logic;                 -- 1 = Reset
			BTN_LEFT    :			in 		std_logic;
			BTN_RIGHT		:			in 		std_logic;

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
		-- Declarations Constant
		constant 		CLK_div1_MAX				:		integer range 0 to 108e6 	:= 1e6; 		-- CLK MAX COUNTER
		constant		Stepsize						:		integer range 0 to 500		:= 10;			-- Wie viel sich der Balken bewegen darf
		constant		move_range					:		integer	range 0	to 1280		:= 1130;		-- Von wo bis wo darf sich der Balken bewegen
		-- Declarations Signal

		signal			xpos_top     				:  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
		signal			ypos_top     				:  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
		signal			Move								:		integer range 0 to move_range := 0;
		signal			BTN_LEFT_SYNC				: 	std_logic_vector (1 downto 0);
		signal			BTN_RIGHT_SYNC			: 	std_logic_vector (1 downto 0);		
		signal			videoOn_top  				:  	std_logic;               							-- 1 = Bildbereich
		signal			vga_clk							:		std_logic;
		signal			CLK_ENA_1						:		std_logic;
		
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
				videoOn	=>	videoOn_top);
				
		/*PLL Instantiation*/		
		PLL1	:	entity work.pll
		
		port map(
			
			inclk0 	=> clk,
			c0			=> vga_clk);
		
		/*CLK_DIV Instantiation*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX)
		port map(
		
			CLK  		=> 	CLK,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_1);
	-- Process Statement (optional)
		process(all)
		
		begin
		
			if rising_edge(vga_clk) then
				
				R <= x"0";
				G <= x"0";
				B	<= x"0";
				
				if videoOn_top = '1' then
					
					if xpos_top = 640 then
						R <= x"F";
					end if;
					if xpos_top	>= 1+Move and xpos_top < 150+Move then
						if ypos_top >= 100 and ypos_top < 150 then -- Quadrat
							G <= x"F";
							
						end if;
					end if;
					if ypos_top	= 512 then
						B	<= x"F";
						R <= x"8";
					end if;
				end if;
			end if;
		end process;
		
		Box_Mov : process (all)
		
		begin
				
				if rising_edge (vga_clk) then
						if videoOn_top = '0' then
							
							
							BTN_LEFT_SYNC(0) <= BTN_LEFT;
							BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
							
							BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
							BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
							if CLK_ENA_1 = '1'	then
								if BTN_LEFT_SYNC(1) = '0' then
									Move <= Move - Stepsize;
									if move >= move_range then
										move <= 0;
									end if;
								elsif BTN_RIGHT_SYNC(1) = '0' then
										move	<= move + stepsize;
										
										if move >= move_range then
											move	<= 0;
										end if;
								else
									
								end if;
							end if;
						end if;
						
						
				end if;
		end process Box_Mov;
		
	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end VGA_DEMO_TOP;