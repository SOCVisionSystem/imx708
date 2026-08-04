---
layout: default
title: IMX708 Camera Ecosystem
description: Open-source, production-grade camera sensor software for the Sony IMX708 — Linux kernel driver, C++ gRPC server, and PySide6 desktop GUI.
---

<section class="hero">
  <h1>IMX708 Camera Ecosystem</h1>
  <p>Open-source, production-grade camera sensor software for the Sony IMX708 — the sensor powering the Raspberry Pi Camera Module 3.</p>
  <div class="hero-actions">
    <a href="/imx708/guide/quickstart" class="btn btn-primary">🚀 Get Started</a>
    <a href="https://github.com/SOCVisionSystem/imx708" class="btn btn-secondary">View on GitHub</a>
  </div>
</section>

<section class="arch-section">
  <h2 style="text-align:center; margin-bottom: 2rem;">How It Works</h2>

  <div class="arch-diagram">
    <div class="arch-layer">
      <span class="layer-icon">🖥️</span>
      <div class="layer-name">imx708-gui</div>
      <div class="layer-desc">Cross-platform desktop application</div>
      <span class="layer-tech tech-green">Python · PySide6</span>
    </div>
    <div class="arch-arrow">▼</div>
    <div class="arch-layer" style="border-color: var(--blue); border-width: 2px;">
      <span class="layer-icon">🌐</span>
      <div class="layer-name">gRPC (protobuf)</div>
      <div class="layer-desc">25 RPCs · streaming telemetry · 100 MB frames</div>
      <span class="layer-tech tech-blue">:50051</span>
    </div>
    <div class="arch-arrow">▼</div>
    <div class="arch-layer">
      <span class="layer-icon">⚙️</span>
      <div class="layer-name">imx708-server</div>
      <div class="layer-desc">C++ gRPC daemon</div>
      <span class="layer-tech tech-orange">C++17 · gRPC</span>
    </div>
    <div class="arch-arrow">▼</div>
    <div class="arch-layer">
      <span class="layer-icon">🔧</span>
      <div class="layer-name">imx708-driver</div>
      <div class="layer-desc">Linux kernel module + C library</div>
      <span class="layer-tech tech-purple">C · V4L2 · I2C</span>
    </div>
    <div class="arch-arrow">▼</div>
    <div class="arch-layer">
      <span class="layer-icon">📷</span>
      <div class="layer-name">Sony IMX708 Sensor</div>
      <div class="layer-desc">11.9 MP · 10-bit RAW · HDR · PDAF</div>
      <span class="layer-tech" style="background: rgba(0,0,0,0.05); color: var(--gray-500);">MIPI CSI-2</span>
    </div>
  </div>
</section>

<section class="content">
  <h2>Three Projects, One Stack</h2>
  <p>From kernel to desktop — every layer is open source and built to work together.</p>

  <div class="card-grid">
    <div class="card">
      <div class="card-icon">⚙️</div>
      <h3>imx708-driver</h3>
      <p>Production-grade V4L2 kernel module with 30+ controls, sysfs ABI, debugfs diagnostics, and a thread-safe C library.</p>
      <a href="/imx708/projects/driver" class="card-link">Learn more →</a>
    </div>

    <div class="card">
      <div class="card-icon">🌐</div>
      <h3>imx708-server</h3>
      <p>C++ gRPC daemon exposing 25 RPCs — unary and streaming — for full remote sensor control over the network.</p>
      <a href="/imx708/projects/server" class="card-link">Learn more →</a>
    </div>

    <div class="card">
      <div class="card-icon">🖥️</div>
      <h3>imx708-gui</h3>
      <p>macOS-inspired PySide6 desktop app with real-time telemetry, frame capture, and full sensor control via gRPC.</p>
      <a href="/imx708/projects/gui" class="card-link">Learn more →</a>
    </div>
  </div>

  <h2>Quick Start</h2>
  <div class="card-grid">
    <div class="card">
      <h3>1. Build the driver</h3>
      <p style="font-size:0.8125rem; font-family: var(--mono); color: var(--gray-600);">cd imx708-driver && make && sudo make install</p>
    </div>
    <div class="card">
      <h3>2. Start the server</h3>
      <p style="font-size:0.8125rem; font-family: var(--mono); color: var(--gray-600);">cd imx708-server && make && sudo ./build/src/server/imx708-server</p>
    </div>
    <div class="card">
      <h3>3. Launch the GUI</h3>
      <p style="font-size:0.8125rem; font-family: var(--mono); color: var(--gray-600);">cd imx708-gui && make run SERVER=192.168.1.100:50051</p>
    </div>
  </div>

  <div style="text-align:center; margin-top: 2rem;">
    <a href="/imx708/guide/quickstart" class="btn btn-primary">Full Quick Start Guide →</a>
  </div>

  <h2>Contribute</h2>
  <p>We welcome contributions of all kinds — code, documentation, bug reports, and feature requests.</p>

  <div class="card-grid">
    <div class="card">
      <span class="badge badge-green">✅ Beginner</span>
      <h3 style="margin-top:0.5rem;">🐛 Bug Reports</h3>
      <p>Found a bug? Open an issue and help us fix it.</p>
    </div>
    <div class="card">
      <span class="badge badge-green">✅ Beginner</span>
      <h3 style="margin-top:0.5rem;">📖 Documentation</h3>
      <p>Help make the docs clearer and more complete.</p>
    </div>
    <div class="card">
      <span class="badge badge-blue">⚡ Intermediate</span>
      <h3 style="margin-top:0.5rem;">🎨 GUI Features</h3>
      <p>Dark mode, frame preview, keyboard shortcuts.</p>
    </div>
    <div class="card">
      <span class="badge badge-orange">🔧 Advanced</span>
      <h3 style="margin-top:0.5rem;">🌐 Server RPCs</h3>
      <p>Authentication, WebRTC streaming, Kubernetes.</p>
    </div>
    <div class="card">
      <span class="badge badge-red">🚀 Expert</span>
      <h3 style="margin-top:0.5rem;">⚙️ Driver Development</h3>
      <p>New SoC back-ends, HDR validation, PM optimization.</p>
    </div>
  </div>

  <div style="text-align:center; margin-top: 1rem;">
    <a href="/imx708/guide/contributing" class="btn btn-secondary">Read the Contribution Guide →</a>
  </div>

  <h2>License</h2>
  <p>All three projects are licensed under <strong>GNU General Public License v2.0-only</strong>.</p>
  <blockquote>
    <p>Copyright &copy; 2026 SOCVisionSystem · Built with ❤️ for the Raspberry Pi and open-source community.</p>
  </blockquote>
</section>
