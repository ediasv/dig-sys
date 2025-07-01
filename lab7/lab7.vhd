library ieee;
use ieee.std_logic_1164.all;

entity lab7 is
  port(
    N14 : in std_logic; -- clock 50MHz
    B8  : in std_logic -- PB0 (pause)
  );
end entity;

architecture hybrid of lab7 is
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


  component contador_9bits is
    port (
      clk          : in  std_logic; -- Entrada do clock. A lógica síncrona ocorrerá na borda de subida.
      reset        : in  std_logic; -- Reset assíncrono. Quando '1', reinicia o contador imediatamente.
      enable       : in  std_logic; -- Habilitação da contagem. Se '0', o contador para (pausa).
      endereco_out : out std_logic_vector(8 downto 0) -- Saída de 9 bits do valor da contagem.
    );
  end component;

  component mux_2para1_8bits IS
    PORT (
        i_A   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada de dados A (8 bits)
        i_B   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Entrada de dados B (8 bits)
        i_SEL : IN  STD_LOGIC;                    -- Sinal de seleção
        o_Y   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- Saída selecionada (8 bits)
    );
  end component;

  component clk_1khz is
    port(
      i_clk : in std_logic; -- Pin connected to N14 (50MHz clock)
      rst   : in std_logic; -- Reset signal
      o_clk : out std_logic  -- Output clock at 1kHz
    );
  end component;

  component piso_register is
    port (
      clk         : in  std_logic; -- Clock do sistema
      rst         : in  std_logic; -- Reset assíncrono (ativo em '1')
      load_en     : in  std_logic; -- Habilita a carga do dado paralelo
      shift_en    : in  std_logic; -- Habilita o deslocamento do dado
      parallel_in : in  std_logic_vector(7 downto 0); -- Entrada paralela
      serial_out  : out std_logic  -- Saída serial do bit mais significativo (MSB)
    );
  end component;

  component sequence_detector is
    port(
      i_data : in std_logic; -- Entrada de dados
      i_x    : in std_logic_vector(2 downto 0); -- Entrada de controle
      o_j    : out std_logic_vector(2 downto 0); -- Saída J
      o_k    : out std_logic_vector(2 downto 0)  -- Saída K
    );
  end component;

---------- Sinais internos ---------------
  signal endereco_out        : STD_LOGIC_VECTOR(8 downto 0);
  signal barramento_de_dados : STD_LOGIC_VECTOR(7 downto 0);
  signal dados_fks         : STD_LOGIC_VECTOR(7 downto 0);
  signal dados_desc        : STD_LOGIC_VECTOR(7 downto 0);

begin

--------- Instâncias das memórias ---------
  memory_fks_inst: memory_fks
  port map(
    address => endereco_out(7 downto 0), -- Usando os 8 bits mais baixos do endereço
    clock => ,
    q => dados_fks
  );

  memory_desc_inst: memory_desc
  port map(
    address => endereco_out(7 downto 0), -- Usando os 8 bits mais baixos do endereço
    clock => ,
    q => dados_desc
  );

--------- Instância do contador de 9 bits ---------
  contador_9bits_inst: contador_9bits
  port map(
    clk => ,
    reset => '1',
    enable => '1',
    endereco_out => endereco_out
  );

--------- Instância do MUX 2 para 1 de 8 bits ---------
  mux_2para1_8bits_inst: mux_2para1_8bits
  port map(
    i_A => dados_fks,
    i_B => dados_desc,
    i_SEL => endereco_out(8), -- O bit mais significativo do endereço decide a seleção
    o_Y => barramento_de_dados
  );
end architecture;
