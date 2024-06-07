-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.Game_State_PKG.all;

USE work.packageText.ALL;
use work.PackagePrint.all;

entity VGA_SNAKE_TOP is
  generic (USE_PLL : boolean := true);
	port
	(
		-- Input ports
			clk  					: 		in   	std_logic;                 										-- 50Mhz CLOCK DE0 Board 
			Reset    			: 		in   	std_logic;                 										-- 1 = Reset Button 00
			BTN_LEFT    	:			in 		std_logic;								 										-- Button 02	
			BTN_RIGHT			:			in 		std_logic;																		-- Button 01
			SLD_EASY			:			in		std_logic;
			SLD_MID				:			in		std_logic;
			SLD_HARD			:			in		std_logic;

		-- Inout ports


		-- Output ports
		hsync_top    		: 		out  	std_logic;                 																					-- Hsync Monitor
		vsync_top    		: 		out		std_logic;                 																					-- Vsync Monitor
		R								:			out		std_logic_vector(3 downto 0);																				-- 4-Bit Vektor VGA RED
		G								:			out		std_logic_vector(3 downto 0);																				-- 4-Bit Vektor VGA GREEN
		B								:			out		std_logic_vector(3 downto 0);																				-- 4-Bit Vektor VGA BLUE
		Segment0       	: 		out 	std_logic_vector (6 downto 0)	:=	(others	=>	'1');           			-- 7 Segmentanzeige 
    Segment1       	: 		out 	std_logic_vector (6 downto 0)	:=	(others	=>	'1');           			-- 7 Segmentanzeige 
    Segment2       	: 		out 	std_logic_vector (6 downto 0)	:=	(others	=>	'1');           			-- 7 Segmentanzeige 
		Segment3				: 		out 	std_logic_vector (6 downto 0)	:=	(others	=>	'1')          				-- 7 Segmentanzeige

	);
end VGA_SNAKE_TOP;


