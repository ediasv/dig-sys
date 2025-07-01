library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_5_counter is
    port (
        clk       : in  std_logic;                  
        reset_n   : in  std_logic;                  
        tick_out  : out std_logic;                  
        count_out : out std_logic_vector(2 downto 0)
    );
end entity bcd_5_counter;

architecture rtl of bcd_5_counter is

    signal count_reg : unsigned(2 downto 0);

begin

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            count_reg <= (others => '0');
        elsif rising_edge(clk) then
            if count_reg = 5 then
                count_reg <= (others => '0');
            else
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    count_out <= std_logic_vector(count_reg);
    
    tick_out <= '1' when count_reg = 5 else '0';

end architecture rtl;
