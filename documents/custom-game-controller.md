# ASIC FPGA Prototyping - Custom Game Controller using Counters, State Machines, and Counters

## Overview
In this lab, we will put together the building blocks we have learned to create our very own game controller similar to those of the NES/SNES. 

## Required materials
For this lab the following materials will be needed:

- Breadboard (Large one will do but a small one is ideal)
- Buttons (any size/type will work)
- 10k Resistors
- Jumper cable with at least one female end (Can be obtained from the ECE shop)
- 74HC165 or comparable parallel-to-serial shift register (Can be obtained from the ECE shop)

## Setup
To begin, open a terminal window, create a new directory, and move into it. Also, setup the directory structure and copy over the base makefile.

```bash
mkdir custom-game-controller
cd custom-game-controller
mkdir -p source include
cp $TOOLSDIR/makefile .
```

This will be the standard setup for most labs.

TODO: Copy over files from previous lab or ECE 337.

## Basic Game Controller
<span style="color:red">Note: this section is still a work in progress. It will be updated once more progress has been made.</span>

The principles learned so far in this lab can be used to talk to old game controllers, or even a custom game controller that we can make ourselves! In this part of the lab, we'll make a custom game controller and use our Serial-to-Parallel Shift Register to talk to it! The concepts of this section are exactly how NES, SNES, and Virtual Boy Controllers work, and it's super simple! I'll be referring to the SNES the most since I have a reproduction controller on hand, but all three controllers/consoles work the same way and are actually compatible[^1].

For this portion of the lab, you will need the materials listed in the earlier section of the lab. You will be creating a custom game controller similar to a SNES controller.

[^1]: Well, almost. The NES controller has 8 buttons while the SNES controller has 12. This means that you can only use the first 8 buttons of the SNES controller if hooked up to a NES. Likewise, hooking an NES controller up to an SNES means you'll be missing some buttons. Also, they each use different connectors (although they contain the same signals).

### How the SNES Controller works
As alluded to above, the SNES controller is essentially just a 16-bit Parallel-to-Serial IC that has it's signals controlled by the console. The console "polls" the controller at a rate of 60 Hz. The console "polls" the controller by doing the following:

1. Send a 12µs wide latch pulse. On the SNES, this is a positive pulse.
1. 6µS after the falling edge of the latch pulse, 16 clock pulses are sent.
1. On the falling edge of each clock pulse, the data line is recorded.
1. This is mapped back to the buttons, and can be used by the system for input.

A couple things to note:
- The buttons on the SNES controller are active low.
- Since the SNES controller only has 12 buttons, the last 4 pulses are always high

I disassembled my reproduction SNES controller, with the intention of showing the chip that converts the button inputs to a serial stream, but the chip is unfortunately covered, so you can't see it. You can look up pictures of real SNES controllers disassembled online to see the PtS IC used in the real deal.

### What is the 74HC165 and what do we need it for?
The [SN74HC165](https://www.ti.com/lit/ds/symlink/sn74hc165.pdf?ts=1644199293784&ref_url=https%253A%252F%252Fwww.ti.com%252Fproduct%252FSN74HC165) is an 8-bit Parallel-to-Serial (PtS) Shift Register. 

It works by allowing the `SH/~LD` pin to determine the current operation of the chip. When `SH/~LD` is high, the values are shifted out. It's important to note that the shifted value out starts from 'H' not 'A'. The value on `SER` determines what value gets shifted in. For this lab, we'll pull it low. When the `SH/~LD` line goes low, the values currently asserted on lines A-H are loaded into the shift register. 

The latch signal sent to the controller is connected to the `SH/~LD` line, the pulse signal is connected to the `clock` line, and the data signal will get connected to the `~QH`.

You should take a look at the data sheet (linked above) for this IC, since we will need to understand how it works to talk to it. A couple of differences between the SNES controller and our custom controller are listed below:

- On the SNES, the latch pulse is high. Since our IC will shift when the latch signal is high and load when the signal is low, our latch pulse needs to be a negative pulse.
- We will wire our controller to have active high buttons.
    - However, we will use the inverted output on the '165, so the buttons will appear to be active low
    - This is also because the inverted output is on the same side of the IC as the other signals we need. This will make wiring neater.
- The '165 only has 8 inputs. Therefore, we'll only send 8 clock pulses to our controller.

### Tips for building your controller
It's now time to build your custom controller! You are free to build your controller however you like, but here are some requirements/tips:

- You can have a maximum of 8 buttons (unless you daisy-chain '165 chips)
- You should have a minimum of 4 buttons
- The buttons should be active high (as mentioned above)
- Each button should have a pull down resistor on the signal side
- All unused inputs on the shift register should be pulled low
- The `SER` and `CLK INH` pins should be pulled low
- Don't forget to connect your power rails together
- Neat wiring is critical for debugging and mapping

### Button mapping
If it isn't clear already, we'll be using our Serial-to-Parallel shift register implementation to keep track of the buttons being pressed. We'll poll the controller and take in the data one bit at a time. To do this, you'll need to know which buttons are mapped to which input of the '165 shift register. You should create a picture with your buttons labeled and a table that matches these labels to the bit of the StP shift register. My custom controller is shown as an example below:

![My Custom Controller](./img/custom_controller.jpg)

| Bit # | Button Mapping |
| ---- | ---- |
| 0 | low (unused) |
| 1 | L |
| 2 | D |
| 3 | R |
| 4 | low (unused) |
| 5 | U |
| 6 | B |
| 7 | A |

## Putting it all together
In the final part of this lab, we will be using the shift register, state machines, and counters we've implemented to communicate with our custom game controller. We won't be using the controller to do anything too crazy, just light up the LEDs for now, but we will use the controller in later labs to do some cool things! You should try experimenting with the development board and controller to do something cool.

### Connections
We have 5 total wires that will connect between our controller and the development board. One wire is power, one wire is ground, the remaining three wires are the signals: clk (pulse), latch, and data. We'll connect these wires to GPIO pins on the development board.

TODO: determine which GPIO pins to connect to!

### Overview
TODO: fill this section out

You should begin this undertaking by creating a state diagram.

**Question:** How can you divide controller logic into states? Try drawing a state machine. You can choose to use either a Moore or Mealy state machine.


### `custom_controller` module
To start, create a new module `custom_controller` with the following parameters. Keep the signal names general for now, as we'll create a wrapper to map this to our actual controller later. This will allow us to specify multiple controllers in the future.

| Name | Direction | Width | Description |
| ---- | ---- | ---- | ---- |
| clk | input | 1 bit | clock signal. Assume it's a 50 MHz clock |
| n_rst | input | 1 bit | reset signal |
| data | input | 1 bit | input data signal |
| latch | output | 1 bit | generated latch signal |
| pulse | output | 1 bit | generated pulse signal |
| buttons | output | 8 bits | the current states of the buttons |

Specifications:

- Assume the input clock is 50 MHz
- The `pulse` signal should have a 50% duty cycle and period of 12µs
    - It should only pulse 8 times and only after the latch signal
- The `latch` signal should be a negative pulse 12µs wide that occurs at 60 Hz
- `buttons` should not update until after all 8 data pulses have been received
    - I.E. We should not see the shifting as the buttons come in

### Implementation
To implement your `custom_controller` module, you should develop it alongside the mapped version as well. This way, you can implement your solution in chunks, and test each along the way. My recommended path is:

1. Implement a 60 Hz poll signal. Direct this signal to a GPIO pin. Can you see it on an oscilloscope?
1. Have this 60 Hz poll signal trigger a latch signal. 