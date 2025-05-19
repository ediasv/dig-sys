library ieee;
use ieee.std_logic_1164.all;

entity cont_999 is
  port (
    i_clk : in std_logic;
    o_clk : out std_logic;
    segments_out : out std_logic_vector(20 downto 0)
  );
end entity;

architecture behavioral of cont_999 is
  component cont_9
    port(
      i_clk : in std_logic;
      o_clk : out std_logic;
      segments_out : out std_logic_vector(6 downto 0)
    );
  end component;

  signal internal_clk_1 : std_logic := '0';
  signal internal_clk_2 : std_logic := '0';
begin
  u0: cont_9
    port map (
      i_clk => i_clk,
      o_clk => internal_clk_1,
      segments_out => segments_out(6 downto 0)
    );

  u1: cont_9
    port map (
      i_clk => internal_clk_1,
      o_clk => internal_clk_2,
      segments_out => segments_out(13 downto 7)
    );

  u2: cont_9
    port map (
      i_clk => internal_clk_2,
      o_clk => o_clk,
      segments_out => segments_out(20 downto 14)
    );
end architecture behavioral;
