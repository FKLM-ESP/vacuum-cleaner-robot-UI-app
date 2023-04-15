import socket
import random
import time
import _thread

HOST = "192.168.0.200"  # The server's hostname or IP address
PORT = 9000  # The port used by the server

def print_payload(s):
    while True:
        print(s.recv(1024))


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.settimeout(100)
    s.connect((HOST, PORT))
    print("Connected")

    _thread.start_new_thread(print_payload, (s, ))

    while True:

        battery = random.randint(1, 100)
        batteryBytes = battery.to_bytes(1, byteorder='big')
        points = random.sample(range(-100, 100), 10)

        print(battery)
        print(points, end='\n\n')

        pointBytes = [n.to_bytes(4, byteorder='big', signed=True) for n in points]

        payload = batteryBytes + b''.join(pointBytes)

        s.send(payload)

        time.sleep(5)
