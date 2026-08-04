---
layout: default
title: IMX708 Camera Ecosystem
---

SOCVisionSystem / IMX708 Camera Ecosystem
==========================================

Open-source software for the Sony IMX708 camera sensor — the sensor
powering the Raspberry Pi Camera Module 3.

Three projects that work together:

  ⚙️  imx708-driver   — Linux kernel module + C library
  🌐  imx708-server   — C++ gRPC daemon
  🖥️  imx708-gui      — PySide6 desktop application


Quick Start
-----------

  git clone https://github.com/SOCVisionSystem/imx708.git
  cd imx708
  make
  sudo make server-daemon
  make gui-run


Projects
--------

  ⚙️  imx708-driver
      V4L2 sub-device kernel driver with 30+ controls, sysfs ABI,
      debugfs diagnostics, ftrace integration, and a thread-safe
      C library for userspace applications.

      → /imx708/projects/driver

  🌐  imx708-server
      C++ gRPC daemon exposing 25 RPCs — unary and streaming — for
      full remote sensor control over the network.

      → /imx708/projects/server

  🖥️  imx708-gui
      macOS-inspired PySide6 desktop app with real-time telemetry,
      frame capture, and full sensor control via gRPC.

      → /imx708/projects/gui


Contribute
----------

  We welcome contributions of all kinds.

  Beginner:   Bug reports, documentation
  Intermediate: GUI features (dark mode, frame preview)
  Advanced:   Server RPCs (auth, WebRTC, Kubernetes)
  Expert:     Driver development (new SoC back-ends, HDR)

  → /imx708/guide/contributing


License
-------

  GNU General Public License v2.0-only
  Copyright (C) 2026 SOCVisionSystem
