library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity frequency_divider_tb is
end entity frequency_divider_tb;

architecture testbench of frequency_divider_tb is
  signal i_clk  : std_logic := '0';
  signal o_clk  : std_logic;
  signal rst : std_logic := '0';

  constant clk_period : time := 20 ns;
begin
  clk_1khz_inst: entity work.clk_1khz
    port map(
      i_clk => i_clk,
      rst => rst,
      o_clk => o_clk
    );

  clk_process : process
  begin
    while now < 2 ms loop
      i_clk <= '0';
      wait for clk_period/2;
      i_clk <= '1';
      wait for clk_period/2;
    end loop;
    assert false report "Simulation finished" severity failure;
  end process;
end architecture testbench;

