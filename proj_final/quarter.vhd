library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_quarter_counter is
    port (
        clk                 : in  std_logic;
        timer_finished_tick : in  std_logic;
        quarter_out         : out std_logic_vector(2 downto 0)
    );
end entity game_quarter_counter;

architecture rtl of game_quarter_counter is

    -- Register to store the previous state of the input for edge detection
    signal tick_prev : std_logic;

    -- The final single-cycle pulse that enables the counter
    signal increment_pulse : std_logic;

    -- Register to hold the quarter, initialized to 1
    signal count_reg : unsigned(2 downto 0) := "001";

begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- 1. Edge Detector: Store the previous value of the input signal
            tick_prev <= timer_finished_tick;

            -- 2. Counter: Increment only on the detected rising edge
            if increment_pulse = '1' and count_reg < 4 then
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    -- Combinational logic to generate the single-cycle increment pulse
    -- It's '1' only when the signal is now high AND it was previously low.
    increment_pulse <= '1' when (timer_finished_tick = '1' and tick_prev = '0') else '0';

    quarter_out <= std_logic_vector(count_reg);

end architecture rtl;
