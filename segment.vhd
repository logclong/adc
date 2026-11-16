library ieee;
use ieee.std_logic_1164.all;   -- std_logic, std_logic_vector
use ieee.numeric_std.all;


entity segment is

    port(
        iDigit : in std_logic_vector(3 downto 0);
        oSegment : out std_logic_vector(6 downto 0)
    );

end entity segment;

architecture Behavioral of segment is

begin

    process(iDigit)
    begin
        case iDigit is
            when "0000" => oSegment <= "1000000"; -- 0
            when "0001" => oSegment <= "1111001"; -- 1
            when "0010" => oSegment <= "0100100"; -- 2
            when "0011" => oSegment <= "0110000"; -- 3
            when "0100" => oSegment <= "0011001"; -- 4
            when "0101" => oSegment <= "0010010"; -- 5
            when "0110" => oSegment <= "0000010"; -- 6
            when "0111" => oSegment <= "1111000"; -- 7
            when "1000" => oSegment <= "0000000"; -- 8
            when "1001" => oSegment <= "0010000"; -- 9
            when "1010" => oSegment <= "0001000"; -- A
            when "1011" => oSegment <= "0000011"; -- b
            when "1100" => oSegment <= "1000110"; -- C
            when "1101" => oSegment <= "0100001"; -- d
            when "1110" => oSegment <= "0000110"; -- E
            when "1111" => oSegment <= "0001110"; -- F
            when others => oSegment <= "1111111"; -- blank
        end case;
    end process;

end architecture Behavioral;