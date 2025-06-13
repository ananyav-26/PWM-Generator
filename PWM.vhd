-- ============================================================
-- Title      : PWM Generator
-- Author     : Ananya Vaidya
-- ============================================================
-- Two de-bounced push-buttons:
--   1. DUTY_INCREASE: Increases duty cycle by 10%
--   2. DUTY_DECREASE: Decreases duty cycle by 10%

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Generator is
    port (
        clk          : in  std_logic;                 -- 100MHz clock input
        DUTY_INCREASE: in  std_logic;                 -- Button to increase duty cycle
        DUTY_DECREASE: in  std_logic;                 -- Button to decrease duty cycle
        PWM_OUT      : out std_logic                  -- 10MHz PWM signal output
    );
end PWM_Generator;

architecture Behavioral of PWM_Generator is

    -- Debounce D Flip-Flop Component Declaration
    component DFF_Debounce 
        Port ( 
            CLK : in  std_logic;
            en  : in  std_logic;
            D   : in  std_logic;
            Q   : out std_logic
        );
    end component;

    -- Signals for slow clock and debounce logic
    signal slow_clk_en    : std_logic := '0';                     -- Enable signal for debounce
    signal counter_slow   : std_logic_vector(27 downto 0) := (others => '0'); -- Clock divider

    signal tmp1, tmp2, duty_inc : std_logic;                      -- Debounce signals for increase button
    signal tmp3, tmp4, duty_dec : std_logic;                      -- Debounce signals for decrease button

    -- PWM-related signals
    signal counter_PWM    : std_logic_vector(3 downto 0) := (others => '0');  -- PWM counter (0-9)
    signal DUTY_CYCLE     : std_logic_vector(3 downto 0) := x"5";             -- Initial duty cycle = 50%

begin

    ------------------------------------------------------------------------
    -- Slow Clock Generator for Debouncing (4Hz)
    ------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            counter_slow <= counter_slow + x"0000001";

            -- Adjust this threshold for actual FPGA (comment out for simulation)
            -- if counter_slow >= x"17D7840" then
            if counter_slow >= x"0000001" then  -- For simulation
                counter_slow <= x"0000000";
            end if;
        end if;
    end process;

    -- Slow clock enable signal generation
    -- slow_clk_en <= '1' when counter_slow = x"17D7840" else '0'; -- For FPGA
    slow_clk_en <= '1' when counter_slow = x"000001" else '0';      -- For simulation

    ------------------------------------------------------------------------
    -- Debounce Logic for DUTY_INCREASE Button
    ------------------------------------------------------------------------
    stage0: DFF_Debounce port map(clk, slow_clk_en, DUTY_INCREASE, tmp1);
    stage1: DFF_Debounce port map(clk, slow_clk_en, tmp1, tmp2);
    duty_inc <= tmp1 and (not tmp2) and slow_clk_en;

    ------------------------------------------------------------------------
    -- Debounce Logic for DUTY_DECREASE Button
    ------------------------------------------------------------------------
    stage2: DFF_Debounce port map(clk, slow_clk_en, DUTY_DECREASE, tmp3);
    stage3: DFF_Debounce port map(clk, slow_clk_en, tmp3, tmp4);
    duty_dec <= tmp3 and (not tmp4) and slow_clk_en;

    ------------------------------------------------------------------------
    -- Adjust Duty Cycle Based on Button Presses
    ------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if duty_inc = '1' and DUTY_CYCLE <= x"9" then
                DUTY_CYCLE <= DUTY_CYCLE + x"1";  -- Increase by 10%
            elsif duty_dec = '1' and DUTY_CYCLE >= x"1" then
                DUTY_CYCLE <= DUTY_CYCLE - x"1";  -- Decrease by 10%
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Generate 10MHz PWM Signal from 100MHz Input Clock
    ------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            counter_PWM <= counter_PWM + x"1";

            if counter_PWM >= x"9" then
                counter_PWM <= x"0";
            end if;
        end if;
    end process;

    -- Output PWM signal based on DUTY_CYCLE
    PWM_OUT <= '1' when counter_PWM < DUTY_CYCLE else '0';

end Behavioral;
