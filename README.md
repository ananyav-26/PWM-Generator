This project implements a PWM (Pulse Width Modulation) generator in VHDL with two debounced push-button inputs to dynamically control the duty cycle. It's ideal for learning digital design and how PWM can be manipulated in real-time.

## Features

- Generates a 10 MHz PWM signal (assuming a 100 MHz clock).
- Two push-buttons:
  - `DUTY_INCREASE`: Increases the duty cycle by 10%.
  - `DUTY_DECREASE`: Decreases the duty cycle by 10%.
- Includes button debounce logic using D Flip-Flops and a slow clock enable.
- Simple and synthesizable design, suitable for FPGAs.

## How It Works

- A slow clock enable signal is generated to sample button inputs periodically, avoiding false triggering (debouncing).
- Button presses increase or decrease the `DUTY_CYCLE` signal in 10% increments.
- A 4-bit counter (`counter_PWM`) cycles from 0 to 9, and `PWM_OUT` is high for a duration based on the current duty cycle.

## Simulation

The testbench simulates button presses over time, testing both increase and decrease functionality. You can run the testbench using:
- ModelSim
- Vivado Simulator
- GHDL + GTKWave

## Ouputs
- RTL Schematic: https://github.com/ananyav-26/PWM-Generator/blob/main/images/PWM_rtl.png
- Output Waveform: https://github.com/ananyav-26/PWM-Generator/blob/main/images/PWM_waveform.png
