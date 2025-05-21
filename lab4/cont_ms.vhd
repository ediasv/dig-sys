library ieee;
use ieee.std_logic_1164.all;

entity cont_ms is
  port (
    i_clk       : in std_logic;
    rst         : in std_logic;
    o_clk       : out std_logic;
    ms_unit     : out std_logic_vector(3 downto 0);
    ms_tens     : out std_logic_vector(3 downto 0);
    ms_hundreds : out std_logic_vector(3 downto 0)
  );
end entity;

architecture structural of cont_ms is
  component cont_9
    port(
      i_clk : in std_logic;
      rst   : in std_logic;
      o_clk : out std_logic;
      o_x   : out std_logic_vector(3 downto 0)
    );
  end component;

  signal unit_to_tens : std_logic := '0';
  signal tens_to_hundreds : std_logic := '0';
begin
  unit : cont_9
    port map (
      i_clk => i_clk,
      rst => rst,
      o_clk => unit_to_tens,
      o_x => ms_unit
    );

  tens : cont_9
    port map (
      i_clk => unit_to_tens,
      o_clk => tens_to_hundreds,
      rst => rst,
      o_x => ms_tens
    );

  hundreds: cont_9
    port map (
      i_clk => tens_to_hundreds,
      o_clk => o_clk,
      rst => rst,
      o_x => ms_hundreds
    );
end architecture structural;