architecture VGA_DEMO_TOP of VGA_SNAKE_TOP is
		-- Declarations Constant
		constant 		MAX_Y 										:		integer	range	0	to	300 	:= 6; 													-- number of Pixels in y dir
		constant 		MAX_X 										:		integer	range	0	to	300 	:= 6; 													-- number of Pixels in x dir
		constant 		PIC_MAX_X  								:		integer	range	0	to	300 	:= 14;                 				-- Bildgroesse in x Richtung (horizontal)
    constant 		PIC_MAX_Y  								:		integer	range	0	to	300 	:= 16;                 				-- Bildgroesse in y Richtung (vertikal)
		-- Declarations Own Var Types
		type graphicsRGB is array (0 to MAX_x-1,0 to MAX_Y-1) of std_logic_vector(3 downto 0);							-- 

		-- Declarations Signal
		signal			xpos_top     							:  	integer range 0 to	1300 	:= 0;   												-- Pixel Pos x Bildbereich
		signal			ypos_top     							:  	integer range 0 to	1033 	:= 0;    												-- Pixel Pos y Bildbereich
    signal   		x_start								    : 	integer range	0	to	800 	:= 620;													-- Bildkoordinate x = 50 
    signal   		y_start								    : 	integer	range	0	to	700 	:= 5; --512;													-- Bildkoordinate y = 10
		
		signal			Char_Test									:		character;
    signal			Char_Test2								:		character;
    signal			Char_Test3	  						:		character;
																									
		signal			videoOn_top  							:  	std_logic :=	'0';              													-- 1 = Bildbereich
		signal			vga_clk										:		std_logic :=	'0';																				-- Global Clock
		signal			NewFrame_top							:		std_logic :=	'0';																				-- 1 = NewFrame on VGA	
		signal			Game_On										:		std_logic :=	'0';																				-- Signal for Starting the Snake Game
		signal			Draw_Snake								:		std_logic	:=	'0';																				-- Signal for Snake-Body Drawing on VGA Output
		signal			Draw_Snake_Zero						:		std_logic	:=	'0';																				-- Signal for Snake-Head Drawing on VGA Output
		signal			Draw_Apple								:		std_logic	:=	'0';																				-- Signal for Apple Drawing on VGA Output
																										
		signal			BTN_RESET_SYNC						:		std_logic_vector	(1 downto 0);														-- Vektor for Syncing    
    signal   		Adr								        : 	std_logic_vector	(11 downto 0);					
    signal   		Adr1								        : 	std_logic_vector	(11 downto 0);													-- Adressen 
    signal   		Adr2								        : 	std_logic_vector	(11 downto 0);													-- Adressen 
    signal   		Adr3								        : 	std_logic_vector	(11 downto 0);
     signal    	Adrtxt								        : 	std_logic_vector	(11 downto 0);		
    
    signal   		q  								        : 	std_logic_vector	(13 downto 0);													-- Daten  
    signal      R2						:			  		std_logic_vector(3 downto 0);										-- 4-Bit Vektor VGA RED
		signal      G2						:				  	std_logic_vector(3 downto 0);										-- 4-Bit Vektor VGA GREEN
		signal      B2						:			      std_logic_vector(3 downto 0);										-- 4-Bit Vektor VGA BLUE
 --   signal      txt2 : STRING(1 TO 30):=" Snake Game                   "; 
		
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
															
		signal   		x_s1								    : 	integer range	0	to	800 	:= 620;												
    signal   		x_s2								    : 	integer range	0	to	800 	:= 636;												
    signal   		x_s3								    : 	integer range	0	to	800 	:= 235;			
	-- Declarations Functions
		
		procedure	Print_char	(signal char :	character; signal x_s : integer; signal AdrIn : inout std_logic_vector;signal Adr : out std_logic_vector;signal R	:out		std_logic_vector(3 downto 0);	signal	G:			out		std_logic_vector(3 downto 0);	signal	B	:			out		std_logic_vector(3 downto 0))	is
		variable	cbit	: integer range 0 to 15 	:= 0;
		variable	x1		: integer range 0 to 1300 := 0;
		variable	Char_adr	:	integer	range	0	to	650000;
		begin
			
			
			Char_adr	:= character'pos(char);
			Char_adr	:=	(char_adr - 33)*16;																											-- 33 wegen des  Offset vom Attribute pos
			
			if ypos_top >= y_start and ypos_top < y_start + PIC_MAX_Y then 
							x1 := x_s;
             if xpos_top = x_s -1  then
                  Adr <= AdrIn;
              end if;    
              
							if xpos_top >= x_s and xpos_top < x_s + PIC_MAX_X then
                  --Adr <= AdrIn;
                  cbit := 13 - (xpos_top  - x1 );    																					-- aktuelles Bit berechnen
                  if cbit = 0 then																					
                      x1 := xpos_top;                																					-- Zaehler zurÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¼cksetzen, um Bitcounter im Bereich 0 - 14 zu halten
                  end if;																					
                  if q(cbit) = '1' then              																					-- falls bit = 1:  weiss ausgeben
                        R  <= x"f";
                        G  <= x"f";
                        B  <= x"f";
                  end if;
							end if;
              if xpos_top > x_s and xpos_top <= x_s + PIC_MAX_X then
                   if q(cbit) = '1' then              																					-- falls bit = 1:  weiss ausgeben
                        R  <= x"f";
                        G  <= x"f";
                        B  <= x"f";
                  end if;
              end if;
							if  xpos_top = x_s + PIC_MAX_X then      																	-- nach Ende x-Bereich: Adresse erhÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¶hen
                  AdrIn <= AdrIn + 1;
							end if;
        else
           AdriN <= std_logic_vector(to_unsigned(char_adr,12));   			            -- reset rom address    -- auuserhalb Bild: Adresse resetieren
          -- Adr <= adrtxt;
        end if;
			
		end Print_char;
	
	
	
