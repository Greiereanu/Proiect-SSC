import tkinter
import serial
import sys

ser = serial.Serial('COM3', 115200)

root = tkinter.Tk()
root.geometry("200x200")
root.title("Interfata UART")

counter = tkinter.IntVar()

def onClickReceive():
    size = ser.inWaiting()
    if size:
        data = ser.read(size)
        counter.set(data)

def onClickStart():
    
    ser.write("g".encode())
def onClickStop():
    
    ser.write("s".encode())
def onClickReset():
    
    ser.write("r".encode())

tkinter.Label(root, textvariable=counter).pack()
tkinter.Button(root, text="Start", command=onClickStart, fg="dark green", bg = "white").pack()
tkinter.Button(root, text="Stop", command=onClickStop, fg="dark green", bg = "white").pack()
tkinter.Button(root, text="Reset", command=onClickReset, fg="dark green", bg = "white").pack()
tkinter.Button(root, text="Receive", command=onClickReceive, fg="dark green", bg = "white").pack()

root.mainloop()