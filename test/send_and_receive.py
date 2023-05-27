import socket
import random
import time
import _thread
import struct
import sys

HOST = "192.168.0.200"  # The server's hostname or IP address
PORT = 9000  # The port used by the server

points_const = [
    4, 6,
    10, 10,
    0, 12,
    4, 0,
    2, 16,
    10, 4,
    0, 2,
    9, 16,
    5, 14
]

def print_payload(s):
    while True:
        try:
            data = s.recv(1024)
            if len(data) != 0:
                print(data)
        except OSError:
            print("Lost connection")
            sys.exit()

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.settimeout(100)
    s.connect((HOST, PORT))
    print("Connected")

    _thread.start_new_thread(print_payload, (s, ))

    try:

        while True:
            battery = random.randint(1, 100)
            batteryBytes = battery.to_bytes(1, byteorder='big')

            print("battery \t" + str(battery))
            s.send(b'b' + batteryBytes)
            time.sleep(1)

            points = points_const  # random.sample(range(-100, 100), 10)
            pointBytes = b''.join([n.to_bytes(4, byteorder='big', signed=True) for n in points])

            print("coordinates \t" + str(points))
            s.send(b'c' + pointBytes)
            time.sleep(1)

            imu = [random.uniform(-100, 100) for i in range(1,10)]
            imuListOfByteLists = [bytearray(struct.pack(">f", value)) for value in imu]
            imuBytes = b''.join([b for b in imuListOfByteLists])

            print("imu \t\t" + str(imu))
            s.send(b'i' + imuBytes)
            time.sleep(5)

    except BrokenPipeError:
        print("Lost connection")
        sys.exit()
