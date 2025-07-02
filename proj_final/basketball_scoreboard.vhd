library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basketball_scoreboard is
    port (
        clk_i       : in  std_logic; -- Pin connected to P11 (N14)
        pb          : in  std_logic_vector(1 downto 0);
        sw          : in  std_logic_vector(2 downto 0)
    );
end entity basketball_scoreboard;
