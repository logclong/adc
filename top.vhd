library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector
use ieee.numeric_std.all;

component unsaved is
    port (
        clk_clk                              : in  std_logic                     := 'X';             -- clk
        clk_0_clk_clk                        : out std_logic;                                        -- clk
        clk_0_clk_reset_reset_n              : out std_logic;                                        -- reset_n
        modular_adc_0_adc_pll_clock_clk      : in  std_logic                     := 'X';             -- clk
        modular_adc_0_adc_pll_locked_export  : in  std_logic                     := 'X';             -- export
        modular_adc_0_clock_clk              : in  std_logic                     := 'X';             -- clk
        modular_adc_0_command_valid          : in  std_logic                     := 'X';             -- valid
        modular_adc_0_command_channel        : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- channel
        modular_adc_0_command_startofpacket  : in  std_logic                     := 'X';             -- startofpacket
        modular_adc_0_command_endofpacket    : in  std_logic                     := 'X';             -- endofpacket
        modular_adc_0_command_ready          : out std_logic;                                        -- ready
        modular_adc_0_reset_sink_reset_n     : in  std_logic                     := 'X';             -- reset_n
        modular_adc_0_response_valid         : out std_logic;                                        -- valid
        modular_adc_0_response_channel       : out std_logic_vector(4 downto 0);                     -- channel
        modular_adc_0_response_data          : out std_logic_vector(11 downto 0);                    -- data
        modular_adc_0_response_startofpacket : out std_logic;                                        -- startofpacket
        modular_adc_0_response_endofpacket   : out std_logic;                                        -- endofpacket
        reset_reset_n                        : in  std_logic                     := 'X'              -- reset_n
    );
end component unsaved;
    
entity adc_top is
    port (
        MAX10_CLK1_50 : in  std_logic; -- clock
        KEY : in  std_logic_vector(1 downto 0);
        HEX0 : out std_logic_vector(7 downto 0); -- 7-segment display
        HEX1 : out std_logic_vector(7 downto 0); -- 7-segment display
        HEX2 : out std_logic_vector(7 downto 0); -- 7-segment display
        HEX3 : out std_logic_vector(7 downto 0); -- 7-segment display
        HEX4 : out std_logic_vector(7 downto 0); -- 7-segment display
        HEX5 : out std_logic_vector(7 downto 0) -- 7-segment display
    );
end entity adc_top;

architecture Behavioral of adc_top is
    signal clk10 : std_logic;
    signal rdreq : std_logic;
    signal wrreq : std_logic;
    signal rdusedw : std_logic_vector(2 downto 0);
    signal q : std_logic_vector(9 downto 0);
    signal locked : std_logic;

    begin

        pll_10_inst : entity work.pll_10
            port map (
                inclk0 => MAX10_CLK1_50,
                c0 => clk10
            );
        
        adc_inst : entity work.unsaved
            port map (
                clk_clk => clk5,
                modular_adc_0_adc_pll_locked_export => KEY(0),
                areset => '0'
            );