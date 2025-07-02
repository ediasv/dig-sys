library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk             : in  std_logic;  -- Main system clock (e.g., 50MHz)
        tick_1hz        : in  std_logic;  -- 1Hz tick input
        reset_n         : in  std_logic;  -- Active low reset
        enable          : in  std_logic;  -- Enable timer countdown
        tick_o          : out std_logic;  -- High when timer reaches 00:00
        minutes_tens    : out std_logic_vector(0 downto 0); -- Changed to vector for consistency
        minutes_units   : out std_logic_vector(3 downto 0);
        seconds_tens    : out std_logic_vector(2 downto 0);
        seconds_units   : out std_logic_vector(3 downto 0)
    );
end entity timer;

architecture rtl of timer is
    -- Component declaration for our new generic counter
    component countdown_counter is
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

    -- Internal signals for the enable chain and counter outputs
    signal su_tick, st_tick, mu_tick, mt_tick : std_logic;
    signal su_en, st_en, mu_en, mt_en       : std_logic;

    signal su_out, mu_out : std_logic_vector(3 downto 0);
    signal st_out         : std_logic_vector(2 downto 0);
    signal mt_out         : std_logic_vector(0 downto 0);

    signal timer_is_zero  : std_logic;

begin
    -- The enable chain logic
    su_en <= tick_1hz and enable and not timer_is_zero; -- Seconds-units counts every 1Hz tick
    st_en <= su_tick;  -- Seconds-tens counts when seconds-units ticks (rolls over from 0)
    mu_en <= st_tick;  -- Minutes-units counts when seconds-tens ticks
    mt_en <= mu_tick;  -- Minutes-tens counts when minutes-units ticks

    -- Seconds units counter (9 down to 0)
    sec_units_counter: component countdown_counter
        generic map ( MAX_VAL => 9, WIDTH => 4 )
        port map (
            clk       => clk,
            reset_n   => reset_n,
            enable    => su_en,
            tick_out  => su_tick,
            count_out => su_out
        );

    -- Seconds tens counter (5 down to 0)
    sec_tens_counter: component countdown_counter
        generic map ( MAX_VAL => 5, WIDTH => 3 )
        port map (
            clk       => clk,
            reset_n   => reset_n,
            enable    => st_en,
            tick_out  => st_tick,
            count_out => st_out
        );

    -- Minutes units counter (9 down to 0)
    min_units_counter: component countdown_counter
        generic map ( MAX_VAL => 9, WIDTH => 4 )
        port map (
            clk       => clk,
            reset_n   => reset_n,
            enable    => mu_en,
            tick_out  => mu_tick,
            count_out => mu_out
        );

    -- Minutes tens counter (1 down to 0)
    min_tens_counter: component countdown_counter
        generic map ( MAX_VAL => 1, WIDTH => 1 )
        port map (
            clk       => clk,
            reset_n   => reset_n,
            enable    => mt_en,
            tick_out  => mt_tick,
            count_out => mt_out
        );

    -- Combinational logic for zero detection and outputs
    timer_is_zero <= '1' when su_out = "0000" and st_out = "000" and mu_out = "0000" and mt_out = "0" else '0';

    -- Output assignments
    seconds_units <= su_out;
    seconds_tens  <= st_out;
    minutes_units <= mu_out;
    minutes_tens  <= mt_out;

    tick_o <= st_tick and mu_tick and mt_tick; -- A more precise final tick

end architecture rtl;
