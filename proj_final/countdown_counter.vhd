library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity countdown_counter is
    generic (
        MAX_VAL : integer := 9; -- The value to load on reset/rollover
        WIDTH   : integer := 4  -- The bit-width of the counter
    );
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        enable    : in  std_logic; -- Only counts when this is '1'
        tick_out  : out std_logic;
        count_out : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity countdown_counter;

architecture rtl of countdown_counter is
    signal count_reg : unsigned(WIDTH-1 downto 0);
begin
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            count_reg <= to_unsigned(MAX_VAL, WIDTH);
        elsif rising_edge(clk) then
            if enable = '1' then
                if count_reg = 0 then
                    count_reg <= to_unsigned(MAX_VAL, WIDTH);
                else
                    count_reg <= count_reg - 1;
                end if;
            end if;
        end if;
    end process;

    tick_out <= '1' when count_reg = 0 and enable = '1' else '0';
    count_out <= std_logic_vector(count_reg);
end architecture rtl;
