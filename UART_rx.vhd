
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity UART_rx is

    generic(
        BAUD_X16_CLK_TICKS: integer := 54); -- (clk / baud_rate) / 16 => (100 000 000 / 115 200) / 16 = 54.25

    port(
        clk            : in  std_logic;
        reset          : in  std_logic;
        rx_data_in     : in  std_logic;
        rx_data_out    : out std_logic_vector (7 downto 0)
        );
end UART_rx;


architecture Behavioral of UART_rx is

    type rx_states_t is (IDLE, START, DATA, STOP);
    signal rx_state: rx_states_t := IDLE;

    signal baud_rate_x16_clk  : std_logic := '0';
    signal rx_stored_data     : std_logic_vector(7 downto 0) := (others => '0');



begin

    baud_rate_x16_clk_generator: process(clk)
    variable baud_x16_count: integer range 0 to (BAUD_X16_CLK_TICKS - 1) := (BAUD_X16_CLK_TICKS - 1);
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                baud_rate_x16_clk <= '0';
                baud_x16_count := (BAUD_X16_CLK_TICKS - 1);
            else
                if (baud_x16_count = 0) then
                    baud_rate_x16_clk <= '1';
                    baud_x16_count := (BAUD_X16_CLK_TICKS - 1);
                else
                    baud_rate_x16_clk <= '0';
                    baud_x16_count := baud_x16_count - 1;
                end if;
            end if;
        end if;
    end process baud_rate_x16_clk_generator;


    UART_rx_FSM: process(clk)
        variable bit_duration_count : integer range 0 to 15 := 0;
        variable bit_count          : integer range 0 to 7  := 0;
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                rx_state <= IDLE;
                rx_stored_data <= (others => '0');
                rx_data_out <= (others => '0');
                bit_duration_count := 0;
                bit_count := 0;
            else
                if (baud_rate_x16_clk = '1') then
                    case rx_state is

                        when IDLE =>

                            rx_stored_data <= (others => '0');
                            bit_duration_count := 0;
                            bit_count := 0;

                            if (rx_data_in = '0') then
                                rx_state <= START;
                            end if;

                        when START =>

                            if (rx_data_in = '0') then
                                if (bit_duration_count = 7) then
                                    rx_state <= DATA;
                                    bit_duration_count := 0;
                                else
                                    bit_duration_count := bit_duration_count + 1;
                                end if;
                            else
                                rx_state <= IDLE;
                            end if;

                        when DATA =>

                            if (bit_duration_count = 15) then
                                rx_stored_data(bit_count) <= rx_data_in;
                                bit_duration_count := 0;
                                if (bit_count = 7) then
                                    rx_state <= STOP;
                                    bit_duration_count := 0;
                                else
                                    bit_count := bit_count + 1;
                                end if;
                            else
                                bit_duration_count := bit_duration_count + 1;
                            end if;

                        when STOP =>

                            if (bit_duration_count = 15) then
                                rx_data_out <= rx_stored_data;
                                rx_state <= IDLE;
                            else
                                bit_duration_count := bit_duration_count + 1;
                            end if;

                        when others =>
                            rx_state <= IDLE;
                    end case;
                end if;
            end if;
        end if;
    end process UART_rx_FSM;

end Behavioral;
