import serial
import keyboard
import time

def main():
    print("Starting keyboard to UART program...")

    try:
        with serial.Serial('COM4', 9600, timeout=1) as ser:
            print(f"Connected to {ser.port}")
            print("Press keys (q-] for notes, ESC to exit)...")

            key_to_code = {
                'q': 2, 'w': 3, 'e': 4, 'r': 5,
                't': 6, 'y': 7, 'u': 8, 'i': 9,
                'o': 10, 'p': 11, '[': 12, ']': 13,
            }

            running = True

            def handler(event):
                nonlocal running
                if event.name == 'esc':
                    print("ESC pressed, exiting...")
                    running = False
                elif event.name in key_to_code:
                    code = key_to_code[event.name]
                    ser.write(bytes([code]))
                    print(f"Sent code: {code} for key {event.name}")

            # Gắn handler với suppress=True
            for key in key_to_code.keys():
                keyboard.on_press_key(key, handler, suppress=True)
            keyboard.on_press_key('esc', handler, suppress=True)

            # Vòng lặp chính giữ chương trình chạy
            while running:
                time.sleep(0.1)

    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except KeyboardInterrupt:
        print("\nProgram terminated by user")
    finally:
        print("Program exited")

if __name__ == "__main__":
    main()
