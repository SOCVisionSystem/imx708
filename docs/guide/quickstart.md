---
layout: default
title: Quick Start Guide
---

# 🚀 Quick Start Guide

Get the entire IMX708 ecosystem up and running in minutes.

---

## Prerequisites

### Hardware
- Raspberry Pi 4 or 5 (or any Linux system with kernel headers)
- Raspberry Pi Camera Module 3 (Sony IMX708)
- 64-bit operating system (Raspberry Pi OS, Ubuntu, etc.)

### Software
```bash
# Build essentials
sudo apt update
sudo apt install -y build-essential cmake ninja-build \
  libgrpc++-dev libprotobuf-dev protobuf-compiler-grpc \
  python3 python3-pip

# Python dependencies (for GUI)
pip install PySide6 grpcio grpcio-tools protobuf
```

---

## Step 1: Build the Kernel Driver

```bash
cd imx708-driver

# Build everything (kernel module + library + test apps)
make

# Install
sudo make install

# Load the module
sudo modprobe imx708

# Verify
ls /dev/imx708*
cat /sys/bus/i2c/devices/*-001a/temperature
```

**Expected output:**
```
/dev/imx7080
32
```

---

## Step 2: Build the gRPC Server

```bash
cd imx708-server

# Build (also builds the driver's library if needed)
make all

# Run tests
make test
```

**Expected output:**
```
100% tests passed, 0 tests failed out of 3
```

---

## Step 3: Start the Server

```bash
# Run in foreground (for testing)
sudo ./build/src/server/imx708-server \
  --device /dev/imx7080 \
  --port 50051

# Or run as a daemon
sudo ./build/src/server/imx708-server \
  --daemon \
  --device /dev/imx7080

# Verify with grpcurl
grpcurl -plaintext localhost:50051 imx708.Imx708Service/GetStatus
```

---

## Step 4: Launch the GUI

```bash
cd imx708-gui

# Generate gRPC stubs
make all

# Launch the GUI (replace with your server's IP)
python3 imx708_client.py --server 192.168.1.100:50051

# Or build a standalone executable
make exe
./dist/IMX708Cam --server 192.168.1.100:50051
```

---

## One-Command Build

From the repository root, build everything at once:

```bash
cd imx708
make
```

This runs: `driver → server → gui-proto` in dependency order.

---

## What's Next?

- [Explore the driver features](../projects/driver)
- [Read the server API docs](../projects/server)
- [Customize the GUI](../projects/gui)
- [Contribute to the project](../guide/contributing)

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `make` fails on kernel module | Install kernel headers: `sudo apt install linux-headers-$(uname -r)` |
| gRPC not found | `sudo apt install libgrpc++-dev protobuf-compiler-grpc` |
| GUI says "gRPC not available" | `pip install grpcio grpcio-tools` |
| Server won't bind to port | Check if another instance is running: `sudo lsof -i :50051` |
| No `/dev/imx7080` | Check `dmesg` for probe errors; verify hardware connection |
| Temperature reads 0°C | Sensor is in standby; start streaming first |
