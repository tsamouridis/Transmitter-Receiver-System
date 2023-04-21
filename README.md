# Transmitter-Receiver-System
Implementation of Transmitter-Receiver System using UART protocol and representation of output in 7-segment LED displays

# Description
This folder contains the implementation of a Uart Transmitter-Receiver system, which is a system for serial, 1-by-1 bit, data transmition. In this implementation the characters being transmitted are supposed be the numbers 1-9 and the chracters 'F', '-' and ' ' (space). These characters are used to transmit 4-character-messages that come from sensors and are represented in the following way: [‘space’|‘-’][‘space’|1-9] [‘space’|0-9] [0-9], where | represents the logical or, eg: '-194', '  87'. Error message is represented by the message 'FFFF'.

In addition to the transmition system, a 4-digit-display system is designed in order to display the message in 7-segment LED displays. The 4 displays are not simultaneously on when displaying a particular message. They operate one after the other in a circular order in very high speed. This very high speed makes possible to display a message only using one display driver and still the user not being able to perceive the flickering.

The system is lastly expanded in order to add a decoding to the transmitted message for safety reasons. The decoding system is using one encoder and one decoder. The encoding method is simple: If the true representation of a chracter is the binary x, then the transmitted signal is the binary x + 1. For instance, in this implementation, the character 6 is represented in binary by 0110. The transmitted signal after encoding is 0111.

The total schematic of the system is provided for more clarity:

