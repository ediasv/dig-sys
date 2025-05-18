library ieee;
use ieee.std_logic_1164.all;

entity fsm_9 is
  port(
    x    : in std_logic_vector(3 downto 0);
    j, k : out std_logic_vector(3 downto 0)
  );
end fsm_9;

architecture behavioral of fsm_9 is 
begin
  process(x)
  begin
    j(0) <= '1';
    k(0) <= '1';
    j(1) <= (not(x(3)) and x(0));
    k(1) <= (not(x(3)) and x(0));
    j(2) <= (x(1) and x(0));
    k(2) <= (x(1) and x(0));
    j(3) <= (x(2) and x(1) and x(0));
    k(3) <= (not(x(1)) and x(0));
  end process;
end behavioral;
