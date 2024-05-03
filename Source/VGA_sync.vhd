library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_sync is                                      
port
(
  vga_clk  : in   std_logic;                 -- vga clock 
  Reset    : in   std_logic;                 -- 1 = Reset                                   
  hsync    : out  std_logic;                 -- Hsync Monitor
  vsync    : out  std_logic;                 -- Vsync Monitor
  xpos     : out  integer range 0 to 1300;   -- Pixel Pos x Bildbereich
  ypos     : out  integer range 0 to 1033;    -- Pixel Pos y Bildbereich
	NewFrame : out	std_logic;
  videoOn  : out  std_logic);                -- 1 = Bildbereich
end vga_sync;


architecture Beh_VgaSync of vga_sync is 

	--1280 X 1024 @60HZ 108MHz Pixel CLK
	
	
	constant HFP	: integer range 0 to 100 := 48;
	constant HS		: integer range 0 to 200 := 112;
	constant HBP 	: integer range 0 to 300 := 248;
	constant HP		:	integer range	0 to 500 := HFP + HS + HBP;
	constant polH : Std_logic := '1';
	
	constant Htot	: integer range 0 to 2000 := 1688;
	
	constant VFP	: integer range 0 to 100 := 1;
	constant VS		: integer range 0 to 200 := 3;
	constant VBP 	: integer range 0 to 300 := 38;
	constant VP		: integer range 0 to 500 := VFP + VS + VBP;
	constant polV : Std_logic := '1';
	
	constant Vtot	: integer range 0 to 1500 := 1066;
	
	
	signal hor	: integer range 0 to 2000 := 0;
	signal ver 	: integer range 0 to 2000 := 0;
	
begin 

	process(all)
	
	begin
			if rising_edge(vga_clk)	then
				
				hor <= hor + 1;
				hSync <= not polH;
				NewFrame	<= '0';
				
				if hor > HFP and hor < HFP + HS then --sync Puls ausgeben
					hsync <= polH;
				end if;
				-- Das Ende von einer Zeile wird geprüft
				if hor = Htot - 1 then			
					hor <= 0;
					ver <= ver + 1; -- Falls Ende gehen wir auf die nächste Zeile
				end if;
				
				vsync <= not polV;
				if ver > VFP and ver < VFP + VS then
					vsync <= polV;
				end if;
				-- Das Ende vom Bildschirm wird ÜBERprüft.
				if ver = Vtot - 1 then
					ver <= 0; -- Wir fangen wieder von oben an
					NewFrame <= '1';
				end if;
				
			end if;
			
			xpos <= 0;
			if hor > HP then
				xpos <= hor - HP;
			end if;
			
			ypos <= 0;
			if ver > VP then
				ypos <= ver - VP;
			end if;
			
			videoOn <= '0';
			if hor > HP and ver > VP then
				videoOn <= '1';
			end if;
	end process;
	
	
end architecture;