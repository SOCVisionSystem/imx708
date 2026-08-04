---
layout: default
title: IMX708 Camera Ecosystem
---

<div style="text-align:center;">

SOCVisionSystem / IMX708 Camera Ecosystem
==========================================

</div>

The IMX708 Camera Ecosystem is an open-source software stack for the Sony
IMX708 11.9MP CMOS image sensor — the sensor powering the Raspberry Pi
Camera Module 3. It consists of three projects that work together to give
you full control over the sensor from kernel to desktop. At the bottom
is imx708-driver, a production-grade Linux kernel module that implements
a full V4L2 sub-device with 30+ controls, sysfs ABI, debugfs diagnostics,
and a thread-safe C library. Above it sits imx708-server, a C++ gRPC
daemon that wraps the driver's ioctl interface into 25 network RPCs for
remote sensor control. At the top is imx708-gui, a cross-platform PySide6
desktop application with a macOS-inspired design that connects to the
server over gRPC and provides real-time telemetry, frame capture, and
full sensor configuration. All three projects are licensed under
GPL-2.0-only, built with open-source toolchains, and designed to be
extensible, testable, and production-ready.

Ecosystem Features
==================

- Full software stack from kernel to desktop, all open source and
  designed to work together
- V4L2 sub-device kernel driver with 30+ controls for the Sony IMX708
  11.9MP CMOS image sensor
- Platform abstraction layer enabling new SoC support without modifying
  core driver code
- I2C regmap with 16-bit big-endian register addressing and retry logic
- Runtime power management with autosuspend and regulator/GPIO sequencing
- Char device interface at /dev/imx708N with 16 properly-encoded ioctls
- Sysfs attributes for temperature, streaming, frame count, chip ID, and
  driver version
- Debugfs interface with register dump, IRQ counters, and fault injection
- FTrace integration with tracepoints for probe, remove, power, stream,
  and IRQ events
- Thread-safe C library with static and shared builds, pkg-config, and
  symbol versioning
- 25 gRPC RPCs across 9 categories for full remote sensor control
- Server-side streaming for real-time telemetry and continuous frame
  delivery
- RAII C++ Camera class with internal mutex for thread-safe access
- Daemon mode with double-fork, PID file, and graceful shutdown
- Cross-platform PySide6 desktop GUI with macOS-inspired design
- Custom-painted MacSlider widget with gradient fill and rounded knob
- Real-time telemetry via gRPC streaming with live status cards
- Frame capture with single and burst mode up to 100 frames
- Register read/write with known register quick-access and history log
- Standalone executable via PyInstaller with system-wide install support
- Multi-arch Docker builds for amd64, arm64, arm/v7, and arm/v6
- Debian, RPM, and IPK packaging for production deployment
- Catch2 unit tests for server modules and 23 unit tests for GUI client
- Comprehensive documentation with build, install, API, and porting guides
- SPDX license headers on every source file with GPL-2.0-only licensing


imx708-driver
=============

Linux kernel module and userspace C library for the Sony IMX708 camera
sensor. Implements a full V4L2 sub-device with 30+ controls, sysfs ABI,
debugfs diagnostics, ftrace integration, and a thread-safe C library.
The driver handles I2C register access via regmap, runtime power
management with regulator and GPIO sequencing, and provides a char
device interface for ioctl-based control. It is the foundation that the
entire ecosystem builds on.

- Full V4L2 sub-device with s_stream, get_fmt/set_fmt, enum_mbus_code,
  enum_frame_size, and g_frame_interval operations
- 30+ V4L2 controls including analog/digital gain, exposure, HDR, test
  patterns, white balance, scene modes, and color effects
- Platform abstraction layer via imx708_hw_ops for adding new SoC
  variants without changing core driver code
- I2C regmap with 16-bit big-endian register addressing and retry logic
- Runtime power management with autosuspend and regulator sequencing
- Char device at /dev/imx708N with 16 ioctls and 32/64-bit compatibility
- Sysfs attributes for temperature, streaming, frame count, and chip ID
- Debugfs with register dump, IRQ counters, and fault injection
- FTrace integration with tracepoints for all major events
- Thread-safe C library with static/shared builds and pkg-config support


imx708-server
=============

C++ gRPC daemon that exposes every feature of the IMX708 camera sensor
over the network. Implements 25 RPCs across 9 categories including basic
control, mode switching, gain/exposure, HDR, test patterns, image
processing, frame capture, profiles, register access, and streaming
telemetry. Built with RAII C++17, Catch2 tests, and Doxygen documentation.
The server bridges the kernel driver to any gRPC-capable client.

- 25 gRPC RPCs including unary calls and server-side streaming for
  real-time telemetry and continuous frame delivery
- RAII Camera class wrapping libimx708 with internal mutex for
  thread-safe access from concurrent RPC handlers
- Daemon mode with double-fork, PID file management, and graceful
  SIGINT/SIGTERM shutdown
- Input validation on all capture parameters to prevent memory exhaustion
- 100 MB max message size for full-resolution frame data
- gRPC reflection and health check enabled for debugging
- Default bind to 127.0.0.1 for security, configurable via --listen
- CMake build system with Ninja generator for fast builds
- Catch2 unit tests for camera, service, and server modules
- Multi-arch Docker builds for amd64, arm64, arm/v7, and arm/v6


imx708-gui
==========

Cross-platform PySide6 desktop application for controlling the IMX708
camera sensor over gRPC. Features a macOS-inspired design with custom-
painted widgets, real-time telemetry via gRPC streaming, and full sensor
control through an intuitive sidebar navigation. The GUI connects to the
gRPC server, displays live status cards, and provides controls for gain,
exposure, HDR, test patterns, image processing, and frame capture.

- macOS-inspired design with custom MacSlider, sidebar navigation, status
  cards, and SVG icons rendered at 2x for retina displays
- Thread-safe GrpcClient using Qt signals for cross-thread communication
  with auto-reconnect on stream drop
- Seven screens: Dashboard, Controls, Capture, Image Processing, Test
  Patterns, Registers, and Sensor Info
- Standalone executable via PyInstaller with system-wide install support
  including .desktop file and app icon
- QSettings persistence for window geometry and IMX708_SERVER environment
  variable for server address configuration
- Real-time telemetry via gRPC streaming with live status cards for
  temperature, streaming, PLL lock, and frame count
- Frame capture with single and burst mode up to 100 frames with save
  to file
- Register read/write with known register quick-access buttons and read
  history log
- Image processing controls for brightness, contrast, saturation, hue,
  sharpness, gamma, white balance, and flip
- Test pattern grid with 5 patterns and per-channel color component
  control


Contact
-------

Sandesh
Email: sandesh@soccentric.com
GitHub: https://github.com/SOCVisionSystem/imx708
