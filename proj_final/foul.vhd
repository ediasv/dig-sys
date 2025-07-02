library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity foul_counter is
    port (
        clk            : in  std_logic;
        add_foul_btn   : in  std_logic;
        foul_count_out : out std_logic_vector(3 downto 0)
    );
end entity foul_counter;

architecture rtl of foul_counter is

    -- Signal to store the previous state of the button for edge detection
    signal btn_prev : std_logic;

    -- The single-cycle pulse that enables the counter
    signal increment_pulse : std_logic;

    -- Internal register to hold the foul count, initialized to 0
    signal count_reg : unsigned(3 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- 1. Edge Detector: Store the previous value of the input signal
            btn_prev <= add_foul_btn;

            -- 2. Counter logic
            if increment_pulse = '1' and count_reg < 9 then
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    -- Combinational logic to generate a clean, single-cycle pulse
    increment_pulse <= '1' when (add_foul_btn = '1' and btn_prev = '0') else '0';

    -- Final output assignment
    foul_count_out <= std_logic_vector(count_reg);

end architecture rtl;
