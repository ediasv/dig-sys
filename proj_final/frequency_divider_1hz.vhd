library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tick_1hz is
    port(
        clk_i  : in  std_logic;
        rst    : in  std_logic;
        tick_o : out std_logic
    );
end entity tick_1hz;

architecture behavioral of tick_1hz is

    constant CLOCK_FREQ : integer := 50_000_000;

    signal count : integer range 0 to CLOCK_FREQ;

begin

    process(clk_i, rst)
    begin
        if rst = '1' then
            count  <= 0;
            tick_o <= '0';
        elsif rising_edge(clk_i) then
            if count = CLOCK_FREQ - 1 then
                count  <= 0;
                tick_o <= '1';
            else
                count  <= count + 1;
                tick_o <= '0';
            end if;
        end if;
    end process;

end architecture behavioral;
