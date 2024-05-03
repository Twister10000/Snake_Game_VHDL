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
		type 				Direction						is	(Right, Left, UP, Down);

		-- Declarations Constant
		constant 		CLK_div1_MAX					:		integer range 0 to 108e6 	:= 13e6; 		-- CLK MAX COUNTER
		--constant		X_Stepsize						:		integer range 0 to 128		:= 40;			-- Wie viel sich der Balken bewegen darf
		--constant		Y_Stepsize						:		integer range 0 to 128		:= 41;	
		--constant		X_range								:		integer	range 0	to 1280		:= 1240;		-- Von wo bis wo darf sich der Balken bewegen
		--constant		Y_range								:		integer	range 0 to 1024		:= 984;
		-- Declarations Signal

		signal			xpos_top     					:  	integer range 0 to 1300;   						-- Pixel Pos x Bildbereich
		signal			ypos_top     					:  	integer range 0 to 1033;    					-- Pixel Pos y Bildbereich
		--signal			SQ_xpos								:		integer range 0 to x_range := 0;
		--signal			SQ_ypos								: 	integer range 0 to y_range := 0;
		signal			BTN_LEFT_SYNC					: 	std_logic_vector (1 downto 0);
		signal			BTN_RIGHT_SYNC				: 	std_logic_vector (1 downto 0);		
		signal			videoOn_top  					:  	std_logic;               							-- 1 = Bildbereich
		signal			vga_clk								:		std_logic;
		signal			CLK_ENA_1							:		std_logic;
		signal			NewFrame_top					:		std_logic;
		signal 			Update								:		std_logic := '0'; 										--The update signal is responsible for updating the position of the snake. 
		signal			Draw_Snake						:		std_logic	:= '0';
		signal			Move_Direction				:		Direction := Right;

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
		
		/*CLK_DIV Instantiation*/
		CLK_div1	:	entity work.GEN_Clockdivider
		generic map(
			
		CNT_MAX => CLK_div1_MAX)
		port map(
		
			CLK  		=> 	CLK,
			RST			=>	Reset,
			Enable	=>	CLK_ENA_1);
			
			
		/*Snake_Drawing Instantiation*/
		
		Snake_Drawing	:	entity	work.snake_Drawing
			port map (
					xpos_snake     				=>	xpos_top,
					ypos_snake     				=>	ypos_top,
					BTN_LEFT							=>	BTN_LEFT,
					BTN_RIGHT							=>	BTN_RIGHT,
					videoOn_snake  				=>	videoOn_top,
					vga_clk								=>	vga_clk,
					CLK_ENA_1							=>	CLK_ENA_1,
					NewFrame_snake				=>	NewFrame_top,
					Draw_Snake						=>	Draw_Snake,
					--SQ_xpos_snake					=>	SQ_xpos,
					--SQ_ypos_snake					=>	SQ_ypos,
					Update								=>	Update);
		
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
		
		Box_Mov : process (all)
		
		begin
				if rising_edge (vga_clk) then
					if CLK_ENA_1 = '1' then
						Update <= '1';
					end if;
							--BTN_LEFT_SYNC(0) <= BTN_LEFT;
							--BTN_LEFT_SYNC(1) <= BTN_LEFT_SYNC(0);
							--
							--BTN_RIGHT_SYNC(0) <= BTN_RIGHT;
							--BTN_RIGHT_SYNC(1) <= BTN_RIGHT_SYNC(0);
							--
							--/*FSM Moving Direction*/
							--if BTN_RIGHT_SYNC(1) = '0' and BTN_RIGHT_SYNC(0) = '1' then
							--
							--	if Move_Direction = Right then
							--		Move_Direction <= Left;
							--	else
							--		Move_Direction <= Right;
							--	end if;
							--elsif BTN_LEFT_SYNC(1) = '0' and BTN_LEFT_SYNC(0) = '1' then
							--	
							--	if Move_Direction = Up then
							--		
							--		Move_Direction <= Down;
							--	elsif Move_Direction = Down then
							--		Move_Direction <= Up;
							--	else 
							--		Move_Direction <= Up;
							--	end if;
							--
							--end if;
							
							/*BOX_MOVEMENT PART*/
						if NewFrame_top = '1' then
							if Update = '1' then
								Update <= '0';
							end if;
						end if;
						--		if Move_Direction = Left then
						--			sq_xpos <= sq_xpos - X_Stepsize;
						--			if sq_xpos = 0 then
						--				sq_xpos	<= x_Range;
						--			end if;
						--		elsif Move_Direction = Right then
						--				sq_xpos	<= sq_xpos + X_Stepsize;
						--				if sq_xpos >= x_Range then
						--					sq_xpos	<= 0;
						--				end if;
						--		elsif Move_Direction = Up then
						--				sq_ypos <= sq_ypos - Y_stepsize;
						--				if sq_ypos = 0 then
						--					sq_ypos <= y_Range;
						--				end if;
						--		elsif	Move_Direction = Down then
						--				sq_ypos <= sq_ypos + Y_stepsize;
						--				
						--				if sq_ypos >= y_range then
						--					sq_ypos <= 0;
						--				end if;
						--		else
						--			
						--		end if;
						--	end if;
						--end if;
				end if;
		end process Box_Mov;
		
	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end VGA_DEMO_TOP;