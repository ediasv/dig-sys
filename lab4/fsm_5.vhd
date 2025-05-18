library ieee;
use ieee.std_logic_1164.all;

entity fsm_5 is
  port(
    x: in std_logic_vector(3 downto 0);
    j, k: out std_logic_vector(3 downto 0)
  );
end fsm_5;

architecture behavioral of fsm_5 is 
begin
  j(0) <= '1';
  k(0) <= '1';
  j(1) <= (not(x(2)) and x(0));
  k(1) <= x(0);
  j(2) <= (x(1) and x(0));
  k(2) <= x(0);
  j(3) <= '0';
  k(3) <= '0';
end behavioral;
