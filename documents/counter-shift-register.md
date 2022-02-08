# ASIC FPGA Prototyping - Counters, "1101" Detector, and Serial-to-Parallel Shift Register

## Overview
In this lab, we will explore state machines, counters, and shift registers. We will conclude this lab by combining these topics to create our own video game controller that operates the same way as the SNES/NES?Virtual Boy controllers work.

## Required materials
For this lab the following materials will be needed:

- Breadboard (Large one will do but a small one is ideal)
- Buttons (any size/type will work)
- 10k Resistors
- Jumper cable with at least one female end (Can be obtained from the ECE shop)
- 74HC165 or comparable parallel-to-serial shift register (Can be obtained from the ECE shop)

You won't need these materials until the final portion of the lab, so the lab can be started without them.

## Setup
To begin, open a terminal window, create a new directory, and move into it. Also, setup the directory structure and copy over the base makefile.

```bash
mkdir counter-shift-register
cd counter-shift-register
mkdir -p source include
cp $TOOLSDIR/makefile .
```

This will be the standard setup for most labs.

## New make target
I've added in a new make target that will just compile a design. This is a good way to check that your design compiles before moving on and creating wrapper files. To use this target, run:

```bash
make %_compile
```

Where `%` is the module name you'd like to compile. This will also compile any modules referenced by the one provided.

## "1101" Detector
In the first part of the lab, we will be using a state machine to make a "1101" detector. We will provide the device with a stream of 0's and 1's and it should light up any time "1101" is detected in the stream.

### Create a general "1101" detector
Create a new module `detector_1101` with the following parameters:

| Name | Direction | Width | Description |
| ---- | ---- | ---- | ---- |
| clk | input | 1 bit | clock signal |
| n_rst | input | 1 bit | reset signal |
| data | input | 1 bit | data stream |
| state | output | 3 bits | the current state |
| out | output | 1 bit | true (1) if "1101" detected in stream |

### Create a mapped version
Next, create a module `detector_1101_mapped` that maps the general detector to the FPGA I/O. Use pushbuttons for the `clk` and `n_rst` signals, a switch for the `data` signal, and green LEDs for the `out` and `state` signals.

Confirm that your "1101" detector works as expected.

## Counters
The rest of this lab will focus on counters and use-cases for counters. We will begin by having the counter be controlled by a push button, then move on to controlling it from the clock on the DE2-115 development board. To begin, copy over your implementation of the `flex_counter` from ECE 337. This should already be a fully functional n-bit counter, so we'll only need to create a wrapper file.

### Create a 7-segment display module
Since we'll be using the 7-segment displays in this and many future labs, let's create an easy-to-use module called `hex_display` to deal with mapping a 4-bit value to a hex display.

Module `hex_display`:

| Name | Direction | Width | Description |
| ---- | ---- | ---- | ---- |
| value | input | 4-bits | The value to display on the screen |
| disp | output | 7-bits | The value sent to the 7-segment display |

### Show a 4-bit counter on a 7-segment display
For this part of the lab, choose push-buttons (keys) to act as the clock, reset, and clear signals and display the output of the counter on one of the 7-segment displays. Set the rollover value to `4'hf`, and `count_enable` to `1'b1`. Name your wrapper file `counter_4bit.sv`.

Hint: If your counter seems to be stuck at 0, remember how the push-buttons are connected to the FPGA.

**Question:** What is the difference in behavior between the `clear` button and the `n_rst` button? What happens when you press them?

### Try it out!
Now that we've got our 4-bit counter working, lets try counting higher!

#### Challenge 1: Show an 8-bit counter on 2 7-segment displays
Create a new wrapper module, `counter_8bit` that creates and 8-bit flex counter, and shows the result on 2 7-segment displays.

### Connect the counter to the system clock
Hitting a push button to verify all our values work takes a lot of clicks (well, 255 to be specific). Let's connect the counter to the system clock so that it counts automatically. To do this, let's copy the 8-bit counter into a new module called `auto_counter`. Let's also change the clock push button to control `count_enable` instead. Once done, run it on the development board.

### Slowing things down
You probably noticed the displays both show eights. This is because the counter counts fast. Very fast. 50 MHz fast. Try hitting the `count_en` button and seeing different values. Let's try slowing things down a bit. The `flex_counter` module can also be used as a clock divider.

**Question:** What do we have to divide our clock input by to get a 20 Hz clock?

**Question:** How can we divide our clock using the flex counter? How many bits wide does the counter need to be to get the clock to 20 Hz? What should the rollover value be set to?

Once you've answered the above questions, try implementing it. Also make the counter a 16-bit counter that uses 4 7-segment displays

### Binary-Coded Decimal (BCD)
Now that we've got our counter working, let's try making it more human-readable. Since we think in base 10, we should display our current count this way so that we know what number we're on at a quick glance. create a new module `dec_display` to display digits in base 10 using BCD.

Module `dec_display`:

| Name | Direction | Width | Description |
| ---- | ---- | ---- | ---- |
| value | input | 4 bits | The value to display on the screen |
| carry_in | input | 1 bit | The carry in value from the previous digit |
| disp | output | 7 bits | The value sent to the 7-segment display |
| carry_out | output | 1 bit | The carry out value sent to the next digit |

The trick to go from hexidecimal to decimal is to add 6 to every number greater than 9, then carry over to the next digit. For example, 0x4A = 56

**Question:** What's the highest number of bits a counter could have where we could still show every number on our 4 7-segment displays?

## Serial-to-Parallel Shift Register
For the final part of this lab, we will create a Serial-to-Parallel shift register. Once we've created this shift register, we'll use it both to make a different "1101" detector and as a means of communication with a game controller.

### 1-bit Serial-to-Parallel Shift Register
Just like our n-bit adder implementation, we will implement an n-bit shift register by starting with a 1-bit shift register. This is a super simple device, and is just a flip flop. Create a new module `stp_1bit` to implement it. Have it reset to a `1'b1`.

### n-bit Serial-to-Parallel Shift Register
Next, create a module called `stp_nbit` which uses a parameter `BIT_WIDTH` and a generate block to create an n-bit shift register using the 1-bit shift register previously made. You should do this the same way you created the n-bit adder in ECE 337.

### 1101 Detector without State Machines
Now that we have our n-bit StP Shift register out of the way, let's try using a 4-bit shift register to detect a "1101" input. Create a new module `stp_4bit` and map it the same way you mapped the previous state detector. Instead of the state being displayed on the LEDs, display the parallel output of the shift register. 

Think about how you can detect a "1101" using the parallel output of the shift register, and write a statement in your module to detect this and display it on a green LED.

## Basic Game Controller
<span style="color:red">Note: this section is still a work in progress. It will be updated once more progress has been made. If you know how to use the GPIO port on the DE2-115, contact me: jbotte (at) purdue.edu. Thanks!</span>

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

It works by allowing the `SH/~LD` pin to determine the current operation of the chip. When `SH/~LD` is high, the values are shifted out. It's important to note that the shifted value out starts from 'H', not 'A'. The value on `SER` determines what value gets shifted in. For this lab, we'll pull it low. When the `SH/~LD` line goes low, the values currently asserted on lines A-H are loaded into the shift register. 

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

### Overview of implementation
TODO: fill this section out


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
- The `pulse` signal should have a 50 % duty cycle and period of 12µs
    - It should only pulse 8 times and only after the latch signal
- The `latch` signal should be a negative pulse 12µs wide that occurs at 60 Hz
- `buttons` should not update until after all 8 data pulses have been received
    - I.E. We should not see the shifting as the buttons come in