library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 

entity ROM_test is 
port (
       vgaclk   : in   std_logic;                            -- vga clock
       reset    : in   std_logic;                            -- reset signal (nicht verwendet)
       xpos     : in   integer;                              -- aktuelle vga horizontal Bildschirmposition
       ypos     : in   integer;                              -- aktuelle vga vertikal Bildschirmposition  
       R        : out  std_logic_vector (3 downto 0);        -- VGA Signal rot
       G        : out  std_logic_vector (3 downto 0);        -- VGA Signal gruen
       B        : out  std_logic_vector (3 downto 0)         -- VGA Signal blau
     );
end ROM_test;

architecture Beh_ROM_test of ROM_test is
    constant PIC_MAX_X  : integer := 512;                    -- Bildgroesse in x Richtung (horizontal)
    constant PIC_MAX_Y  : integer := 256;                    -- Bildgroesse in y Richtung (vertikal)
    signal   x_start    : integer := 50;                     -- Bildkoordinate x = 50 
    signal   y_start    : integer := 10;                     -- Bildkoordinate y = 10 
    signal   Adr        : std_logic_vector(11 downto 0);     -- Adressen 
    signal   q          : std_logic_vector(31 downto 0);     -- Daten    
begin
    grafik: entity work.ROM1                                 -- Name des ROMs: ROM1.vhd
    port map (
                clock     => vgaclk,                         -- ROM Clock mit vgaclk verbinden
                address   => Adr,                            -- Adresse);
                q         => q                               -- Daten 
              );

    process (vgaclk, xpos, ypos)
    begin  
         if rising_edge(vgaclk) then
              R  <= x"0";
              G  <= x"0";
              B  <= x"0";
              if  ypos = 0 then
                  Adr <= (others => '0');   -- reset rom address
              end if; 

              if xpos >= x_start  and xpos < x_start + PIC_MAX_X then 
                  if ypos >= y_start and ypos < y_start + PIC_MAX_Y then  

                      if q /= x"111" then         -- Grafik Ausgabe, falls nicht transparente Farbe 
                      end if;
                          Adr <= Adr + 1;                                          -- ROM Adresse erhoehen
                   end if;
              end if;
          end if;   -- rising_edge(vgaclk)
    end process;
end Beh_ROM_test;
