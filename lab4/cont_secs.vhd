library ieee;
use ieee.std_logic_1164.all;

entity cont_secs is
  port (
    i_clk     : in std_logic;
    rst       : in std_logic;
    o_clk     : out std_logic;
    sec_units : out std_logic_vector(3 downto 0);
    sec_tens  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture structural of cont_secs is
  component cont_9
    port(
      i_clk : in std_logic;
      o_clk : out std_logic;
      rst   : in std_logic;
      o_x   : out std_logic_vector(3 downto 0)
    );
  end component;

  component cont_5
    port(
      i_clk : in std_logic;
      rst   : in std_logic;
      o_clk : out std_logic;
      o_x   : out std_logic_vector(3 downto 0)
    );
  end component;

  signal internal_clk : std_logic := '0';
begin
  unit : cont_9
    port map (
      i_clk => i_clk,
      rst => rst,
      o_clk => internal_clk,
      o_x => sec_units
    );

  tens : cont_5
    port map(
      i_clk => internal_clk,
      rst => rst,
      o_clk => o_clk,
      o_x => sec_tens
    );
end architecture structural;
