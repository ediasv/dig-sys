LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_2para1_8bits IS
    PORT (
        i_A   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada de dados A (8 bits)
        i_B   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada de dados B (8 bits)
        i_SEL : IN  STD_LOGIC;                    -- Sinal de seleção
        o_Y   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- Saída selecionada (8 bits)
    );
END ENTITY mux_2para1_8bits;

ARCHITECTURE rtl OF mux_2para1_8bits IS
BEGIN
    o_Y <= i_A when i_SEL = '0' else i_B;
END ARCHITECTURE rtl;
