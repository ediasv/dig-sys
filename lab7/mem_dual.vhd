library ieee;
use ieee.std_logic_1164.all;

entity mem_dual is
  port (
    clk          : in std_logic; -- Clock input
    address      : in std_logic_vector(7 downto 0); -- Address input (8 bits)
    mem_select_i : in std_logic; -- Memory select input (0 for mem1, 1 for mem2)
    data_out     : out std_logic_vector(7 downto 0) -- Data output (8 bits)
  );
end entity mem_dual;

architecture hybrid of mem_dual is
  component memory_fks is
    port
    (
      address : in std_logic_vector (7 downto 0);
      clock   : in std_logic := '1';
      q       : out std_logic_vector (7 downto 0)
    );
  end component;

  component memory_desc is
    port
    (
      address : in std_logic_vector (7 downto 0);
      clock   : in std_logic := '1';
      q       : out std_logic_vector (7 downto 0)
    );
  end component;

  component mux_2para1_8bits is
    port (
      i_A   : in  std_logic_vector(7 downto 0); -- Input A (8 bits)
      i_B   : in  std_logic_vector(7 downto 0); -- Input B (8 bits)
      i_SEL : in  std_logic;                    -- Select signal
      o_Y   : out std_logic_vector(7 downto 0)  -- Output (8 bits)
    );
  end component;

  signal mux_A : std_logic_vector(7 downto 0);
  signal mux_B : std_logic_vector(7 downto 0);

begin

  memory_fks_inst: memory_fks
   port map(
      address => address,
      clock => clk,
      q => mux_A
  );

  memory_desc_inst: memory_desc
   port map(
      address => address,
      clock => clk,
      q => mux_B
  );

  mux_2para1_8bits_inst: mux_2para1_8bits
   port map(
      i_A => mux_A,
      i_B => mux_B,
      i_SEL => mem_select_i,
      o_Y => data_out
  );
end architecture hybrid;
