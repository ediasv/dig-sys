library ieee;
use ieee.std_logic_1164.all;

-- Entidade do testbench, geralmente vazia.
entity contador_9_bits_tb is
end entity contador_9_bits_tb;

architecture bench of contador_9_bits_tb is

    -- 1. Declaração do componente que queremos testar (nossa UUT - Unit Under Test).
    component contador_9bits is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            enable       : in  std_logic;
            endereco_out : out std_logic_vector(8 downto 0)
        );
    end component contador_9bits;

    -- 2. Sinais internos do testbench para conectar à UUT.
    signal s_clk          : std_logic := '0';
    signal s_reset        : std_logic;
    signal s_enable       : std_logic;
    signal s_endereco_out : std_logic_vector(8 downto 0);

    -- 3. Constantes de simulação.
    constant C_CLK_PERIOD : time := 10 ns; -- Período do clock de 10ns (100 MHz).

begin

    -- 4. Instanciação da UUT.
    -- Conecta as portas do componente aos sinais do testbench.
    uut : contador_9bits
        port map (
            clk          => s_clk,
            reset        => s_reset,
            enable       => s_enable,
            endereco_out => s_endereco_out
        );

    -- 5. Processo para geração do clock.
    -- Este processo gera um sinal de clock contínuo com o período definido.
    clk_process : process
    begin
        s_clk <= '0';
        wait for C_CLK_PERIOD / 2;
        s_clk <= '1';
        wait for C_CLK_PERIOD / 2;
    end process clk_process;

    -- 6. Processo de estímulo.
    -- Aqui aplicamos os sinais de entrada (reset, enable) para testar o contador.
    stimulus_process : process
    begin
        -- Início da simulação.
        wait for 1 ns; -- Pequena espera inicial.

        -- Fase 1: Resetar o contador.
        s_reset  <= '1';
        s_enable <= '0';
        wait for 2 * C_CLK_PERIOD; -- Mantém o reset por 2 ciclos.
        s_reset <= '0';
        wait for C_CLK_PERIOD;

        -- Fase 2: Habilitar a contagem por alguns ciclos.
        s_enable <= '1';
        wait for 10 * C_CLK_PERIOD; -- Deixa contar por 10 ciclos (deve ir de 0 a 9).

        -- Fase 3: Pausar a contagem.
        s_enable <= '0';
        wait for 5 * C_CLK_PERIOD; -- O contador deve permanecer no valor 9.

        -- Fase 4: Reabilitar a contagem.
        s_enable <= '1';
        wait for 5 * C_CLK_PERIOD; -- Deixa contar por mais 5 ciclos (deve ir de 10 a 14).

        -- Fim da simulação.
        wait; -- Interrompe o processo de estímulo.
    end process stimulus_process;

end architecture bench;
