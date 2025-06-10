library ieee;
use ieee.std_logic_1164.all;

entity hex_to_7_seg_decoder is
  port (
      hex_in       : in  std_logic_vector(3 downto 0); 
      segments_out : out std_logic_vector(6 downto 0) 
  );
end hex_to_7_seg_decoder;

architecture behavioral of hex_to_7_seg_decoder is
begin
  segments_out(0) <= (hex_in(3) and not(hex_in(2)) and hex_in(1) and hex_in(0)) or
                      (hex_in(3) and hex_in(2) and not(hex_in(1)) and hex_in(0)) or
                      (not(hex_in(3)) and hex_in(2) and not(hex_in(1)) and not(hex_in(0))) or
                      (not(hex_in(3)) and not(hex_in(2)) and not(hex_in(1)) and hex_in(0));

  segments_out(1) <= (not(hex_in(3)) and hex_in(2) and not(hex_in(1)) and hex_in(0)) or
                      (hex_in(3) and hex_in(2) and not(hex_in(0))) or
                      (hex_in(3) and hex_in(1) and hex_in(0)) or
                      (hex_in(2) and hex_in(1) and not(hex_in(0)));

  segments_out(2) <= (not(hex_in(3)) and not(hex_in(2)) and hex_in(1) and not(hex_in(0))) or
                      (hex_in(3) and hex_in(2) and not(hex_in(0))) or
                      (hex_in(3) and hex_in(2) and hex_in(1));

  segments_out(3) <= (not(hex_in(3)) and not(hex_in(2)) and not(hex_in(1)) and hex_in(0)) or
                      (not(hex_in(3)) and hex_in(2) and not(hex_in(1)) and not(hex_in(0))) or
                      (hex_in(3) and not(hex_in(2)) and hex_in(1) and not(hex_in(0))) or
                      (hex_in(2) and hex_in(1) and hex_in(0));

  segments_out(4) <= (not(hex_in(3)) and hex_in(2) and not(hex_in(1))) or
                      (not(hex_in(2)) and not(hex_in(1)) and hex_in(0)) or
                      (not(hex_in(3)) and hex_in(0));

  segments_out(5) <= (hex_in(3) and hex_in(2) and not(hex_in(1)) and hex_in(0)) or
                      (not(hex_in(3)) and not(hex_in(2)) and hex_in(0)) or
                      (not(hex_in(3)) and hex_in(1) and hex_in(0)) or
                      (not(hex_in(3)) and not(hex_in(2)) and hex_in(1));

  segments_out(6) <= (not(hex_in(3)) and not(hex_in(2)) and not(hex_in(1))) or
                      (not(hex_in(3)) and hex_in(2) and hex_in(1) and hex_in(0)) or
                      (hex_in(3) and hex_in(2) and not(hex_in(1)) and not(hex_in(0)));
end behavioral;
