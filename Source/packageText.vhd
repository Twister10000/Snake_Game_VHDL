library ieee;
use ieee.std_logic_1164.all; 


package packageText is                                 
  constant CHAR_WIDTH  : integer range 0 to 64 := 32;                               -- Breite eines Zeichens im Grafik ROM
  constant CHAR_HEIGHT : integer range 0 to 64 := 32;                               -- Hoehe eines Zeichens im Grafik ROM
  constant ROM_WIDTH   : integer range 0 to 64 := 11;                               -- Adressbusbreite des Grafik ROMs
  signal address		   :  STD_LOGIC_VECTOR (ROM_WIDTH DOWNTO 0):= (others => '0');  -- Adresse fuer Grafik ROM
  signal pixel	       :  STD_LOGIC_VECTOR (CHAR_WIDTH-1 DOWNTO 0);                 -- Ausgang Grafik ROM
  
                        
  component Rom is                                                                  -- Komponentedeklarierung fuer Grafik ROM
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		q					: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);

  end component;
   
end packageText;

package body packageText is               


end package body;
