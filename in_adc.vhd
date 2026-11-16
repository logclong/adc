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
        
    

end Behavioral;



-----------------------------------------------------------------------------------------
architecture behavorial of counter is
    type state is (IDLE, Button_PRESSED, DEBOUNCE, DEBOUNCE_RELEASE, RESET);
    signal current_state, next_state : state;
    signal add_button : std_logic := '0';
    signal debounce_count, next_debounce_count : integer range 0 to 500000 := 100;
    signal count_int, next_count_int : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, key)
    begin
        if rising_edge(clk) then
            add_button <= KEY(1);
            if KEY(0) = '0' then 
                current_state <= RESET;
                debounce_count <= 50000;
            else
                current_state <= next_state;
                count_int <= next_count_int;
                debounce_count <= next_debounce_count;
            end if;
        end if;
    end process;

    process(current_state, add_button, debounce_count, count_int)
    begin
        case current_state is
            when IDLE =>
                next_count_int <= count_int;
                if add_button = '0' then
                    next_state <= Button_PRESSED;
                else
                    next_state <= IDLE;
                end if;
                next_debounce_count <= 50000;

            when Button_PRESSED =>
                next_count_int <= count_int;
                next_state <= DEBOUNCE;
                next_debounce_count <= 50000;

            when DEBOUNCE =>
                next_count_int <= count_int;
                next_debounce_count <= debounce_count;
                if debounce_count = 0 then
                    next_state <= DEBOUNCE_RELEASE;
                    next_count_int <= count_int + 1;
                else
                    next_state <= DEBOUNCE;
                    next_debounce_count <= debounce_count - 1;
                end if;

            when DEBOUNCE_RELEASE =>
                next_count_int <= count_int;
                next_debounce_count <= debounce_count;
                if add_button = '1' then
                    next_state <= IDLE;
                else
                    next_state <= DEBOUNCE_RELEASE;
                end if;

            when RESET =>
                next_count_int <= (others => '0');
                next_state <= IDLE;
                next_debounce_count <= 50000;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

    count <= std_logic_vector(count_int);

end architecture behavorial;