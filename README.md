# FPGA Electric Piano on Artix-7

This project implements a electric piano synthesizer on the Digilent Artix-7 Basys 3 FPGA board. It uses a standard USB keyboard connected to a PC as the input device. Key presses are captured and forwarded to the Basys 3 via a Python script over UART (through the micro USB cable connected to the JTAG/UART port). The FPGA generates corresponding musical notes and outputs them to a passive buzzer for audio playback.

The keyboard keys from 'q' to ']' are mapped to a 12-note scale (one octave). Octave shifting is handled by the BTNU (up) and BTND (down) buttons on the Basys 3 board, allowing you to increase or decrease the pitch by one octave.

## How it works
- **USB Keyboard Input**: Use your computer's USB keyboard as piano keys.
- **UART Communication**: PC sends key data to Basys 3 via serial port (e.g., COM4 on Windows).
- **Note Mapping**: Keys 'q' to ']' correspond to 12 notes in a chromatic scale.
- **Octave Control**: BTNU and BTND button on Basys 3 shifts up/down one octave.
- **Audio Output**: PWM Tone generation via a passive buzzer connected to the Basys 3.

  <p align="center">
  <img src="https://github.com/user-attachments/assets/708448db-84a3-45d1-b2ca-e37c5c30a708" alt="Basys 3" width="600"/>
  <br>
  <i>Figure 1: Basys 3 features</i>
</p>


## Hardware Requirements
- Digilent Basys 3 FPGA board (or any kind of FPGA board that has UART USB port).
- Standard USB keyboard (connected to your PC).
- Micro USB cable for connecting PC to Basys 3 (JTAG/UART port).
- Passive buzzer (connected to a GPIO pin on the Basys 3, e.g., via PMOD or onboard header).

## Software Requirements
- Xilinx Vivado (for synthesizing and programming the FPGA design).
- Python 3.x
- `pyserial` and `keyboard` library for Python:
  
  ```
  pip install pyserial keyboard
  ```
- Download the python script.
- Download all the `.v` and `.xdc` files in this repo and add to a new project in Vivado, set `Piano.v` as top hierarchy.

## Usage
1. Connect the USB keyboard to your PC.
   
2. Use a micro USB cable to connect your PC to the Basys 3 board's JTAG/UART USB port. This will appear as a serial port (e.g., COM4 on Windows; check Device Manager to confirm the port and change it in the python script at `serial.Serial('COM4', 9600, timeout=1)`).
   
3. Attach the passive buzzer to the appropriate output Pmod JA on the Basys 3 (e.g., connect SIG pin to JA1, GND pin to GND, if there is a VCC then connect it to either 3.3V or 5V base on your buzzer). The FPGA constraints file is already setup accordingly.
 <p align="center">
  <img src="https://github.com/user-attachments/assets/caaa2c41-dd74-4d6b-bb91-073abe6db02e" alt="Buzzer" width="300"/>
  <br>
  <i>Figure 2: Four pins a buzzer can have</i>
</p>

 
   
4. Program the Basys 3 with the FPGA bitstream.
 
5. Run the Python script on your PC.
 
6. Press keys 'q' to ']' on your USB keyboard to play notes.
 
7. Use BTNU/BTND on Basys 3 to shift up/down an octave.

## Future Improvements
- Add polyphony
- Changing timbre using sine-wave
- Visual feedback using LEDs or 7-segment display for current octave/note.

Feel free to contribute or report issues!
