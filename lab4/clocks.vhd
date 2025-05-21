library ieee;
use ieee.std_logic_1164.all;

entity clocks is
  port(
    switch : in std_logic;
    rst    : in std_logic;
    i_clk  : in std_logic;
    o_clk  : out std_logic
  );
end entity;

architecture hybrid of clocks is

  component clk_1khz
    port(
      i_clk : in std_logic; -- Pin connected to P11 (N14)
      rst   : in std_logic;
      o_clk : out std_logic -- Can check it using PIN A8 - LEDR0
    );
  end component;

  component clk_50khz
    port(
      i_clk : in std_logic; -- Pin connected to P11 (N14)
      rst   : in std_logic;
      o_clk : out std_logic -- Can check it using PIN A8 - LEDR0
    );
  end component;

  signal clk_1k, clk_50k : std_logic;

begin

  clk_1khz_inst : clk_1khz
   port map(
      i_clk => i_clk,
      rst   => rst,
      o_clk => clk_1k
  );

  clk_50khz_inst : clk_50khz
   port map(
      i_clk => i_clk,
      rst   => rst,
      o_clk => clk_50k
  );

  process(switch)
  begin
    if (switch = '1') then
      o_clk <= clk_50k;
    else 
      o_clk <= clk_1k;
    end if;
  end process;

end architecture hybrid;
