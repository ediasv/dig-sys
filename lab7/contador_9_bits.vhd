library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A Entidade define a "caixa preta" do nosso componente, suas portas de entrada e saída.
entity contador_9bits is
    port (
        clk          : in  std_logic; -- Entrada do clock. A lógica síncrona ocorrerá na borda de subida.
        reset        : in  std_logic; -- Reset assíncrono. Quando '1', reinicia o contador imediatamente.
        enable       : in  std_logic; -- Habilitação da contagem. Se '0', o contador para (pausa).
        endereco_out : out std_logic_vector(8 downto 0) -- Saída de 9 bits do valor da contagem.
    );
end entity contador_9bits;

-- A Arquitetura descreve o funcionamento interno do componente.
architecture rtl of contador_9bits is

    -- Sinal interno para armazenar o valor da contagem.
    -- Usamos um sinal interno porque portas do tipo 'out' não podem ser lidas
    -- dentro da arquitetura. O tipo 'unsigned' facilita as operações aritméticas.
    signal count_reg : unsigned(8 downto 0);

begin

    -- Processo síncrono que descreve o comportamento do contador.
    -- A lista de sensibilidade contém 'clk' e 'reset', pois o reset é assíncrono.
    process (clk, reset)
    begin
        -- 1. Lógica de Reset (Assíncrono)
        -- Se o sinal de reset estiver ativo ('1'), o contador é zerado imediatamente,
        -- independentemente do clock.
        if reset = '1' then
            count_reg <= (others => '0');

        -- 2. Lógica Síncrona (ocorre na borda de subida do clock)
        elsif rising_edge(clk) then
            -- A contagem só é modificada se o sinal 'enable' estiver ativo.
            if enable = '1' then
                -- Incrementa o registrador. O tipo 'unsigned' permite o uso
                -- direto do operador '+'. O wrap-around (de 1FF para 000)
                -- ocorre automaticamente devido à largura finita do vetor.
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    -- Atribuição concorrente: O valor do nosso registrador interno (unsigned)
    -- é continuamente atribuído à porta de saída, com a devida conversão
    -- de tipo para std_logic_vector.
    endereco_out <= std_logic_vector(count_reg);

end architecture rtl;
