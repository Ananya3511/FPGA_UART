# UART Verilog Implementation

This project implements a **UART (Universal Asynchronous Receiver Transmitter)** module in Verilog, designed to send and receive 8-bit serial data over a single line.  
It includes separate `Tx` (transmitter) and `Rx` (receiver) modules and integrates them into a top-level `UART` module.

---

## 🛠️ Project Structure

### 1. UART (Top Module)

**Inputs:**
- `clk`: System clock (example: 100 MHz)
- `reset`: Asynchronous reset
- `start`: Signal to start transmission
- `in [7:0]`: 8-bit input data to send
- `rx`: Serial input line

**Outputs:**
- `tx`: Serial output line
- `tx_inprog`: Transmission in progress flag
- `shift_reg [7:0]`: Received data from Rx
- `rx_ready`: Reception complete flag

**Description:**  
The UART module connects the Tx and Rx modules. It controls sending and receiving operations based on external signals.

---

### 2. Tx (Transmitter Module)

**Inputs:**
- `clk`
- `reset`
- `start`
- `in [7:0]` (data byte to send)

**Outputs:**
- `tx` (serial output line)
- `tx_inprog` (transmission ongoing flag)

**Working:**
- Waits for a `start` signal.
- Serializes the 8-bit input with UART framing: start bit (0), 8 data bits (LSB first), stop bit (1).
- Controls timing based on a baud rate of 9600 bps.
- State machine transitions through:  
  `IDLE -> START -> DATA -> STOP -> IDLE`

**Highlights:**
- Mid-bit sampling to accurately start transmission.
- Manages proper bit timing using a baud counter.

---

### 3. Rx (Receiver Module)

**Inputs:**
- `clk`
- `reset`
- `rx` (serial input line)

**Outputs:**
- `shift_reg [7:0]` (received data)
- `rx_ready` (reception complete flag)

**Working:**
- Continuously monitors the `rx` line for a falling edge (start bit).
- After detecting a start bit, samples 8 data bits.
- Samples are timed according to the baud rate.
- Once 8 bits and a stop bit are received, `rx_ready` is asserted.

**Highlights:**
- Mid-bit sampling for better noise immunity.
- Easy interface with `shift_reg` showing the received byte after `rx_ready` goes high.

---

## 📈 Baud Rate and Clock Frequency

- **Baud Rate:** 9600 bps
- **Clock Frequency:** 100 MHz
- **Baud Ticks Calculation:**
- baud_ticks = clk_freq / baud_rate = 100,000,000 / 9600 ≈ 10416
- `baud_counter` controls the timing for each bit transmission and reception.

---

## 🧠 Finite State Machines (FSMs)

Both Tx and Rx modules use simple FSMs:

| State  | Tx Description                         | Rx Description                      |
|--------|----------------------------------------|-------------------------------------|
| IDLE   | Wait for start signal                  | Wait for falling edge (start bit)   |
| START  | Transmit start bit (0)                  | Sample start bit                   |
| DATA   | Transmit 8 data bits                    | Receive 8 data bits                |
| STOP   | Transmit stop bit (1)                   | Wait for stop bit and complete     |

---

## 🚀 How to Use

1. Instantiate the `UART` module inside your top-level Verilog design.
2. Connect your system clock and reset.
3. Provide input data and a `start` pulse to send data.
4. Monitor the `tx` output for transmission.
5. Receive incoming serial data on `rx` and monitor `shift_reg` and `rx_ready` to get the received byte.

---

## 📂 Files

| File         | Description                  |
|--------------|-------------------------------|
| `UART.v`     | Top-level UART wrapper         |
| `Tx.v`       | UART transmitter module        |
| `Rx.v`       | UART receiver module           |

---

## ✨ Future Improvements

- Add support for variable baud rates
- Include optional parity bit generation and checking
- Implement framing error detection
- Add FIFO buffers for smoother data handling
- Double-buffering for transmission and reception

---

## **Tools & Requirements**  
- **FPGA Board** (e.g., Xilinx FPGA)  
- **Xilinx Vivado** (application to code)  
- **Verilog HDL or VHDL** (language)
  
---
