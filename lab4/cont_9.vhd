library ieee;
use ieee.std_logic_1164.all;

entity cont_9 is
  port (
    i_clk : in std_logic;
    rst   : in std_logic;
    o_clk : out std_logic;
    o_x   : out std_logic_vector(3 downto 0)
  );
end entity cont_9;

architecture hybrid of cont_9 is
  component fsm_9
    port(
      x : in std_logic_vector(3 downto 0);
      j : out std_logic_vector(3 downto 0);
      k : out std_logic_vector(3 downto 0)
    );
  end component;

  component jk_ff
    port(
      clk  : in  std_logic;
      j    : in  std_logic;
      k    : in  std_logic;
      clrn : in  std_logic; -- clear
      prn  : in  std_logic; -- preset
      q    : out std_logic
    );
  end component;

  signal x_internal     : std_logic_vector(3 downto 0) := "0000";
  signal j_internal     : std_logic_vector(3 downto 0) := "0000";
  signal k_internal     : std_logic_vector(3 downto 0) := "0000";
  signal tc             : std_logic := '0';
  signal tc_d           : std_logic := '0';
  signal o_clk_internal : std_logic := '0';

begin

  fsm_9_inst : fsm_9
  port map(
    x => x_internal,
    j => j_internal,
    k => k_internal
  );

  jk_ff_gen: for i in 0 to 3 generate
    jk_ff_inst: jk_ff
    port map (
      clk  => i_clk,
      j    => j_internal(i),
      k    => k_internal(i),
      clrn => rst,
      prn  => '1',
      q    => x_internal(i)
    );
  end generate jk_ff_gen;

  --------------------------------------------------------------------------
  -- logica para mandar um pulso quando a maquina de estados terminar um loop
  tc <= '1' when x_internal = "1001" else '0';

  process(i_clk)
  begin
    if falling_edge(i_clk) then 
      if tc_d = '1' and tc = '0' then 
        o_clk_internal <= '1';
      else
        o_clk_internal <= '0';
      end if;
      tc_d <= tc;
    end if;
  end process;
  --------------------------------------------------------------------------

  o_clk <= o_clk_internal;
  o_x <= x_internal;
end architecture hybrid;
