# SOCVisionSystem — IMX708 Camera Ecosystem

> **Open-source, production-grade camera sensor software for the Sony IMX708.**

Three projects, one stack. A Linux kernel driver, a C++ gRPC daemon, and a
cross-platform desktop GUI — working together to give you full control over
the Raspberry Pi Camera Module 3's 12MP sensor.

---

## 🏗️ The Stack

```
┌─────────────────────────────────────────────────────────────────────┐
│                        USER (you)                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  🖥️  imx708-gui                                              │   │
│  │  PySide6 Desktop App  ─── gRPC ──►                            │   │
│  │  macOS-inspired UI, real-time telemetry,                       │   │
│  │  frame capture, full sensor control                            │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                          │                                          │
│                          ▼ gRPC (protobuf)                          │
│                          │                                          │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  🌐  imx708-server                                            │   │
│  │  C++ gRPC Daemon  ─── ioctl ──►                               │   │
│  │  25 RPCs, streaming telemetry,                                │   │
│  │  frame capture, daemon mode                                   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                          │                                          │
│                          ▼ /dev/imx708N                             │
│                          │                                          │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  ⚙️  imx708-driver                                            │   │
│  │  Linux Kernel Module  ─── I2C ──►                             │   │
│  │  V4L2 sub-device, 30+ controls,                               │   │
│  │  sysfs, debugfs, ftrace                                       │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                          │                                          │
│                          ▼ MIPI CSI-2                               │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  📷  Sony IMX708 Sensor                                      │   │
│  │  11.9 MP, 10-bit RAW, HDR, PDAF                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Projects

| Project | What it does | Language | Status |
|---------|-------------|----------|--------|
| [**imx708-driver**](./projects/driver) | Linux kernel module + C library | C | ✅ Production |
| [**imx708-server**](./projects/server) | C++ gRPC daemon | C++17 | ✅ Active |
| [**imx708-gui**](./projects/gui) | Cross-platform desktop GUI | Python/PySide6 | ✅ Active |

### ⚙️ imx708-driver
The foundation. A full V4L2 sub-device kernel driver for the Sony IMX708
sensor with 30+ controls, sysfs ABI, debugfs diagnostics, ftrace integration,
and a thread-safe C library for userspace applications.

[Read more →](./projects/driver)

### 🌐 imx708-server
The bridge. A C++ gRPC daemon that wraps the driver's ioctl interface into
25 network RPCs — unary and streaming — so any gRPC-capable client can
control the sensor remotely.

[Read more →](./projects/server)

### 🖥️ imx708-gui
The interface. A beautiful macOS-inspired PySide6 desktop application that
connects to the server over gRPC, displays real-time telemetry, and provides
full sensor control through an intuitive sidebar navigation.

[Read more →](./projects/gui)

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/SOCVisionSystem/imx708.git
cd imx708

# 2. Build everything
make

# 3. Start the server (requires hardware)
sudo make server-daemon

# 4. Launch the GUI
make gui-run
```

[Full quick start guide →](./guide/quickstart)

---

## 🤝 Contributing

We welcome contributions of all kinds — code, documentation, bug reports,
and feature requests.

- [Contribution guide](./guide/contributing)
- [Code of Conduct](./guide/contributing#code-of-conduct)
- [Open an issue](https://github.com/SOCVisionSystem/imx708/issues)
- [Submit a pull request](https://github.com/SOCVisionSystem/imx708/pulls)

### Ways to Contribute

| Area | Good for beginners? | Skills needed |
|------|:---:|---------------|
| 🐛 Bug reports | ✅ Yes | Any |
| 📖 Documentation | ✅ Yes | Technical writing |
| 🧪 Test cases | ✅ Yes | C, C++, or Python |
| 🎨 GUI improvements | ✅ Yes | Python, PySide6 |
| 🌐 Server features | ❌ Intermediate | C++17, gRPC |
| ⚙️ Driver development | ❌ Advanced | C, Linux kernel |

---

## 📄 License

All three projects are licensed under **GNU General Public License v2.0-only**.

```
Copyright (C) 2026 SOCVisionSystem
Author: Sandesh <sandesh@soccentric.com>
```

---

*Built with ❤️ for the Raspberry Pi and open-source community.*
