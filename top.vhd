library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector
use ieee.numeric_std.all;


    
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
    signal reading : std_logic_vector(11 downto 0);
    signal valid : std_logic;
    signal ready : std_logic;
    signal output_reading : std_logic_vector(11 downto 0);
    signal sample : std_logic;

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

    begin

        pll_10_inst : entity work.pll_10
            port map (
                inclk0 => MAX10_CLK1_50,
                c0 => clk10,
                locked => locked,
                areset => '0'
            );
        
        adc_inst : unsaved
            port map (
                modular_adc_0_clock_clk => MAX10_CLK1_50,
                clk_clk => MAX10_CLK1_50,
                modular_adc_0_adc_pll_clock_clk => clk10,
                modular_adc_0_adc_pll_locked_export => locked,
                reset_reset_n => KEY(0),
                modular_adc_0_reset_sink_reset_n => KEY(0),
                modular_adc_0_response_valid => valid,
                modular_adc_0_command_ready => ready,
                modular_adc_0_response_data => reading,
                modular_adc_0_command_valid => sample,
                modular_adc_0_command_channel => "00001",
                modular_adc_0_command_startofpacket => '0',
                modular_adc_0_command_endofpacket => '0'
            );
        
        in_adc_inst : entity work.in_adc
            port map (
                clk => MAX10_CLK1_50,
                reset => KEY(0),
                mod_response_data => reading,
                response_valid => valid,
                response_ready => ready,
                response_reading => output_reading,
                sample => sample
            );


        seg0 : entity work.segment
            port map(iDigit => std_logic_vector(output_reading(3 downto 0)), oSegment => HEX0(6 downto 0));
        HEX0(7) <= '1'; -- turn off the decimal point for HEX0
        seg1 : entity work.segment
            port map(iDigit => std_logic_vector(output_reading(7 downto 4)), oSegment => HEX1(6 downto 0));
        HEX1(7) <= '1'; -- turn off the decimal point for HEX1
        seg2 : entity work.segment
            port map(iDigit => std_logic_vector(output_reading(11 downto 8)), oSegment => HEX2(6 downto 0));
        HEX2(7) <= '1'; -- turn off the decimal point for HEX2
        HEX3 <= (others => '1');
        HEX4 <= (others => '1');
        HEX5 <= (others => '1');


end Behavioral;

