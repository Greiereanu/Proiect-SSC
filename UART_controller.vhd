
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_controller is

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;

        data_in          : in  std_logic_vector (7 downto 0);

        rx               : in  std_logic;
        tx               : out std_logic;
        
        an : out STD_LOGIC_VECTOR (3 downto 0);
        seg : out STD_LOGIC_VECTOR (6 downto 0)
        );
end UART_controller;


architecture Behavioral of UART_controller is
    signal button_pressed : std_logic;
    signal aux : std_logic_vector(7 downto 0);

begin

    tx_button_controller: entity WORK.button_debounce
    port map(
            clk            => clk,
            reset          => reset,
            button_in      => tx_enable,
            button_out     => button_pressed
            );

    UART_transceiver: entity WORK.UART
    port map(
            clk            => clk,
            reset          => reset,
            tx_start       => button_pressed,
            data_in        => data_in,
            data_out       => aux,
            rx             => rx,
            tx             => tx
            );
    
    stopwatch_main: entity WORK.stopwatch
    port map(
            clock => clk,
            input => aux,
            Anode_Activate => an,
            LED_out => seg);
    
end Behavioral;
