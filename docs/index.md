---
layout: default
title: IMX708 Camera Ecosystem
---

<div style="text-align:center;">

SOCVisionSystem / IMX708 Camera Ecosystem
==========================================

Open-source software stack for the Sony IMX708 camera sensor — the
sensor behind the Raspberry Pi Camera Module 3. Three projects that
work together to give you full control over the sensor from kernel
to desktop.

</div>

Overall Project
---------------

  Repository:  https://github.com/SOCVisionSystem/imx708
  License:      GPL-2.0-only
  Language:     C, C++17, Python
  Platform:     Linux (Raspberry Pi, x86_64)


imx708-driver
=============

Linux kernel module and userspace C library for the Sony IMX708
camera sensor. Implements a full V4L2 sub-device with 30+ controls,
sysfs ABI, debugfs diagnostics, ftrace integration, and a thread-safe
C library. The driver handles I2C register access via regmap, runtime
power management with regulator and GPIO sequencing, and provides a
char device interface for ioctl-based control. It is the foundation
that the entire ecosystem builds on.

  • V4L2 sub-device with s_stream, get_fmt/set_fmt, enum_mbus_code,
    enum_frame_size, and g_frame_interval operations
  • 30+ controls including analog/digital gain, exposure, HDR, test
    patterns, white balance, scene modes, and color effects
  • Platform abstraction layer via imx708_hw_ops for adding new SoC
    variants without changing core driver code
  • Thread-safe C library (libimx708) with static and shared builds,
    pkg-config support, and symbol versioning
  • Comprehensive test suite with unit tests, CLI tool, stress tester,
    and frame capture application


imx708-server
=============

C++ gRPC daemon that exposes every feature of the IMX708 camera
sensor over the network. Implements 25 RPCs across 9 categories
including basic control, mode switching, gain/exposure, HDR, test
patterns, image processing, frame capture, profiles, register access,
and streaming telemetry. Built with RAII C++17, Catch2 tests, and
Doxygen documentation. The server bridges the kernel driver to any
gRPC-capable client.

  • 25 gRPC RPCs including unary calls and server-side streaming for
    real-time telemetry and continuous frame delivery
  • RAII Camera class wrapping libimx708 with internal mutex for
    thread-safe access from concurrent RPC handlers
  • Daemon mode with double-fork, PID file management, and graceful
    SIGINT/SIGTERM shutdown
  • Input validation on all capture parameters to prevent memory
    exhaustion from untrusted clients
  • 100 MB max message size for full-resolution frame data with
    gRPC reflection and health check enabled


imx708-gui
==========

Cross-platform PySide6 desktop application for controlling the
IMX708 camera sensor over gRPC. Features a macOS-inspired design
with custom-painted widgets, real-time telemetry via gRPC streaming,
and full sensor control through an intuitive sidebar navigation.
The GUI connects to the gRPC server, displays live status cards,
and provides controls for gain, exposure, HDR, test patterns, image
processing, and frame capture.

  • macOS-inspired design with custom MacSlider, sidebar navigation,
    status cards, and SVG icons rendered at 2x for retina displays
  • Thread-safe GrpcClient using Qt signals for cross-thread
    communication with auto-reconnect on stream drop
  • Seven screens: Dashboard, Controls, Capture, Image Processing,
    Test Patterns, Registers, and Sensor Info
  • Standalone executable via PyInstaller with system-wide install
    support including .desktop file and app icon
  • QSettings persistence for window geometry and IMX708_SERVER
    environment variable for server address configuration


Contact
-------

  Sandesh
  Email: sandesh@soccentric.com
  GitHub: https://github.com/SOCVisionSystem/imx708
