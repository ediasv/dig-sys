library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A entidade do testbench é sempre vazia
entity piso_register_tb is
end entity piso_register_tb;

architecture sim of piso_register_tb is
    -- 1. Declaração do componente a ser testado (DUT - Device Under Test)
    component piso_register is
        generic (
            g_width : natural := 8
        );
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            load_en     : in  std_logic;
            shift_en    : in  std_logic;
            parallel_in : in  std_logic_vector(g_width - 1 downto 0);
            serial_out  : out std_logic
        );
    end component piso_register;

    -- 2. Constantes de simulação
    constant C_CLK_PERIOD : time    := 10 ns; -- Período do clock (para uma frequência de 100 MHz)
    constant C_DATA_WIDTH : natural := 8;     -- Largura do dado, deve ser igual ao do DUT

    -- 3. Sinais para conectar ao DUT
    signal s_clk         : std_logic := '0';
    signal s_rst         : std_logic;
    signal s_load_en     : std_logic;
    signal s_shift_en    : std_logic;
    signal s_parallel_in : std_logic_vector(C_DATA_WIDTH - 1 downto 0);
    signal s_serial_out  : std_logic;

begin

    -- 4. Instanciação do DUT
    UUT : component piso_register
        generic map (
            g_width => C_DATA_WIDTH
        )
        port map (
            clk         => s_clk,
            rst         => s_rst,
            load_en     => s_load_en,
            shift_en    => s_shift_en,
            parallel_in => s_parallel_in,
            serial_out  => s_serial_out
        );

    -- 5. Processo de geração de clock
    p_clk_gen : process
    begin
        -- Gera um clock de 50% de duty cycle indefinidamente
        loop
            s_clk <= '0';
            wait for C_CLK_PERIOD / 2;
            s_clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
    end process p_clk_gen;

    -- 6. Processo de estímulos (onde a mágica do teste acontece)
    p_stimulus : process
    begin
        report "Iniciando Testbench para o PISO Register..." severity note;

        -- Fase 1: Reset inicial
        s_rst         <= '1';
        s_load_en     <= '0';
        s_shift_en    <= '0';
        s_parallel_in <= (others => '0');
        wait for C_CLK_PERIOD * 2; -- Mantém o reset por 2 ciclos
        s_rst <= '0';
        wait for C_CLK_PERIOD;

        -- Fase 2: Carregar o primeiro valor (10100101 -> A5 em hexa)
        report "Teste 1: Carregando valor 0xA5" severity note;
        s_load_en     <= '1';
        s_parallel_in <= x"A5"; -- 10100101
        wait for C_CLK_PERIOD;
        s_load_en <= '0';
        wait for C_CLK_PERIOD; -- Aguarda um ciclo para estabilizar

        -- Fase 3: Deslocar os 8 bits para fora
        report "Iniciando deslocamento..." severity note;
        s_shift_en <= '1';
        for i in 1 to C_DATA_WIDTH + 2 loop -- Desloca por 10 ciclos para ver a limpeza
            wait for C_CLK_PERIOD;
            -- A cada ciclo, a saída s_serial_out mostrará um novo bit.
            -- A sequência esperada na saída serial é: 1, 0, 1, 0, 0, 1, 0, 1
        end loop;
        s_shift_en <= '0';
        wait for C_CLK_PERIOD * 2;

        -- Fase 4: Carregar o segundo valor (11110000 -> F0 em hexa)
        report "Teste 2: Carregando valor 0xF0" severity note;
        s_load_en     <= '1';
        s_parallel_in <= x"F0"; -- 11110000
        wait for C_CLK_PERIOD;
        s_load_en <= '0';
        wait for C_CLK_PERIOD;
        
        -- Fase 5: Deslocar o segundo valor
        report "Iniciando segundo deslocamento..." severity note;
        s_shift_en <= '1';
        for i in 1 to C_DATA_WIDTH + 2 loop
            wait for C_CLK_PERIOD;
             -- A sequência esperada na saída serial é: 1, 1, 1, 1, 0, 0, 0, 0
        end loop;
        s_shift_en <= '0';

        -- Fim da simulação
        report "Simulacao concluida com sucesso." severity note;
        -- A asserção false com severity failure para o GHDL parar a execução.
        assert false report "Fim da simulação." severity failure;

        wait; -- Espera para sempre
    end process p_stimulus;

end architecture sim;
