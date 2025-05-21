library ieee;
use ieee.std_logic_1164.all;

entity lab4 is 
  port(
    B8  : in std_logic; -- PB0 (pause)
    A7  : in std_logic; -- PB1 (rst)
    C10 : in std_logic; -- SW0 (switch)
    N14 : in std_logic; -- clock 50MHz
    HEX : out std_logic_vector(41 downto 0)
  );
end entity;

architecture hybrid of lab4 is 
  component cont_9
    port(
      i_clk : in std_logic;
      rst   : in std_logic;
      o_clk : out std_logic;
      o_x   : out std_logic_vector(3 downto 0)
    );
  end component;

  component cont_ms
    port (
      i_clk       : in std_logic;
      rst         : in std_logic;
      o_clk       : out std_logic;
      ms_unit     : out std_logic_vector(3 downto 0);
      ms_tens     : out std_logic_vector(3 downto 0);
      ms_hundreds : out std_logic_vector(3 downto 0)
    );
  end component;

  component cont_secs
    port (
      i_clk     : in std_logic;
      rst       : in std_logic;
      o_clk     : out std_logic;
      sec_units : out std_logic_vector(3 downto 0);
      sec_tens  : out std_logic_vector(3 downto 0)
    );
  end component;

  component hex_to_7_seg_decoder
    port (
        hex_in       : in  std_logic_vector(3 downto 0); 
        segments_out : out std_logic_vector(6 downto 0) 
    );
  end component;

  component pause_detector
    port(
      ms_unit     : in std_logic_vector(3 downto 0);
      ms_tens     : in std_logic_vector(3 downto 0);
      ms_hundreds : in std_logic_vector(3 downto 0);
      sec_unit    : in std_logic_vector(3 downto 0);
      sec_tens    : in std_logic_vector(3 downto 0);
      min         : in std_logic_vector(3 downto 0);
      pause       : out std_logic
    );
  end component;

  component jk_ff
    port (
      clk  : in  std_logic;
      j    : in  std_logic;
      k    : in  std_logic;
      clrn : in  std_logic; -- clear
      prn  : in  std_logic; -- preset
      q    : out std_logic
    );
  end component;

  component clocks 
    port(
      switch : in std_logic;
      rst    : in std_logic;
      i_clk  : in std_logic;
      o_clk  : out std_logic
    );
  end component;

  signal ms_unit_internal : std_logic_vector(3 downto 0);
  signal ms_tens_internal : std_logic_vector(3 downto 0);
  signal ms_hundreds_internal : std_logic_vector(3 downto 0);
  signal sec_unit_internal : std_logic_vector(3 downto 0);
  signal sec_tens_internal : std_logic_vector(3 downto 0);
  signal min_internal : std_logic_vector(3 downto 0);

  signal clk_internal : std_logic;

  signal sec_out_clock : std_logic := '0';
  signal ms_out_clock : std_logic := '0';

  signal pause_sync, pause_prev : std_logic := '0';
  signal b8_sync, b8_prev : std_logic := '0';
  signal toggle_clk           : std_logic := '0';
  signal pause_from_detector : std_logic := '0';
  signal pause_jk            : std_logic := '0';  
begin

process(N14)
begin
    if rising_edge(N14) then
        b8_prev <= b8_sync;
        b8_sync <= B8;

        pause_prev <= pause_sync;
        pause_sync <= pause_from_detector;

        toggle_clk <= (b8_sync and not b8_prev) xor (pause_sync and not pause_prev);
    end if;
end process;

  pause_jkff_inst : jk_ff
   port map(
      clk => toggle_clk,
      j    => '1',
      k    => '1',
      clrn => '1',
      prn  => '1',
      q    => pause_jk
  );

  clocks_inst: clocks
   port map(
      switch => C10,
      rst => not A7,
      i_clk => N14,
      o_clk => clk_internal
  );
 
  pause_detector_inst: pause_detector
   port map(
      ms_unit => ms_unit_internal,
      ms_tens => ms_tens_internal,
      ms_hundreds => ms_hundreds_internal,
      sec_unit => sec_unit_internal,
      sec_tens => sec_tens_internal,
      min => min_internal,
      pause => pause_from_detector
  );

  ----------------------------------------------------------
  --------------- DECODERS ---------------------------------

  hex0: hex_to_7_seg_decoder
   port map(
      hex_in => ms_unit_internal,
      segments_out => HEX(6 downto 0)
  );

  hex1: hex_to_7_seg_decoder
   port map(
      hex_in => ms_tens_internal,
      segments_out => HEX(13 downto 7)
  );

  hex2: hex_to_7_seg_decoder
   port map(
      hex_in => ms_hundreds_internal,
      segments_out => HEX(20 downto 14)
  );

  hex3: hex_to_7_seg_decoder
   port map(
      hex_in => sec_unit_internal,
      segments_out => HEX(27 downto 21)
  );

  hex4: hex_to_7_seg_decoder
   port map(
      hex_in => sec_tens_internal,
      segments_out => HEX(34 downto 28)
  );

  hex5: hex_to_7_seg_decoder
   port map(
      hex_in => min_internal,
      segments_out => HEX(41 downto 35)
  );

  ----------------------------------------------------------
  --------------- CONTADORES ---------------------------------

  min: cont_9
   port map(
      i_clk => sec_out_clock,
      rst => A7,
      o_clk => open,
      o_x => min_internal
  );

  cont_secs_inst: cont_secs
   port map(
      i_clk => ms_out_clock,
      rst => A7,
      o_clk => sec_out_clock,
      sec_units => sec_unit_internal,
      sec_tens => sec_tens_internal
  );

  cont_ms_inst: cont_ms
   port map(
      i_clk => clk_internal and not pause_jk,
      rst => A7,
      o_clk => ms_out_clock,
      ms_unit => ms_unit_internal,
      ms_tens => ms_tens_internal,
      ms_hundreds => ms_hundreds_internal
  );

end architecture hybrid;
