library ieee;
use ieee.std_logic_1164.all;

entity bloco8 is
  port (
    A      : in  std_logic_vector(3 downto 0);
    B      : in  std_logic_vector(3 downto 0);
    C      : in  std_logic_vector(3 downto 0);
    D      : in  std_logic_vector(3 downto 0);
    S0, S1 : in  std_logic;
    X      : out std_logic_vector(3 downto 0)
  );
end entity bloco8;

architecture rtl of bloco8 is
begin
  gen_mux: for i in 0 to 3 generate
    X(i) <= (A(i) and not(S0) and not(S1)) or
            (B(i) and not(S1) and S0) or
            (C(i) and S1 and not(S0)) or
            (D(i) and S1 and S0);
  end generate gen_mux;
end architecture rtl;
