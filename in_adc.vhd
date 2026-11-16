library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector
use ieee.numeric_std.all;

entity in_adc is
    port (
        mod_response_data : in std_logic_vector(11 downto 0); -- data
        response_valid : in std_logic; -- valid
        response_ready : in std_logic; -- ready
        response_reading :out std_logic; -- reading
        clk : in std_logic; -- clock
        reset : in std_logic -- reset
    );
end entity in_adc;

architecture Behavioral of in_adc is
    signal reading : std_logic;
    signal data : std_logic_vector(11 downto 0);
    signal valid : std_logic;
    signal ready : std_logic;
    
    begin

    end behavioral;