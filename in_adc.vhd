library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector
use ieee.numeric_std.all;

entity in_adc is
    port (
        mod_response_data : in std_logic_vector(11 downto 0); -- data
        response_valid : in std_logic; -- valid
        response_ready : in std_logic; -- ready
        clk : in std_logic; -- clock
        reset : in std_logic; -- reset
        response_reading :out std_logic_vector(11 downto 0); -- reading
        sample : out std_logic
    );
end entity in_adc;

architecture Behavioral of in_adc is
    signal reading : std_logic;
    signal data : std_logic_vector(11 downto 0);
    signal valid : std_logic;
    signal ready : std_logic;
    signal count : unsigned(25 downto 0) := (others => '0');
    signal do_sample : std_logic := '0';

    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if count /= 50000000 then
                    do_sample <= '0';
                    count <= count + 1;
                else
                    do_sample <= '1';
                    if response_valid = '1' then
                        count <= (others => '0');
                        data <= mod_response_data;
                    end if;
                end if;
                if reset = '0' then
                    count <= (others => '0');
                    data <= (others => '0');
                    do_sample  <= '0';
                end if;
            end if;
        end process;


    response_reading <= data;
    sample <= do_sample;

    end behavioral;