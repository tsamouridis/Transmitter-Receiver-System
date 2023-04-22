# Transmitter-Receiver-System
Implementation of Transmitter-Receiver System using UART protocol and representation of output in 7-segment LED displays

# Description
This repository contains the implementation of a **Uart Transmitter-Receiver system**, which is a system for serial, 1-by-1 bit, data transmition. In this implementation the characters being transmitted are assumed to be the numbers 1-9 and also the characters 'F', '-' and '&nbsp;' (space). These characters are used to transmit 4-character-messages that come from sensors and are represented in the following way: [‘space’|‘-’][‘space’|1-9] [‘space’|0-9] [0-9], where | represents the logical or, eg: '-194', '&nbsp;-87'. Error message is represented by the message 'FFFF'.

In addition to the transmition system, a **4-digit-display system** is designed in order to display the message in 7-segment LED displays. The 4 displays are not simultaneously on when displaying a particular message. They operate one after the other in a circular order in very high speed. This very high speed makes it possible to display a message only using one display driver and still the flickering not being perceived.

The system is lastly expanded in order to add a **decoding** to the transmitted message for safety reasons. The decoding system is using one encoder and one decoder. The encoding method is simple: If the true representation of a character is the binary x, then the transmitted signal is the binary x + 1. For instance, in this implementation, the character 6 is represented in binary by 0110. The transmitted signal after encoding is 0111.

The total schematic of the system is provided for more clarity:

<img src="https://github.com/tsamouridis/Transmitter-Receiver-System/blob/master/media/diagram.png" alt="Schematic" width="500" height="600" class="center">

A more thorough description of the system implementation, along with schematics provided by the simulation tool and results from the testbenches for each component is provided in greek in the <a href="https://github.com/tsamouridis/Transmitter-Receiver-System/blob/master/Report_UART.pdf">Project Report</a>.

## Authors 
[Bouletsis Alexis](https://github.com/alexisbouletsis) <br>
[Tsamouridis Thanasis](https://github.com/tsamouridis) <br>