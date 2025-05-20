library ieee;
use ieee.std_logic_1164.all;

entity cont_59 is
  port (
    i_clk : in std_logic;
    o_clk : out std_logic;
    segments_out : out std_logic_vector(13 downto 0)
  );
end entity;

architecture behavioral of cont_59 is
  component cont_9
    port(
      i_clk : in std_logic;
      o_clk : out std_logic;
      segments_out : out std_logic_vector(6 downto 0)
    );
  end component;

  component cont_5
    port(
      i_clk : in std_logic;
      o_clk : out std_logic;
      segments_out : out std_logic_vector(6 downto 0)
    );
  end component;

  signal internal_clk : std_logic := '0';
begin
  sec_units : cont_9
    port map (
      i_clk => i_clk,
      o_clk => internal_clk,
      segments_out => segments_out(13 downto 7)
    );

  sec_tens : cont_5
    port map(
      i_clk => internal_clk,
      o_clk => o_clk,
      segments_out => segments_out(6 downto 0)
    );
end architecture behavioral;
