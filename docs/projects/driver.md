---
layout: default
title: imx708-driver — Linux Kernel Module
---

# ⚙️ imx708-driver — Linux Kernel Module

> **The foundation.** A production-grade V4L2 sub-device driver for the Sony
> IMX708 11.9MP CMOS image sensor — the sensor powering the Raspberry Pi
> Camera Module 3.

[GitHub →](https://github.com/SOCVisionSystem/imx708/tree/main/imx708-driver)

---

## Features

### Kernel Module (`imx708.ko`)
- **Full V4L2 sub-device** — `s_stream`, `get_fmt`/`set_fmt`, `enum_mbus_code`,
  `enum_frame_size`, `g_frame_interval`
- **30+ V4L2 controls** — analog/digital gain, exposure, HDR, test patterns,
  white balance, brightness, contrast, saturation, hue, gamma, sharpness,
  3A lock, scene modes, color effects, zoom/pan/tilt, power line frequency,
  backlight compensation, ISO
- **Platform abstraction** — SoC-specific ops via `imx708_hw_ops` interface
- **I2C regmap** — 16-bit big-endian register addressing with retry logic
- **Runtime PM** — autosuspend with full regulator + GPIO sequencing
- **Interrupt handling** — threaded IRQ with atomic event latching
- **Sysfs ABI** — temperature, streaming state, frame count, chip ID
- **Char device** — `/dev/imx708N` with ioctl-based control
- **Debugfs** — per-instance register dump, IRQ counters, trace ring buffer
- **FTrace integration** — tracepoints for probe, remove, power, stream, IRQ
- **Device tree** — overlay for Raspberry Pi
- **Multi-platform** — native x86_64 + cross-compile for RPi4/RPi5

### Userspace C Library (`libimx708`)
- Static + shared (`libimx708.a` / `libimx708.so.0`)
- Full API coverage — open/close, gain, exposure, HDR, test patterns,
  image processing, capture, register access, profiles
- Thread-safe with internal mutex protection
- pkg-config integration
- Symbol versioning for ABI stability

### Test Suite
| Tool | Purpose |
|------|---------|
| `imx708_test` | Comprehensive test suite (unit + integration) |
| `imx708_cli` | Interactive CLI for manual sensor control |
| `imx708_stress` | Long-duration stress testing |
| `imx708_capture` | Frame capture to file (RAW10, PGM) |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  imx708.ko                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │  main    │ │ platform │ │ chardev  │ │ sysfs    │       │
│  │ (probe)  │ │ (SoC ops)│ │ (ioctl)  │ │ (attrs)  │       │
│  ├──────────┤ ├──────────┤ ├──────────┤ ├──────────┤       │
│  │  debugfs │ │ irq      │ │ pm       │ │ trace    │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
│                         │                                   │
│                    ┌────▼────┐                              │
│                    │  regmap  │  (I2C, 16-bit addr)         │
│                    └────┬────┘                              │
│                         │                                   │
│                    ┌────▼────┐                              │
│                    │ IMX708  │  (MIPI CSI-2, 2-lane)        │
│                    └─────────┘                              │
└─────────────────────────────────────────────────────────────┘
```

## Build

```bash
cd imx708-driver

# Native build
make

# Cross-compile for Raspberry Pi 4
make PLATFORM=rpi4 KERNEL_SRC=~/pi-kernel

# Build only the library
make lib

# Build only the test applications
make test
```

## Install

```bash
sudo make install
sudo modprobe imx708
ls /dev/imx708*
cat /sys/bus/i2c/devices/*-001a/temperature
```

## Contribute

- [Open an issue](https://github.com/SOCVisionSystem/imx708/issues)
- [Submit a PR](https://github.com/SOCVisionSystem/imx708/pulls)
- Areas needing help: additional SoC platform back-ends, HDR mode
  validation, power management optimization
