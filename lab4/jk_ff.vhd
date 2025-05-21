library ieee;
use ieee.std_logic_1164.all;

entity jk_ff is
  port (
    clk  : in  std_logic;
    j    : in  std_logic;
    k    : in  std_logic;
    clrn : in  std_logic; -- clear
    prn  : in  std_logic; -- preset
    q    : out std_logic
  );
end entity jk_ff;

architecture behavioral of jk_ff is
  signal q_reg : std_logic := '0';
begin
  process(clk, clrn, prn)
  begin
    -- asynchronous clear and preset
    if clrn = '0' then
      q_reg <= '0';
    elsif prn = '0' then
      q_reg <= '1';
    elsif rising_edge(clk) then
      case std_logic_vector'(j & k) is
        when "00" => q_reg <= q_reg;
        when "01" => q_reg <= '0';
        when "10" => q_reg <= '1';
        when "11" => q_reg <= not q_reg;
        when others => q_reg <= q_reg;
      end case;
    end if;
  end process;

  q <= q_reg;
end architecture behavioral;
