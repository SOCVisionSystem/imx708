---
layout: default
title: imx708-server — C++ gRPC Daemon
---

# 🌐 imx708-server — C++ gRPC Daemon

> **The bridge.** A production-grade C++ gRPC server that exposes every feature
> of the IMX708 camera sensor over the network. Designed as the backbone of the
> IMX708 ecosystem.

[GitHub →](https://github.com/SOCVisionSystem/imx708/tree/main/imx708-server)

---

## Features

### 25 gRPC RPCs — Full Sensor Control

| Category | RPCs | Type |
|----------|------|------|
| **Basic** | `GetStatus`, `StartStream`, `StopStream`, `SoftReset` | Unary |
| **Modes** | `GetModes`, `SetMode` | Unary |
| **Gain** | `GetGain`, `SetGain` | Unary |
| **Exposure** | `GetExposure`, `SetExposure` | Unary |
| **HDR** | `GetHdr`, `SetHdr` | Unary |
| **Test Patterns** | `GetTestPattern`, `SetTestPattern` | Unary |
| **Image Processing** | `GetImageProcessing`, `SetImageProcessing` | Unary |
| **Capture** | `CaptureFrame`, `CaptureFrames` | Unary / Server stream |
| **Profiles** | `SaveProfile`, `LoadProfile`, `ListProfiles` | Unary / Server stream |
| **Registers** | `ReadRegister`, `WriteRegister` | Unary |
| **Streaming** | `StreamStatus`, `StreamFrames` | Server stream |

### Production-Grade Design
- **RAII everywhere** — no manual resource management
- **Thread-safe** — gRPC handles concurrency; Camera class is internally synchronized
- **Graceful shutdown** — SIGINT/SIGTERM handler with `Wait()`
- **Daemon mode** — `fork()` + `setsid()` + PID file
- **100MB message support** — for full-resolution frame data
- **gRPC reflection** — for `grpcurl` debugging
- **Health check** — gRPC health service enabled
- **Security** — binds to `127.0.0.1` by default (not `0.0.0.0`)

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  imx708-server                                               │
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  main.cpp    │  │  server.cpp  │  │  service.cpp │       │
│  │  (entry)     │  │  (daemon)    │  │  (25 RPCs)   │       │
│  └──────┬───────┘  └──────────────┘  └──────┬───────┘       │
│         │                                    │               │
│         └────────────────┬───────────────────┘               │
│                           │                                   │
│                    ┌──────▼──────┐                            │
│                    │  camera.cpp │  (RAII C++ wrapper)        │
│                    │  libimx708  │  (C library)               │
│                    └──────┬──────┘                            │
│                           │                                   │
│                    ┌──────▼──────┐                            │
│                    │  /dev/imx708N│  (kernel ioctl)            │
│                    └─────────────┘                            │
└─────────────────────────────────────────────────────────────┘
```

## Build

```bash
cd imx708-server

# Build the driver's library first
cd ../imx708-driver && make lib && cd ../imx708-server

# Configure and build
make all

# Run tests
make test

# Run the example
make run
```

## Run

```bash
# Foreground
sudo ./build/src/server/imx708-server --device /dev/imx7080 --port 50051

# As a daemon
sudo ./build/src/server/imx708-server --daemon --device /dev/imx7080

# Test with grpcurl
grpcurl -plaintext localhost:50051 list
grpcurl -plaintext localhost:50051 imx708.Imx708Service/GetStatus
```

## Contribute

- [Open an issue](https://github.com/SOCVisionSystem/imx708/issues)
- [Submit a PR](https://github.com/SOCVisionSystem/imx708/pulls)
- Areas needing help: additional RPC implementations, authentication,
  WebRTC frame streaming, Kubernetes deployment
