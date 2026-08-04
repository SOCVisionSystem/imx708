---
layout: default
title: IMX708 Camera Ecosystem
description: Open-source camera sensor software for the Sony IMX708 — kernel driver, gRPC server, and desktop GUI.
---

<div class="hero">
  <h1>IMX708 Camera Ecosystem</h1>
  <p>Open-source software stack for the Sony IMX708 — the sensor behind the Raspberry Pi Camera Module 3. Kernel driver, gRPC server, and a beautiful desktop GUI.</p>
  <div class="hero-actions">
    <a href="/imx708/guide/quickstart" class="btn btn-primary">Get Started</a>
    <a href="https://github.com/SOCVisionSystem/imx708" class="btn btn-secondary">GitHub</a>
  </div>
</div>

<div class="screenshot-wrap">
  <img src="/imx708/assets/images/screenshot.png" alt="IMX708 GUI Screenshot — Dashboard with real-time telemetry">
</div>

<div class="content">

  <h2>Three Projects</h2>
  <p>From kernel to desktop — every layer is open source and designed to work together.</p>

  <div class="card-grid">
    <div class="card">
      <h3>⚙️ imx708-driver</h3>
      <p>Linux kernel module (V4L2 sub-device) with 30+ controls, sysfs ABI, debugfs, ftrace, and a thread-safe C library.</p>
      <a href="/imx708/projects/driver" class="arrow">Learn more →</a>
    </div>
    <div class="card">
      <h3>🌐 imx708-server</h3>
      <p>C++ gRPC daemon with 25 RPCs — unary and streaming — for full remote sensor control over the network.</p>
      <a href="/imx708/projects/server" class="arrow">Learn more →</a>
    </div>
    <div class="card">
      <h3>🖥️ imx708-gui</h3>
      <p>macOS-inspired PySide6 desktop app with real-time telemetry, frame capture, and full sensor control via gRPC.</p>
      <a href="/imx708/projects/gui" class="arrow">Learn more →</a>
    </div>
  </div>

  <h2>Quick Start</h2>
  <pre>git clone https://github.com/SOCVisionSystem/imx708.git
cd imx708
make                    # build everything
sudo make server-daemon # start the gRPC daemon
make gui-run            # launch the GUI</pre>

  <p style="text-align:center; margin-top: 1.5rem;">
    <a href="/imx708/guide/quickstart" class="btn btn-primary">Full Quick Start Guide</a>
  </p>

  <h2>Contribute</h2>
  <p>We welcome contributions of all kinds — code, documentation, bug reports, and feature requests.</p>

  <div class="card-grid">
    <div class="card">
      <span class="badge badge-green">Beginner</span>
      <h3>🐛 Bug Reports</h3>
      <p>Found a bug? Open an issue and help us fix it.</p>
    </div>
    <div class="card">
      <span class="badge badge-green">Beginner</span>
      <h3>📖 Documentation</h3>
      <p>Help make the docs clearer and more complete.</p>
    </div>
    <div class="card">
      <span class="badge badge-blue">Intermediate</span>
      <h3>🎨 GUI Features</h3>
      <p>Dark mode, frame preview, keyboard shortcuts.</p>
    </div>
    <div class="card">
      <span class="badge badge-orange">Advanced</span>
      <h3>🌐 Server RPCs</h3>
      <p>Authentication, WebRTC streaming, Kubernetes.</p>
    </div>
    <div class="card">
      <span class="badge badge-red">Expert</span>
      <h3>⚙️ Driver</h3>
      <p>New SoC back-ends, HDR validation, PM optimization.</p>
    </div>
  </div>

  <p style="text-align:center; margin-top: 1rem;">
    <a href="/imx708/guide/contributing" class="btn btn-secondary">Contribution Guide</a>
  </p>

  <h2>License</h2>
  <blockquote>
    <p>All three projects are licensed under <strong>GNU General Public License v2.0-only</strong>.<br>
    Copyright &copy; 2026 SOCVisionSystem. Built with ❤️ for the Raspberry Pi community.</p>
  </blockquote>

</div>
