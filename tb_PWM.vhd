-- ============================================================
-- Title      : Testbench for PWM Generator
-- Author     : Ananya Vaidya
-- ============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment if arithmetic operations are used:
-- use IEEE.NUMERIC_STD.ALL;

entity tb_PWM_Genenrator is
end tb_PWM_Genenrator;

architecture behavior of tb_PWM_Genenrator is

    --------------------------------------------------------------------
    -- Component Declaration: PWM Generator (Unit Under Test)
    --------------------------------------------------------------------
    component PWM_Generator
        port (
            clk           : in  std_logic;
            DUTY_INCREASE : in  std_logic;
            DUTY_DECREASE : in  std_logic;
            PWM_OUT       : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- Signals Declaration
    --------------------------------------------------------------------
    -- Inputs
    signal clk           : std_logic := '0';
    signal DUTY_INCREASE : std_logic := '0';
    signal DUTY_DECREASE : std_logic := '0';

    -- Output
    signal PWM_OUT       : std_logic;

    -- Clock period definition (100 MHz)
    constant clk_period  : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instantiate the Unit Under Test (UUT)
    --------------------------------------------------------------------
    uut: PWM_Generator
        port map (
            clk           => clk,
            DUTY_INCREASE => DUTY_INCREASE,
            DUTY_DECREASE => DUTY_DECREASE,
            PWM_OUT       => PWM_OUT
        );

    --------------------------------------------------------------------
    -- Clock Generation Process (100 MHz)
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    --------------------------------------------------------------------
    -- Stimulus Process: Emulate Button Presses
    --------------------------------------------------------------------
    stim_proc: process
    begin
        -- Initialize inputs
        DUTY_INCREASE <= '0';
        DUTY_DECREASE <= '0';
        wait for clk_period * 10;

        -- Increase Duty Cycle (3 presses)
        DUTY_INCREASE <= '1'; wait for clk_period * 10;
        DUTY_INCREASE <= '0'; wait for clk_period * 10;
        DUTY_INCREASE <= '1'; wait for clk_period * 10;
        DUTY_INCREASE <= '0'; wait for clk_period * 10;
        DUTY_INCREASE <= '1'; wait for clk_period * 10;
        DUTY_INCREASE <= '0'; wait for clk_period * 10;

        -- Decrease Duty Cycle (3 presses)
        DUTY_DECREASE <= '1'; wait for clk_period * 10;
        DUTY_DECREASE <= '0'; wait for clk_period * 10;
        DUTY_DECREASE <= '1'; wait for clk_period * 10;
        DUTY_DECREASE <= '0'; wait for clk_period * 10;
        DUTY_DECREASE <= '1'; wait for clk_period * 10;
        DUTY_DECREASE <= '0'; wait for clk_period * 10;

        -- End of Stimulus
        wait;
    end process;

end behavior;
