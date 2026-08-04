---
layout: default
title: imx708-gui — PySide6 Desktop Application
---

# 🖥️ imx708-gui — PySide6 Desktop Application

> **The interface.** A stunning macOS-inspired desktop application for controlling
> the Sony IMX708 camera sensor over gRPC. Features beautiful sidebar navigation,
> real-time telemetry, and full sensor control.

[GitHub →](https://github.com/SOCVisionSystem/imx708/tree/main/imx708-gui)

---

## Features

### 🎨 macOS-Inspired Design
- Beautiful sidebar with SVG icons and hover effects
- Custom-painted sliders with gradient fill and rounded knobs
- Status cards with real-time telemetry
- Dark/light aware design tokens
- Responsive layout with resizable panels

### 📊 Dashboard — Real-Time Sensor Telemetry
- Live status cards — temperature, FPS, resolution, PLL lock, frame count
- Connection controls — Connect/Disconnect, Start/Stop Stream, Soft Reset
- Quick controls — gain slider, exposure slider, HDR toggle
- Status bar — connection state, streaming state, error messages

### 🎛️ Controls — Full Sensor Configuration
- Analog Gain — slider with fine-tune (0–960)
- Digital Gain — slider with fine-tune (256–65535)
- Exposure — slider with live readout (8–65487 line units)
- HDR Mode — toggle with ratio selector

### 📸 Capture — Frame Acquisition
- Single capture and burst mode
- Format selection (RAW10, PGM)
- Save to file with custom filename
- Frame metadata — timestamp, dimensions, gain, exposure

### 🎨 Test Patterns — Built-In Pattern Generator
- 5 patterns: Disabled, Color Bars, Solid Color, Grey Bars, PN9
- Per-channel color control (R, Gr, B, Gb)
- Brightness adjustment

### 🔧 Registers — Direct Hardware Access (Debug)
- Known register quick-access buttons
- Custom read/write with hex input
- Read history log

### ℹ️ Info — Sensor Reference
- Sensor specifications table
- Supported modes table with timings
- Driver feature reference

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  imx708-gui                                                 │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  MainWindow  │  │  Sidebar     │  │  Pages       │       │
│  │  (QMainWin)  │  │  (7 items)   │  │  (7 screens) │       │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘       │
│         │                                    │               │
│         └────────────────┬───────────────────┘               │
│                           │                                   │
│                    ┌──────▼──────┐                            │
│                    │ GrpcClient  │  (QObject, threaded)       │
│                    │  gRPC stubs │  (protobuf)                │
│                    └──────┬──────┘                            │
│                           │                                   │
│                    ┌──────▼──────┐                            │
│                    │ imx708-server│  (gRPC :50051)             │
│                    └─────────────┘                            │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
cd imx708-gui

# Install dependencies
pip install -r requirements.txt

# Generate gRPC stubs
./build.sh

# Launch the GUI
python3 imx708_client.py --server 192.168.1.100:50051
```

## Build Standalone Executable

```bash
# Build a single-file executable
./build.sh --exe

# The executable is in dist/
./dist/IMX708Cam --server 192.168.1.100:50051

# Install system-wide
sudo make install
imx708-cam --server 192.168.1.100:50051
```

## Package Structure

```
imx708-gui/
├── imx708_client.py            # Entry point
├── imx708_gui/                 # Python package
│   ├── theme.py                # Design tokens, SVG icons
│   ├── widgets.py              # Custom widgets (MacSlider, Sidebar)
│   ├── grpc_client.py          # gRPC client (threaded)
│   ├── main_window.py          # Main window with QSettings
│   └── pages/                  # 7 page screens
│       ├── dashboard.py
│       ├── controls.py
│       ├── capture.py
│       ├── image.py
│       ├── patterns.py
│       ├── registers.py
│       └── info.py
├── proto/imx708.proto          # gRPC service definition
└── packaging/                  # Installer files
    ├── imx708-cam.desktop
    └── imx708-cam.sh
```

## Contribute

- [Open an issue](https://github.com/SOCVisionSystem/imx708/issues)
- [Submit a PR](https://github.com/SOCVisionSystem/imx708/pulls)
- Areas needing help: dark mode theme, frame preview rendering,
  keyboard shortcuts, settings persistence, localization
