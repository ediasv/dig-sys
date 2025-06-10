library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_flipflop is
  port(
    d   : in  std_logic;
    clk : in  std_logic;
    rst : in  std_logic;
    q   : out std_logic
  );
end d_flipflop;

architecture behavioral of d_flipflop is
begin
  process(clk, rst)
  begin
    -- Reset assíncrono: se RST for '1', a saída é zerada independentemente do clock
    if rst = '1' then
        q <= '0';
    elsif rising_edge(clk) then
        q <= d;
    end if;
  end process;
end behavioral;
