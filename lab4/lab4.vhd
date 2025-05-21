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
      o_clk : out std_logic;
      o_x   : out std_logic_vector(3 downto 0)
    );
  end component;

  component cont_ms
    port (
      i_clk       : in std_logic;
      o_clk       : out std_logic;
      ms_unit     : out std_logic_vector(3 downto 0);
      ms_tens     : out std_logic_vector(3 downto 0);
      ms_hundreds : out std_logic_vector(3 downto 0)
    );
  end component;

  component cont_secs
    port (
      i_clk     : in std_logic;
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

  signal rst_internal : std_logic := '0';
  signal pb0_internal : std_logic := '0';

  signal pause_xor           : std_logic := '0';
  signal pause_from_detector : std_logic := '0';
  signal pause_and           : std_logic := '0';
  signal pause_jk            : std_logic := '0';

  signal clk_converted : std_logic;

begin

  rst_internal <= not A7;
  pb0_internal <= not B8;

  pause_and <= clk_converted and pause_jk;

  process(B8, pause_from_detector)
  begin
    if (rising_edge(B8) or rising_edge(pause_from_detector)) then 
      pause_xor <= B8 xor pause_from_detector; 
    end if;
  end process;

  pause_jkff_inst : jk_ff
   port map(
      clk => pause_xor,
      j    => '1',
      k    => '1',
      clrn => '1',
      prn  => '1',
      q    => pause_jk
  );

end architecture hybrid;
