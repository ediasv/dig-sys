library ieee;
use ieee.std_logic_1164.all;

entity points_counter is
    port (
        clk             : in  std_logic;
        add_point_btn   : in  std_logic;
        tens_digit      : out std_logic_vector(3 downto 0);
        units_digit     : out std_logic_vector(3 downto 0)
    );
end entity points_counter;

architecture structural of points_counter is

    -- Use the generic countup_counter component
    component countup_counter is
        generic (
            MAX_VAL : integer := 9;
            WIDTH   : integer := 4
        );
        port (
            clk       : in  std_logic;
            reset_n   : in  std_logic;
            enable    : in  std_logic;
            tick_out  : out std_logic;
            count_out : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

    signal units_tick : std_logic;

begin

    -- Units Digit Counter: Enabled by the add point button.
    -- This counter increments every time a point is added.
    U1_units_counter : component countup_counter
        generic map (
            MAX_VAL => 9,
            WIDTH   => 4
        )
        port map (
            clk       => clk,
            reset_n   => '1', -- Reset is permanently disabled (tied high)
            enable    => add_point_btn,
            count_out => units_digit,
            tick_out  => units_tick
        );

    -- Tens Digit Counter: Enabled by the 'tick' from the units counter.
    -- This counter only increments when the units counter rolls over from 9 to 0.
    U2_tens_counter : component countup_counter
        generic map (
            MAX_VAL => 9,
            WIDTH   => 4
        )
        port map (
            clk       => clk,
            reset_n   => '1', -- Reset is permanently disabled (tied high)
            enable    => units_tick,
            count_out => tens_digit,
            tick_out  => open -- Not used
        );

end architecture structural;
