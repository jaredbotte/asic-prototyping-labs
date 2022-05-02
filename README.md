# Welcome to ASIC FPGA Prototyping!
This repository contains all the deliverables produced during my independent study during the Spring 2022 semester.

## Table of Contents

| Folder/File | Description |
| :---- | :---- |
| ***/source/ | Contains the source code (my solution) for the lab |
| ***/makefile | Makefile that automates compilation and programming |
| ***/README.md | A symbolic link to the lab document in the documents folder |
| documents/ | Contains all the lab documents |
| ---> img/ | Contains all the images used in the lab documents |
| ---> *.pdf | The exported lab documents in PDF format |
| ---> *.md | The source files for the lab documents in markdown format |
| fir-kicad-schematics/ | The KiCad files for the fir filter lab schematics |
| ---> stm-fir-filter-schematic.pdf | An exported PDF of the schematic |
| ---> stm32f091.kicad_pro | The KiCad project file |
| ---> stm32f091.kicad_sch | The KiCad Schematic file |
| solutions/ | Contains the solutions to questions asked in the lab documents |
| ---> img/  | Contains images used in the solutions |
| .gitignore | .gitignore file |
| README.md | This file |

## Short Description of Labs

### Adder Error Detector
In this lab, students will get their first exposure to interfacing with the DE2-115 
development board. This lab covers the adder and error detector labs from ECE 337 and 
uses the switches, buttons, leds, and 7-segment displays.

### Counter Shift Register
In this lab, students will utilize clock dividing circuits to create automatic 
counters, as well as use shift registers to detect bit patterns. Students will also 
create a module to display hexadecimal characters on the 7-segment displays.

### Custom Game Controller
In this lab, students will physically create a game controller using a small 
breadboard, a parallel-to-serial shift register, and some buttons. The controller then
 interfaces with the development board the same way the SNES and NES controllers 
 interface with the consoles! This lab uses a serial-to-parallel shift register 
 implementation and requires combining shift registers, counters, clock-dividers, and 
 state machines.

### FIR SPI
In this lab, students will be creating an SPI Peripheral device that connects to the FIR lab from ECE 337. Students will use an STM32 as a ADC and DAC for the audio samples, with the samples being sent over SPI. A switch on the development board controls weather the FIR filter is applied to the audio or not.

### Random Number Generator
This lab aims to introduce students to pseudo-random number generation using 
Linear-Feedback Shift Registers. This lab is super short and is thus considered 
incomplete, but is ready to be expanded on in the future.

### UART Receiver
This lab interfaces with the RS-232 port on the DE2 and builds off of the UART lab in 
ECE 337. In this lab students will create a module to display alphanumeric characters 
on the 7-segment displays, then interface their UART RX modules with the board to 
receive characters sent from a computer terminal.

### VGA Base Files
No lab document was created for this, although it could be turned into a lab in the 
future. The files generated use clock dividers to interface with a VGA monitor using 
the VGA output of the DE2 development board. No graphics are able to be displayed but 
the screen color is able to be hard coded.

