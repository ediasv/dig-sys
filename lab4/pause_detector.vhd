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
  signal pause_internal : std_logic := '0';
begin
-- pause = '1' se o timer for igual a 250264
  process(ms_unit, ms_tens, ms_hundreds, sec_unit, sec_tens, min)
  begin
    if (
      ms_unit = "0100" and
      ms_tens = "0110" and
      ms_hundreds = "0010" and
      sec_unit = "0000" and
      sec_tens = "0101" and
      min = "0010"
    ) then
      pause_internal <= '1';
    else
      pause_internal <= '0';
    end if;
  end process;

  pause <= pause_internal;
end architecture behavioral;
