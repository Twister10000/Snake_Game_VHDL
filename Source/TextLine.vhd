library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.packageText.all;


  entity TextLine is
  generic (SCREEN_XMAX   :  integer range 0 to 4096 := 2200;     -- Bildschirm horizontale Maximalkoordinate (Defaultwert)
           SCREEN_YMAX   :  integer range 0 to 2048 := 1688;     -- Bildschirm vertikale   Maximalkoordinate (Defaultwert)
           STRING_LENGTH :  integer range 1 to 127  := 30        -- Textlaenge (Defaultwert) 
           );  
	port(
         
		VGA_Clk		   : in	std_logic;					                       -- VGA Clock
    xpos         : in integer range 0 to SCREEN_XMAX := 0;       -- aktuelle Bildschirm x Koordinate (horizontal)
    yPos 	  	   : in integer range 0 to SCREEN_YMAX := 0;       -- aktuelle Bildschirm y Koordinate (vertikal)
    screenActive : in std_logic := '0';                          -- 1: Bildbereich ist aktiv: R,G,B kann beschrieben werden
    textPos_x    : in integer range 0 to SCREEN_XMAX:= 0;        -- Textposition: Bildschirm x Position
    textPos_y    : in integer range 0 to SCREEN_YMAX := 0;       -- Textposition: Bildschirm y Position
    
    txt          : in string( 1 to STRING_LENGTH);               -- Text, der ausgegeben wird
    
    txtColor     : in	std_logic_vector (11 downto 0) := x"FF2";	 -- Farbe: RGB Werte, je 4 bit x"RGB"	des ausgegebenen Textes
    
    address      : out std_logic_vector(ROM_WIDTH downto 0) := (others => '0'); -- aktuelle Adresse des Charakter ROMS
    R            : out std_logic_vector(3 downto 0);                            -- Rot   Ausgabewert (4bit)
    G            : out std_logic_vector(3 downto 0);                            -- Gruen Ausgabewert (4bit)
    B            : out std_logic_vector(3 downto 0)                             -- Blau  Ausgabewert (4bit)

	);
end TextLine;

	
-------------------------------------------------------------------
--								Architecture 
--------------------------------------------------------------------
architecture Beh_TextLine of TextLine is

  constant CHAR_OFFSET : integer range   0 to   64 := 33;                     -- Erstes Zeichen im CHar Rom entspricht ASCII-Wert 33
  
begin
    process (all)
    
        variable offset : integer range -32 to 65535 := 0;                    -- Berechnet Adresse im ROM
        variable dx     : integer range   0 to   127 := 0;                    -- aktuelles Pixel horizontal, welches ausgegeben wird
        variable char   : integer range   0 to   255 := 1;                    -- aktuelles Zeichen im txt Strin, welches ausgegeben wird
        --variable bit1   : integer range   0 to   255 := 1;      
    begin    
      if rising_edge(VGA_Clk) then
        
         R <= x"0";
         G <= x"0";
         B <= x"0";
         if screenActive = '1' then                                                             -- Bildschiem aktiv?
          
            if xpos >= textPos_x and xpos <   textPos_x + CHAR_WIDTH* (txt'length-1)-1   then   -- x Koordinate in aktuellem Text?
                if ypos >= textPos_y and ypos <   textPos_y + CHAR_HEIGHT then                  -- y Koordinate in aktuellem Text?     
                        dx := dx + 1;                                                           -- Ja, Char Pixel + 1
                         if (dx = CHAR_WIDTH-3) then                                            -- 3 Zeichen vor Ende des chars, naechstes Zeichen waehlen
                                                                                                -- Die benoetijt drei Taktzyklen
                              char := char  + 1;               
                              if char > txt'length then                                         -- Fehler in Simulation, am Ende des Textes vermeiden
                                  char := 1;                                  
                              end if;                           
                 
                         end if;
                         Offset := CHAR_HEIGHT * (character'pos(txt(char))- CHAR_OFFSET)+ (ypos - textPos_y);   -- Zeichenhoehe x aktuelle Zeichen Nr + Zeile
                                                  
                         if (dx = CHAR_WIDTH) then                                                              -- dx am Ende des Zeichens zuruecksetzen
                            dx := 0;
                         end if;       
                             
                         if Offset >= 0 then                                                                    -- Falls kein Leerschlag oder Spezialcharakter:
                             address <= STD_LOGIC_VECTOR (to_unsigned(Offset   ,12));                           -- Adresse an ROM ausgeben
                                                        
                            if pixel(CHAR_WIDTH-1-dx) = '1' then                                                -- Aktuelles Pixel gespiegelt ausgeben          
                                  R <= txtColor(11 downto 8);                                                   -- Farbe anwaehlen 
                                  G <= txtColor(7  downto 4);
                                  B <= txtColor(3  downto 0);
                            end if;     
                        else     
                           address <=  (others => '0');     
                        end if;
                
                else                                                                                            -- Y Position ausserhalb Textline:
                      offset := 0;                                                                              -- Offset zuruecksetzen
                      char := 1;                                                                                -- Zeichen auf Start setzen
                      dx := 0;                                                                                  -- aktuelles Pixel = 0
                      address <=  (others => '0');                                                              -- Adresse = 0  
                end if;
            else 
               address <=  (others => '0');                                                                     -- X Position ausserhalb Textline:
               char := 1;                                                                                       -- Adresse = 0       
               dx := 0;                                                                                         -- Zeichen auf Start setzen
            end if;                                                                                             -- aktuelles Pixel = 0
          end if;                                                                                          
       end if;
     
   end process;  
end architecture Beh_TextLine;   
