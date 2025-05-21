library IEEE;
use ieee.std_logic_1164.all;

entity lab04 is
    port (
        B8  : in std_logic; -- PB0 (pause)
        A7  : in std_logic; -- PB1 (rst)
        C10 : in std_logic; -- SW0 (switch)
        N14 : in std_logic; -- clock 50MHz
        HEX : out std_logic_vector(41 downto 0)
    );
end entity lab04;

architecture lab04_arch of lab04 is
  --decoder, contadores, pause, FF
    component ms_counter
        port (
            input_clk  : in  std_logic;
            output_clk : out  std_logic;
            ms_units   : out  std_logic_vector(3 downto 0);
            ms_tens    : out  std_logic_vector(3 downto 0);
            ms_hundreds: out  std_logic_vector(3 downto 0)
        );
    end component;
    
    component sec_counter
        port (
            input_clk  : in  std_logic;
            output_clk : out  std_logic;
            sec_units   : out  std_logic_vector(3 downto 0);
            sec_tens    : out  std_logic_vector(3 downto 0)
        );
    end component;
    
    component min_counter
        port (
            input_clk  : in  std_logic;
            output_clk : out  std_logic;
            min_units   : out  std_logic_vector(3 downto 0)
        );
    end component;
    
    component clocks
        port(
            switch : in  std_logic;
            reset: in std_logic;
            input_clk: in std_logic;
            output_clk: out std_logic
        );
    end component;
    
    component pause
        port (
            ms_units   : in  std_logic_vector(3 downto 0);
            ms_tens    : in  std_logic_vector(3 downto 0);
            ms_hundreds: in  std_logic_vector(3 downto 0);
            sec_units   : in  std_logic_vector(3 downto 0);
            sec_tens    : in  std_logic_vector(3 downto 0);
            min_units   : in  std_logic_vector(3 downto 0);
            pause      : out std_logic
        );
    end component;
   
    component DECODER
        port (
           X : in  std_logic_vector(3 downto 0);
           S : out std_logic_vector(6 downto 0)
        );
    end component;

    component jk_ff
        port (
			clk  : in  std_logic;
			j    : in  std_logic;
			k    : in  std_logic;
			clrn : in  std_logic; -- clear
			prn  : in  std_logic; -- preset
			q    : out std_logic
        );
    end component;

    signal rst_intermediary    : std_logic := '0';
    signal pb0_intermediary    : std_logic := '0';
	 
	 signal b8_sync, b8_prev : std_logic := '0';
	 signal pause_sync, pause_prev : std_logic := '0';

    signal toggle_clk           : std_logic := '0';
    signal pause_from_detector : std_logic := '0';
    signal pause_and           : std_logic := '0';
    signal pause_jk            : std_logic := '0';  
    
    signal clk_converted       : std_logic;
	 
	 -- Sinais dos contadores
		signal ms_units     : std_logic_vector(3 downto 0);
		signal ms_tens      : std_logic_vector(3 downto 0);
		signal ms_hundreds  : std_logic_vector(3 downto 0);
		signal sec_units    : std_logic_vector(3 downto 0);
		signal sec_tens     : std_logic_vector(3 downto 0);
		signal min_units    : std_logic_vector(3 downto 0);

		-- Vetores agrupados para facilitar uso com generate
		signal digits_bcd : std_logic_vector(23 downto 0); -- 6 dígitos BCD (6×4 bits)
		signal hex_output : std_logic_vector(41 downto 0); -- 6 displays (6×7 bits)
		
        signal ms_clk_pulse  : std_logic;
        signal sec_clk_pulse : std_logic;
begin

digits_bcd( 3 downto  0) <= ms_units;
digits_bcd( 7 downto  4) <= ms_tens;
digits_bcd(11 downto  8) <= ms_hundreds;
digits_bcd(15 downto 12) <= sec_units;
digits_bcd(19 downto 16) <= sec_tens;
digits_bcd(23 downto 20) <= min_units;



process(N14)
begin
    if rising_edge(N14) then
        -- Sincronizações
        b8_prev <= b8_sync;
        b8_sync <= B8;

        pause_prev <= pause_sync;
        pause_sync <= pause_from_detector;

        -- XOR após sincronização
        toggle_clk <= (b8_sync and not b8_prev) xor (pause_sync and not pause_prev);
		  --toggle_clk <= b8_sync and not b8_prev;  -- Gera um pulso apenas na borda de subida de PB0

    end if;
end process;


  pause_jkff_inst : jk_ff
   port map(
      clk => toggle_clk,
      j    => '1',
      k    => '1',
      clrn => '1',
      prn  => '1',
      q    => pause_jk
  );
  
  pause_detector_inst : pause
  port map (
    ms_units    => ms_units,
    ms_tens     => ms_tens,
    ms_hundreds => ms_hundreds,
    sec_units   => sec_units,
    sec_tens    => sec_tens,
   min_units   => min_units,
    pause       => pause_from_detector
  );
  
gen_decoders : for i in 0 to 5 generate
    decoder_inst : DECODER
        port map (
            X => digits_bcd((i+1)*4 - 1 downto i*4),
            S => HEX((i+1)*7 - 1 downto i*7)
        );
end generate;

clk_gen_inst : clocks
  port map (
    switch     => C10,
    reset      => not A7,
    input_clk  => N14,
    output_clk => clk_converted
  );

ms_cnt_inst : ms_counter
  port map (
    input_clk   => clk_converted and not pause_jk,
    output_clk  => ms_clk_pulse,  
    ms_units    => ms_units,
    ms_tens     => ms_tens,
    ms_hundreds => ms_hundreds
  );

sec_cnt_inst : sec_counter
  port map (
    input_clk  => ms_clk_pulse and not pause_jk,
    output_clk => sec_clk_pulse,
    sec_units  => sec_units,
    sec_tens   => sec_tens
  );

min_cnt_inst : min_counter
  port map (
    input_clk  => sec_clk_pulse and not pause_jk,
    output_clk => open,
    min_units  => min_units
  );

   
end architecture lab04_arch;
