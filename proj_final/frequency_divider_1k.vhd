library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_1khz is
	port(
    clk_i : in std_logic; -- Pin connected to P11 (N14)
    rst   : in std_logic;
    clk_o : out std_logic -- Can check it using PIN A8 - LEDR0
  );

end entity clk_1khz;

architecture behavioral of clk_1khz is

  signal count: integer:=1;
  signal clk_internal : std_logic := '0';
  
begin
  
process(clk_i)
begin
  if(rst = '1') then
    count <= 1;
    clk_internal <= '0';
	elsif(clk_i'event and clk_i = '1') then
		count <= count+1;
		if (count = 25000) then
			clk_internal <= NOT clk_internal;
			count <= 1;
		end if;
	end if;
	clk_o <= clk_internal;
end process;

end behavioral;
