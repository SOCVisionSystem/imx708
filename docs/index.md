---
layout: default
title: IMX708 Camera Ecosystem
---

SOCVisionSystem / IMX708 Camera Ecosystem
==========================================

Open-source software stack for the Sony IMX708 camera sensor — the
sensor behind the Raspberry Pi Camera Module 3. Three projects that
work together to give you full control over the sensor from kernel
to desktop.


Overall Project
---------------

  Repository:  https://github.com/SOCVisionSystem/imx708
  License:      GPL-2.0-only
  Language:     C, C++17, Python
  Platform:     Linux (Raspberry Pi, x86_64)


Projects
--------

  • imx708-driver — Linux kernel module (V4L2 sub-device) with 30+
    controls, sysfs ABI, debugfs, ftrace, and a C library.

  • imx708-server — C++ gRPC daemon with 25 RPCs for remote sensor
    control over the network.

  • imx708-gui — PySide6 desktop application with real-time telemetry,
    frame capture, and full sensor control via gRPC.


Contact
-------

  Sandesh
  Email: sandesh@soccentric.com
  GitHub: https://github.com/SOCVisionSystem/imx708
