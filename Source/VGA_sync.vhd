library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_sync is                                      
port
(
-- Input ports
  vga_clk  			: in   std_logic;                 								-- vga clock 
  Reset    			: in   std_logic;                 								-- 1 = Reset
-- InOut Ports


-- Out Ports
  hsync    			: out  std_logic;                 								-- Hsync Monitor
  vsync    			: out  std_logic;                 								-- Vsync Monitor
  xpos     			: out  integer range 0 to 1300;   								-- Pixel Pos x Bildbereich
  ypos     			: out  integer range 0 to 1033;   								-- Pixel Pos y Bildbereich
	NewFrame 			: out	std_logic;																	-- Signal NewFrame
  videoOn  			: out  std_logic);                								-- 1 = Bildbereich
end vga_sync;


architecture Beh_VgaSync of vga_sync is 

	--1280 X 1024 @60HZ 108MHz Pixel CLK
	
	-- Declarations Constant
	constant HFP	: integer range 0 to 100 := 48;										-- Horizontal Front Porch
	constant HS		: integer range 0 to 200 := 112;									-- Horizontal Sync Puls
	constant HBP 	: integer range 0 to 300 := 248;									-- Horizontal Back Porch
	constant HP		:	integer range	0 to 500 := HFP + HS + HBP;				-- Horizontal	Porch + Sync
	constant polH : Std_logic := '1';																-- Horizontal Polarization
	
	constant Htot	: integer range 0 to 2000 := 1688;								-- Horizontal total Pixel
	
	constant VFP	: integer range 0 to 100 := 1;										-- Vertical Front Porch										
	constant VS		: integer range 0 to 200 := 3;										-- Vertical Sync Puls
	constant VBP 	: integer range 0 to 300 := 38;										-- Vertical Back Porch
	constant VP		: integer range 0 to 500 := VFP + VS + VBP;				-- Vertical Porch + Sync
	constant polV : Std_logic := '1';																-- Vertical Polarization
	
	constant Vtot	: integer range 0 to 1500 := 1066;								-- Vertical total Pixel
	
	-- Declarations Signal
	signal hor		: integer range 0 to 2000 := 0;										-- Horizontal counting Var
	signal ver 		: integer range 0 to 2000 := 0;										-- Vertical Counting Var
	
begin 

	process(all)
	
	begin
			if rising_edge(vga_clk)	then
				
				hor 			<= hor + 1;
				hSync 		<= not polH;
				NewFrame	<= '0';
				
				if hor > HFP and hor < HFP + HS then 											--sync Puls ausgeben
					hsync 	<= polH;
				end if;
				/*Das Ende von einer Zeile wird geprüft*/
				if hor = Htot - 1 then			
					hor	<= 0;
					ver	<= ver + 1; 																				-- Falls Ende gehen wir auf die nächste Zeile
				end if;
				
				vsync 		<= not polV;
				
				if ver > VFP and ver < VFP + VS then
					vsync <= polV;
				end if;
				/*Das Ende vom Bildschirm wird ÜBERprüft.*/
				if ver = Vtot - 1 then
					ver <= 0; 																							-- Wir fangen wieder von oben an
					NewFrame <= '1';
				end if;
				
			end if;
			/*xpos wird beschrieben*/
			xpos <= 0;
			if hor > HP then
				xpos	<= hor - HP;
			end if;
			
			/*ypos wird beschrieben*/
			ypos <= 0;
			if ver > VP then
				ypos <= ver - VP;
			end if;
			
			/*videoOn wird beschrieben*/
			videoOn <= '0';
			if hor > HP and ver > VP then
				videoOn <= '1';
			end if;
	end process;
end architecture;