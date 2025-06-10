library ieee;
use ieee.std_logic_1164.all;

-- Entidade do registrador PISO
entity piso_register is
    port (
        -- Sinais de Controle
        clk        : in  std_logic; -- Clock do sistema
        rst        : in  std_logic; -- Reset assíncrono (ativo em '1')
        load_en    : in  std_logic; -- Habilita a carga do dado paralelo
        shift_en   : in  std_logic; -- Habilita o deslocamento do dado

        -- Entradas e Saídas de Dados
        parallel_in : in  std_logic_vector(7 downto 0); -- Entrada paralela
        serial_out  : out std_logic  -- Saída serial do bit mais significativo (MSB)
    );
end entity piso_register;

-- Arquitetura do registrador PISO
architecture rtl of piso_register is
    -- Sinal interno para armazenar o estado do registrador
    signal s_data_reg : std_logic_vector(7 downto 0);

begin

    -- Processo principal, sensível ao clock e ao reset assíncrono
    p_shift_reg : process (clk, rst)
    begin
        -- Lógica de Reset Assíncrono: limpa o registrador
        if rst = '1' then
            s_data_reg <= (others => '0');

        -- Lógica na borda de subida do clock
        elsif rising_edge(clk) then
            -- A carga paralela tem prioridade sobre o deslocamento
            if load_en = '1' then
                s_data_reg <= parallel_in;
            
            -- Se a carga não está habilitada, verifica o deslocamento
            elsif shift_en = '1' then
                -- Desloca o registrador para a esquerda, inserindo '0' no LSB
                s_data_reg <= s_data_reg(6 downto 0) & '0';
            end if;
            -- Se nem load_en nem shift_en estiverem ativos, o registrador mantém seu valor.
        end if;
    end process p_shift_reg;

    -- Atribuição contínua (concorrente) para a saída serial.
    -- A saída serial é sempre o bit mais significativo (MSB) do registrador interno.
    -- Este é um comportamento típico de máquina de Moore, onde a saída depende apenas do estado.
    serial_out <= s_data_reg(7);

end architecture rtl;
