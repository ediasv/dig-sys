library ieee;
use ieee.std_logic_1164.all;

entity bcd_1_counter_desc is
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        tick_out  : out std_logic;
        count_out : out std_logic
    );
end entity bcd_1_counter_desc;

architecture rtl of bcd_1_counter_desc is

    signal count_reg : std_logic;

begin

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            count_reg <= '1';
        elsif rising_edge(clk) then
            count_reg <= not count_reg;
        end if;
    end process;

    count_out <= count_reg;

    tick_out <= '1' when count_reg = '0' else '0';

end architecture rtl;
