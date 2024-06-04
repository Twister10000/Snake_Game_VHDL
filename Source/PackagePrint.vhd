library ieee;
use ieee.std_logic_1164.all;

package PackagePrint is 
  constant STRING_LENGTH : INTEGER RANGE 1 TO 127 := 20; -- Textlaenge (Defaultwert)

  function printTxt( txtIn : string; i :  integer ) return string;
  function printSingTxt( txtIn : string) return string;
  
end PackagePrint;

package body PackagePrint is  
  
  
  function printTxt( txtIn : string; i :  integer ) return string is
      variable txt : string (1 to STRING_LENGTH + 10):="                              ";
      
   begin 
      txt(1 to txtIn'length  + integer'image(i)'length) := txtIn & integer'image(i) ;    
      return txt;
   end function;

   function printSingTxt( txtIn : string) return string is
      variable txt : string (1 to STRING_LENGTH + 10):="                              ";
      
   begin 
      txt(1 to txtIn'length) := txtIn;    
      return txt;
   end function;

end package body;   