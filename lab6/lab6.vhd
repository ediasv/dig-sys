library ieee;
use ieee.std_logic_1164.all;

entity lab6 is
  port(
    switch : in std_logic;
    clk : in std_logic;
    s   : out std_logic_vector(6 downto 0)
  );
end entity;

architecture structural of lab6 is

  component sequence_detector
    port(
      i_data : in std_logic;
      i_x    : in std_logic_vector(2 downto 0);
      o_j    : out std_logic_vector(2 downto 0);
      o_k    : out std_logic_vector(2 downto 0)
    );
  end component;

  component hex_to_7_seg_decoder
    port (
        hex_in       : in  std_logic_vector(3 downto 0);
        segments_out : out std_logic_vector(6 downto 0)
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

  signal j_internal : std_logic_vector(2 downto 0);
  signal k_internal : std_logic_vector(2 downto 0);
  signal jk_output : std_logic_vector(2 downto 0);

begin

  jk_ff_gen: for i in 0 to 2 generate
    jk_ff_inst: jk_ff
    port map (
      clk  => clk,
      j    => j_internal(i),
      k    => k_internal(i),
      clrn => '1',
      prn  => '1',
      q    => jk_output(i)
    );
  end generate jk_ff_gen;
  
  sequence_detector_inst: sequence_detector
  port map(
    i_data => switch,
    i_x => jk_output,
    o_j => j_internal,
    o_k => k_internal
  );

  hex_to_7_seg_decoder_inst: hex_to_7_seg_decoder
   port map(
    hex_in => '0' & jk_output(2 downto 0),
    segments_out => s
  );

end architecture structural;
