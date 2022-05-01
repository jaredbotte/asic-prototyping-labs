# ASIC FPGA Prototyping - Final Report
Jared Botte

Dr. Mark Johnson

Spring 2022

1 Credit Hour

## Overview
This report will discuss the work performed over the course of the Spring 2022 semester for ECE 49600 - ASIC FPGA Prototyping. I will discuss the deliverables created, future work, and hardware limitations encountered.

## Summary
The primary goal of this independent study was for me to get more exposure to FPGA and Digital Logic development. To do this I took the labs completed in ECE 33700, expanded upon them, and created lab experiments to bring those labs onto a physical FPGA development board. The Altera DE2-115 FPGA development board was used as the hardware platform for these labs, as it is used in ECE 43700 and contains many useful peripherals.

## Deliverables
All of the work produced for this independent study are located in two GitHub repositories.

[jaredbotte/asic-prototyping-tools](https://www.github.com/jaredbotte/asic-prototyping-tools) contains the scripts I created to automate compilation and programming of the DE2-115 development board. They are based on the ECE 437 scripts, and should work in any standard linux distribution.

[jaredbotte/asic-prototyping-labs](https://www.github.com/jaredbotte/asic-prototyping-labs) contains the bulk of my deliverables, which includes lab documents (in both markdown and PDF format), solution documents (in markdown) and my design code solutions for the lab. It also contains some additional work that never made its way into labs, but may be useful if this work is continued in the future.

## Preparation
The first 2 - 3 weeks of my independent study was primarily focused on obtaining the hardware, installing and configuring the software, and documenting the setup so that it could be reproduced. This took longer than I had anticipated, as I had no background in Intel's FPGA workflow so I did not understand the steps needed to program the development board. I also had to reverse engineer the scripts used by ECE 437 that were written in perl, which I had no prior experience with.

Once I was able to determine the steps needed to program the board and define the pins, I created python scripts and a makefile to facilitate the compilation process. Lastly, I documented this process as best as I could in the `setup.md` document, so that the setup can be reproduced.

## Labs

### Adder Error Detector
This lab, designed to be completed first, is a soft introduction to the DE2-115 development board and the procedure for programming the board. The sensor error detector and flexible adder are taken from ECE 337 and put onto the board. This introduces the students to the buttons, switches, LEDs, and 7-segment displays on the development board. 

### Counter Shift Register
This lab, designed to be completed second, introduces students to the clock available on the development board, as well as clock dividers, counters, and shift registers. A module is created to show hexadecimal values on the 7-segment displays, and this is used to show the current value of the counters. In this lab, serial-to-parallel shift registers are also explored.

### Custom Game Controller
This lab, designed to be completed third, is one of my personal favorite labs. It uses physical and implemented shift registers to create a custom game controller that operates on the same principles as the SNES and NES systems. This lab is the first lab that requires quite a bit of thinking and a strong understanding of counters, state machines, and shift registers. This lab combines all the knowledge from the previous labs into a cool practical implementation.

### UART Receiver
This lab, designed to be completed fourth, takes the UART lab completed in ECE 337 into the physical domain. In this lab, a module is created to display alphanumeric characters on the 7-segment displays. The displays are linked together and connected via an RS-232 cable, which allows communicating with the dev board over a terminal on the host machine. This allows displaying received messages on the board.

The UART lab was originally going to print the received characters to the LCD display on the dev board, however there is no way to easily interact with the screen on the DE2-115, so the use of the LCD screen was scrapped.

### Random Number Generator
This lab was initially created as part of the custom game controller series, when I had intended to make labs that created a game. Unfortunately, for reasons discussed later on in this document, a game was never implemented. This lab is too short to be a standalone lab, although is not too far from becoming part of a larger lab.

This lab focuses on implementing a Linear-Feedback Shift Register to create Pseudo-Random numbers. This can be used with a game implementation to provide some form of somewhat random numbers. LFSRs are also ideally implemented in hardware designs, so I believe they are a cool topic to introduce to students.

### Audio FIR Filter
This lab is designed to be completed last, and explores using SPI to communicate with an external device. Using SPI, we send audio samples to the dev board, where the FIR filter implemented in ECE 337 is used to modify the audio. It is then sent back over SPI so that the controller can replay it.

The original plan for a FIR filter lab was to use the 24-bit audio Codec that's on the DE2-115 development board. However, due to complexities discussed later in this lab, that idea had to be scrapped. Instead, the STM32 development board used in ECE 362 was used as an SPI controller and handles the ADC and DAC.

### VGA
As part of the custom game controller series, I had planned to use the VGA peripheral on the screen to implement a game, playable with the custom game controller. Basic interfacing with the screen was completed and can be found in the `vga-base-files` folder, but creating a frame buffer and more complex graphics would involve interfacing with the SDRAM on the board. This was outside the scope of the independent study and therefore was not implemented. 

VGA may make for an interesting lab on it's own as students would need to use clock division and the design isn't very complex, but understanding VGA is something that would need to be taught.


## Implementation Complexities
In order to make a game, a significant amount of overhead is going to be required to know when to draw what to the screen. This, combined with the lack of available memory, would make creating a game difficult. If time permitted, I would have liked to make use of the two SDRAM chips on the DE2 by writing a frame buffer to one of the chips while reading the other to actually put it on the screen. This is not too far outside the realm of possibility but creating an SDRAM interface is tricky, and given the time constraints of this course, not possible.

In order to use many of the peripherals on the DE2-115, you need to have some sort of processor implemented, so that you can interface with them over an Avalon bus connection. This was outside the scope of this independent study, so many of the boards peripherals were never used.

## Problems Encountered and Limitations


## Limitations with the DE2-115

