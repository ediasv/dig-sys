library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basketball_scoreboard is
    port (
        -- Global Inputs
        clk         : in  std_logic; -- 50 MHz Clock
        reset_n     : in  std_logic; -- Active-low global reset
        btn1        : in  std_logic; -- Button 1 for Team A points / Mode dependent
        btn2        : in  std_logic; -- Button 2 for Team B points / Mode dependent
        mode_switch : in  std_logic; -- A switch to change between Score and Timer display

        -- Parallel 7-Segment Display Output for 4 digits
        seven_seg_out : out std_logic_vector(27 downto 0) -- 4 displays * 7 segments = 28 bits
    );
end entity basketball_scoreboard;

architecture structural of basketball_scoreboard is

    -- Component Declarations
    component points_counter is
        port (
            clk           : in  std_logic;
            add_point_btn : in  std_logic;
            tens_digit    : out std_logic_vector(3 downto 0);
            units_digit   : out std_logic_vector(3 downto 0)
        );
    end component;

    component timer is
        port (
            tick_1hz      : in  std_logic;
            reset_n       : in  std_logic;
            enable        : in  std_logic;
            tick_o        : out std_logic;
            minutes_tens  : out std_logic;
            minutes_units : out std_logic_vector(3 downto 0);
            seconds_tens  : out std_logic_vector(2 downto 0);
            seconds_units : out std_logic_vector(3 downto 0)
        );
    end component;

    component tick_1hz is
        port(
            clk_i  : in  std_logic;
            rst    : in  std_logic;
            tick_o : out std_logic
        );
    end component;

    component hex_to_7_seg_decoder is
      port (
          hex_in       : in  std_logic_vector(3 downto 0);
          segments_out : out std_logic_vector(6 downto 0)
      );
    end component;

    -- Internal Signals
    signal tick_1hz_sig              : std_logic;
    signal timer_enable, timer_finished_tick : std_logic;

    -- Data signals from counters
    signal points_a_tens, points_a_units : std_logic_vector(3 downto 0);
    signal points_b_tens, points_b_units : std_logic_vector(3 downto 0);
    signal timer_mt_s                  : std_logic;
    signal timer_mu_s, timer_su_s      : std_logic_vector(3 downto 0);
    signal timer_st_s                  : std_logic_vector(2 downto 0);

    -- Data signals to be fed into the decoders for each digit
    signal data_d3, data_d2, data_d1, data_d0 : std_logic_vector(3 downto 0);

    -- Decoded 7-segment data for each of the four digits
    signal segments_d3, segments_d2, segments_d1, segments_d0 : std_logic_vector(6 downto 0);

begin

    -- INSTANCE 1: 1Hz Tick Generator
    U_TICK_GEN: component tick_1hz
        port map (
            clk_i  => clk,
            rst    => not reset_n,
            tick_o => tick_1hz_sig
        );

    -- INSTANCE 2 & 3: Points counters for each team
    U_POINTS_A: component points_counter
        port map (
            clk           => clk,
            add_point_btn => btn1,
            tens_digit    => points_a_tens,
            units_digit   => points_a_units
        );
    U_POINTS_B: component points_counter
        port map (
            clk           => clk,
            add_point_btn => btn2,
            tens_digit    => points_b_tens,
            units_digit   => points_b_units
        );

    -- INSTANCE 4: Main Game Timer
    U_TIMER: component timer
        port map (
            tick_1hz      => tick_1hz_sig,
            reset_n       => reset_n,
            enable        => timer_enable,
            tick_o        => timer_finished_tick,
            minutes_tens  => timer_mt_s,
            minutes_units => timer_mu_s,
            seconds_tens  => timer_st_s,
            seconds_units => timer_su_s
        );

    -- INSTANCES 5, 6, 7, 8: Four decoders, one for each digit
    U_DECODER_D3: component hex_to_7_seg_decoder
        port map (
            hex_in       => data_d3,
            segments_out => segments_d3
        );
    U_DECODER_D2: component hex_to_7_seg_decoder
        port map (
            hex_in       => data_d2,
            segments_out => segments_d2
        );
    U_DECODER_D1: component hex_to_7_seg_decoder
        port map (
            hex_in       => data_d1,
            segments_out => segments_d1
        );
    U_DECODER_D0: component hex_to_7_seg_decoder
        port map (
            hex_in       => data_d0,
            segments_out => segments_d0
        );

    -- Control Logic: Enable timer only when in timer mode
    timer_enable <= mode_switch;

    -- MUX to select which data to show on which digit based on the mode
    data_selector: process(mode_switch, points_a_tens, points_a_units, points_b_tens, points_b_units, timer_mt_s, timer_mu_s, timer_st_s, timer_su_s)
    begin
        if mode_switch = '0' then -- Scorekeeping Mode
            data_d3 <= points_a_tens;  -- Digit 3 (Leftmost)
            data_d2 <= points_a_units; -- Digit 2
            data_d1 <= points_b_tens;  -- Digit 1
            data_d0 <= points_b_units; -- Digit 0 (Rightmost)
        else -- Timer Mode
            data_d3 <= "000" & timer_mt_s;
            data_d2 <= timer_mu_s;
            data_d1 <= "0" & timer_st_s;
            data_d0 <= timer_su_s;
        end if;
    end process;

    -- Concatenate the outputs of the four decoders into a single 28-bit vector
    -- This drives all 4 displays in parallel.
    -- Mapping:
    -- bits 27-21: Digit 3 (Leftmost)
    -- bits 20-14: Digit 2
    -- bits 13-7:  Digit 1
    -- bits 6-0:   Digit 0 (Rightmost)
    seven_seg_out <= segments_d3 & segments_d2 & segments_d1 & segments_d0;

end architecture structural;
