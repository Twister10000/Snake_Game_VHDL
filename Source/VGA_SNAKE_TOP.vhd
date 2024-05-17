-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.Game_State_PKG.all;

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
		-- Declarations Constant
		constant MAX_Y : integer := 6; -- number of Pixels in y dir
		constant MAX_X : integer := 6; -- number of Pixels in x dir
		
		-- Declarations Own Var Types
		type graphicsRGB is array (0 to MAX_x-1,0 to MAX_Y-1) of std_logic_vector(3 downto 0);

		-- Declarations Signal
		signal			xpos_top     							:  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
		signal			ypos_top     							:  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich	
		signal			videoOn_top  							:  	std_logic;               							-- 1 = Bildbereich
		signal			vga_clk										:		std_logic;
		signal			NewFrame_top							:		std_logic;
		signal			Game_On										:		std_logic := '0';
		signal			Draw_Snake								:		std_logic	:= 	'0';
		signal			Draw_Snake_Zero						:		std_logic	:= 	'0';
		signal			Draw_Apple								:		std_logic	:=	'0';
		signal			BTN_RESET_SYNC									:		std_logic_vector (1 downto 0);

		
		-- Declarations BoxGraphics
		signal			BoxGraphics_R							:	graphicsRGB	:=(
															(x"F", x"F", x"F", x"F", x"F", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"F", x"F", x"F", x"F", x"F"));
		signal			BoxGraphics_G							:	graphicsRGB	:=(
															(x"F", x"F", x"F", x"F", x"F", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"F", x"F", x"F", x"F", x"F"));
		signal			BoxGraphics_B							:	graphicsRGB	:=(
															(x"F", x"F", x"F", x"F", x"F", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"0", x"0", x"0", x"0", x"F"),
															(x"F", x"F", x"F", x"F", x"F", x"F"));
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
					
		/*Game_Main Instantiation*/
		
		Game_Main	:	entity	work.Game_Main
			port map (
					xpos_game     						=>	xpos_top,
					ypos_game     						=>	ypos_top,
					BTN_LEFT									=>	BTN_LEFT,
					BTN_RIGHT									=>	BTN_RIGHT,
					videoOn_game  						=>	videoOn_top,
					vga_clk										=>	vga_clk,
					NewFrame_game							=>	NewFrame_top,
					Draw_Snake_Out						=>	Draw_Snake,
					Draw_Snake_Zero_Out				=>	Draw_Snake_Zero,
					Draw_Apple_Out						=>	Draw_Apple,
					Reset											=>	Reset);
		
	-- Process Statement (optional)
		Drawing	:	process(all)
		
		begin
		
			if rising_edge(vga_clk) then
				
				R <= x"0";
				G <= x"0";
				B	<= x"0";
				Game_On	<=	'0';
				BTN_RESET_SYNC(0) <= Reset;
				BTN_RESET_SYNC(1) <= BTN_RESET_SYNC(0);
					

				if videoOn_top = '1' then
					
					case	Game_State	is
						when	Startscreen		=> B <= x"F";
						when	Game					=> Game_On <= '1';
						when	Endscreen			=> R <= x"F";	
						when	others				=> Null;					
					end case;
					
					if Game_State = Startscreen then
						
						if xpos_top	>= 300 and xpos_top < 300 + MAX_X then
							if	ypos_top >= 412 and ypos_top	< 412 + MAX_Y	then
								R <=	BoxGraphics_R(ypos_top - 412, xpos_top - 300);
								G	<=	BoxGraphics_G(ypos_top - 412, xpos_top - 300);
								B	<=	BoxGraphics_B(ypos_top - 412, xpos_top - 300);
							end if;
						
						end if;
						
					end if;
					
					
					if xpos_top = 640 then
						R <= x"F";
					end if;
					if Game_On	= '1' then
						if Draw_Snake = '1' then -- Schlange zeichnen
							G <= x"F";
						end if;
						if Draw_Snake_Zero = '1' then -- Schlange zeichnen
							G <= x"F";
						end if;
						if	Draw_Apple	= '1'	then
							R <= x"F";
						end if;
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