begin

    PLL: if USE_PLL = true generate -- wird bei der Quartus Compilation ausgefÃ¼hrt
        PLL1	:	entity work.pll
        
        port map(
          
          inclk0 	=> clk,
          c0			=> vga_clk);
					
    end generate PLL;
   
    Simu_PLL: if USE_PLL = false generate -- wird bei der Modelsim Simulation ausgefÃ¼hrt
          vga_clk <= CLK; -- Der Clock input wird direkt mit dem globalen
    end generate Simu_PLL;
    
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

		/*Game_Main Instantiation*/
		
		Game_Main	:	entity	work.Game_Main
			port map (
					xpos_game     						=>	xpos_top,
					ypos_game     						=>	ypos_top,
					BTN_LEFT									=>	BTN_LEFT,
					BTN_RIGHT									=>	BTN_RIGHT,
					SLD_Easy_Game							=>	SLD_EASY,
					SLD_Mid_Game							=>	SLD_Mid,
					SLD_Hard_Game							=>	SLD_HARD,
					videoOn_game  						=>	videoOn_top,
					vga_clk										=>	vga_clk,
					NewFrame_game							=>	NewFrame_top,
					Draw_Snake_Out						=>	Draw_Snake,
					Draw_Snake_Zero_Out				=>	Draw_Snake_Zero,
					Draw_Apple_Out						=>	Draw_Apple,
					Reset											=>	Reset);
		/*Grafik Instantiation*/
		
		 grafik: entity work.FONTS               							-- Name des ROMs: FONTS.vhd
				port map (
                clock     => vga_clk,     								-- ROM Clock mit vgaclk verbinden
                address   => Adr,         								-- Adresse);
                q         => q            								-- Daten 
              );
              
              ------------------ Textzeile 1-------------------------         
	text1 : ENTITY work.TextLine -- Textzeile 1
	--	GENERIC MAP(STRING_LENGTH => TXT_LENGTH)

		PORT MAP(
			VGA_Clk => VGA_Clk, -- VGA Clock
			xPos => xpos_top, -- Aktuelle xPosition der VGA Ausgabe (horizonal)
			yPos => ypos_top, -- Aktuelle yPosition der VGA Ausgabe (vertikal)
			screenActive => videoOn_top, -- '1' = Bildschirmausgabe aktiv
			textPos_x => 10, -- Textposition: Bildschirm x Position
			textPos_y => 50, -- Textposition: Bildschirm y Position
			txt => printSingTxt("Snake Game "), -- fixer Text, der ausgegeben wird
			txtColor => x"F20", -- Farbe: RGB Werte, je 4 bit x"RGB"
			address => adrtxt, -- Adresse fÃƒÂ¼r Zeichen ROM
			R => R2, -- Rot   Ausgabewert (4bit)      
			G => G2, -- Gruen Ausgabewert (4bit)       
			B => B2 -- Blau  Ausgabewert (4bit)      
		);
    
    	------------------ ROM ------------------  
	Rom1 : ENTITY work.Rom -- Zeichen ROM, das die Bitmaps der Textzeichen enthÃƒÂ¤lt
		PORT MAP(-- Jede Adresse enthÃƒÂ¤lt 32 bit Horizontal Pixel, gefolgt
			clock => VGA_Clk, -- von 31 Adressen mit den 32 bit horizontalen Zeilen des aktuellen Zeichens  
			address => adrtxt, -- Memory Addresse
			q => pixel); -- 32 bit Datenausgang
	-- Process Statement (optional)
		Drawing	:	process(all)
						
		begin
		
			if rising_edge(vga_clk) then
				
				R <= x"0";
				G <= x"0";
				B	<= x"0";
				Char_Test	<= 'H';
        Char_Test2<= 'A';
        Char_Test3<= 'A';
				Game_On	<=	'0';
				BTN_RESET_SYNC(0) <= Reset;
				BTN_RESET_SYNC(1) <= BTN_RESET_SYNC(0);
					

				if videoOn_top = '1' then
				
					/*GameState FSM*/
					case	Game_State	is
						when	Startscreen		=> B <= x"F";
						when	Game					=> Game_On <= '1';
						when	Endscreen			=> R <= x"F";	
						when	others				=> Null;					
					end case;
					/*GameState FSM END*/
					
					if Game_State = Startscreen then
						
						/*Grafik Output*/
						print_char(char_Test,x_s1,Adr1,Adr,R,G,B);
           
            print_char(char_Test2,x_s2,Adr2,Adr,R,G,B);
            
            print_char(char_Test3,x_s3,Adr3,Adr,R,G,B);
						
						/*Grafik Output END*/

						if xpos_top	>= 300 and xpos_top < 300 + MAX_X then
							if	ypos_top >= 412 and ypos_top	< 412 + MAX_Y	then
								R <=	BoxGraphics_R(ypos_top - 412, xpos_top - 300);
								G	<=	BoxGraphics_G(ypos_top - 412, xpos_top - 300);
								B	<=	BoxGraphics_B(ypos_top - 412, xpos_top - 300);
							end if;						
						end if;
					end if;

					/*VGA OUTPUT Schlange und Apfel*/
					
					if xpos_top = 640 then
						R <= x"F";
					end if;
					if Game_On	= '1' then
						if Draw_Snake = '1' then 																													-- Schlange zeichnen
							G <= x"F";
						end if;
						if Draw_Snake_Zero = '1' then 																										-- Schlange zeichnen
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
          if R2 > 0 then
                R <= R2; -- Aktuelles rot = rot Textzeile 1 + rpt Textzeile2 
          end if;
          
          if G2 > 0 then
                G <= G2; -- Aktuelles rot = rot Textzeile 1 + rpt Textzeile2 
          end if;
          
          if B2 > 0 then
                B <= B2; -- Aktuelles rot = rot Textzeile 1 + rpt Textzeile2 
          end if;
          
				  					
					/*VGA OUTPUT Schlange und Apfel END*/
					
				end if;		-- VideoOn_top
			end if; 		-- VGA_CLK
		end process Drawing;
end VGA_DEMO_TOP;