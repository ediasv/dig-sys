library ieee;
use ieee.std_logic_1164.all;

entity pause_detector is 
  port(
    ms_unit     : in std_logic_vector(3 downto 0);
    ms_tens     : in std_logic_vector(3 downto 0);
    ms_hundreds : in std_logic_vector(3 downto 0);
    sec_unit    : in std_logic_vector(3 downto 0);
    sec_tens    : in std_logic_vector(3 downto 0);
    min         : in std_logic_vector(3 downto 0);
    pause       : out std_logic
  );
end entity;

architecture behavioral of pause_detector is
begin
-- pause = '1' se o timer for igual a 250264
end architecture behavioral;
