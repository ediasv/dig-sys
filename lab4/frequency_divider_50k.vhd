library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_50khz is
	port(
    i_clk : in std_logic; -- Pin connected to P11 (N14)
    rst   : in std_logic;
    o_clk : out std_logic -- Can check it using PIN A8 - LEDR0
  );
end entity clk_50khz;

architecture behavioral of clk_50khz is

  signal count: integer:=1;
  signal clk_internal : std_logic := '0';
  
begin
  
process(i_clk)
begin
  if(rst = '1') then
    count <= 1;
    clk_internal <= '0';
	elsif(i_clk'event and i_clk = '1') then
		count <= count+1;
		if (count = 5000) then
			clk_internal <= NOT clk_internal;
			count <= 1;
		end if;
	end if;
	o_clk <= clk_internal;
end process;

end behavioral;
