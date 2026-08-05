# SPDX-License-Identifier: GPL-2.0-only
#
# Top-level Makefile — build all IMX708 projects in dependency order
#
# Core stack:
#   imx708-driver  (kernel module + libimx708 C library)
#   └─► imx708-server  (C++ gRPC daemon, depends on libimx708)
#       └─► imx708-gui  (PySide6 desktop client, depends on server)
#
# Application layer (Python, depend on imx708-server):
#   imx708-detect     — Smart Detection Cam
#   imx708-nvr        — Motion-Triggered NVR
#   imx708-calibrate  — Camera Calibration & Auto-Tuning
#   imx708-streamer   — RTSP/WebRTC Streaming Daemon
#   imx708-scan       — Barcode, QR Code & Document Scanner
#   imx708-stereo     — Dual-IMX708 Stereo Depth Vision
#
# Usage:
#   make              Build driver + server + GUI (default)
#   make driver       Build kernel module + libimx708 + test apps
#   make server       Build gRPC server (also builds driver's lib)
#   make gui          Generate gRPC stubs for the GUI
#   make all          Same as default
#   make test         Run tests for all projects
#   make clean        Clean all build artifacts
#   make distclean    Deep clean (including .venv for GUI)
#   make help         Show this help
#

# ── Project directories ────────────────────────────────────────────────────
DRV_DIR  := imx708-driver
SRV_DIR  := imx708-server
GUI_DIR  := imx708-gui

# Application layer (Python projects)
DET_DIR  := imx708-detect
NVR_DIR  := imx708-nvr
CAL_DIR  := imx708-calibrate
STR_DIR  := imx708-streamer
SCN_DIR  := imx708-scan
STO_DIR  := imx708-stereo

APP_DIRS := $(DET_DIR) $(NVR_DIR) $(CAL_DIR) $(STR_DIR) $(SCN_DIR) $(STO_DIR)

# ── Build configuration ────────────────────────────────────────────────────
PLATFORM ?= native
JOBS     ?= $(shell nproc 2>/dev/null || echo 4)
SERVER   ?= localhost:50051

# ── Detect available tools ─────────────────────────────────────────────────
NINJA     := $(shell command -v ninja 2>/dev/null || echo make)
CMAKE     := cmake
PYTHON    := python3

# Generator name for CMake (-G flag): use "Ninja" if available, else "Unix Makefiles"
ifeq ($(NINJA),make)
  CMAKE_GENERATOR := Unix Makefiles
else
  CMAKE_GENERATOR := Ninja
endif

# ── Default target ─────────────────────────────────────────────────────────
.PHONY: all
all: driver server gui apps
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║  All IMX708 projects built successfully                ║"
	@echo "╚══════════════════════════════════════════════════════════╝"

# ═══════════════════════════════════════════════════════════════════════════
# imx708-driver — Linux kernel module + C library + test apps
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: driver
driver:
	@echo ""
	@echo "━━━ Building imx708-driver ━━━"
	$(MAKE) -C $(DRV_DIR) PLATFORM=$(PLATFORM) JOBS=$(JOBS) all

.PHONY: driver-module
driver-module:
	@echo "━━━ Building kernel module only ━━━"
	$(MAKE) -C $(DRV_DIR) PLATFORM=$(PLATFORM) module

.PHONY: driver-lib
driver-lib:
	@echo "━━━ Building userspace library only ━━━"
	$(MAKE) -C $(DRV_DIR) PLATFORM=$(PLATFORM) lib

.PHONY: driver-test
driver-test:
	@echo "━━━ Building test applications ━━━"
	$(MAKE) -C $(DRV_DIR) PLATFORM=$(PLATFORM) test

.PHONY: driver-install
driver-install:
	@echo "━━━ Installing imx708-driver ━━━"
	$(MAKE) -C $(DRV_DIR) install

# ═══════════════════════════════════════════════════════════════════════════
# imx708-server — C++ gRPC daemon (depends on libimx708 from driver)
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: server
server: driver-lib
	@echo ""
	@echo "━━━ Building imx708-server ━━━"
	@echo "  Generator: $(CMAKE_GENERATOR)"
	@echo "  Jobs:      $(JOBS)"
	@echo ""
	@mkdir -p $(SRV_DIR)/build
	cd $(SRV_DIR)/build && $(CMAKE) .. \
		-G"$(CMAKE_GENERATOR)" \
		-DCMAKE_BUILD_TYPE=Debug \
		-DBUILD_TESTS=ON \
		-DBUILD_EXAMPLES=ON \
		-DBUILD_DOCS=OFF
	cd $(SRV_DIR)/build && $(CMAKE) --build . -j$(JOBS)

.PHONY: server-configure
server-configure: driver-lib
	@echo "━━━ Configuring imx708-server ━━━"
	@mkdir -p $(SRV_DIR)/build
	cd $(SRV_DIR)/build && $(CMAKE) .. \
		-G"$(CMAKE_GENERATOR)" \
		-DCMAKE_BUILD_TYPE=Debug \
		-DBUILD_TESTS=ON \
		-DBUILD_EXAMPLES=ON

.PHONY: server-build
server-build:
	@echo "━━━ Building imx708-server (no configure) ━━━"
	cd $(SRV_DIR)/build && $(CMAKE) --build . -j$(JOBS)

.PHONY: server-test
server-test:
	@echo "━━━ Running imx708-server tests ━━━"
	cd $(SRV_DIR)/build && ctest --output-on-failure -j$(JOBS)

.PHONY: server-run
server-run: server
	@echo "━━━ Running imx708-server example ━━━"
	cd $(SRV_DIR)/build && ./examples/basic_usage/basic_usage

.PHONY: server-daemon
server-daemon: server
	@echo "━━━ Starting imx708-server daemon ━━━"
	sudo ./$(SRV_DIR)/build/src/server/imx708-server \
		--device /dev/imx7080 --port 50051

# ═══════════════════════════════════════════════════════════════════════════
# imx708-gui — PySide6 desktop client (depends on server proto)
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: gui
gui: gui-proto
	@echo ""
	@echo "━━━ imx708-gui stubs ready ━━━"
	@echo "  Run with: make gui-run SERVER=$(SERVER)"

.PHONY: gui-proto
gui-proto:
	@echo "━━━ Generating gRPC stubs for imx708-gui ━━━"
	$(MAKE) -C $(GUI_DIR) all

.PHONY: gui-run
gui-run: gui-proto
	@echo "━━━ Launching IMX708 GUI (server: $(SERVER)) ━━━"
	cd $(GUI_DIR) && $(PYTHON) imx708_client.py --server $(SERVER)

.PHONY: gui-deps
gui-deps:
	@echo "━━━ Installing GUI dependencies ━━━"
	cd $(GUI_DIR) && pip install -r requirements.txt

.PHONY: gui-exe
gui-exe: gui-proto
	@echo "━━━ Building standalone GUI executable ━━━"
	$(MAKE) -C $(GUI_DIR) exe

.PHONY: gui-install
gui-install: gui-exe
	@echo "━━━ Installing GUI to system ━━━"
	sudo $(MAKE) -C $(GUI_DIR) install

.PHONY: gui-uninstall
gui-uninstall:
	@echo "━━━ Uninstalling GUI from system ━━━"
	sudo $(MAKE) -C $(GUI_DIR) uninstall

# ═══════════════════════════════════════════════════════════════════════════
# Application layer — Python projects (depend on imx708-server)
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: apps detect nvr calibrate streamer scan stereo

apps: detect nvr calibrate streamer scan stereo
	@echo "━━━ All application-layer projects ready ━━━"

detect:
	@echo "━━━ imx708-detect — Smart Detection Cam ━━━"
	$(MAKE) -C $(DET_DIR) all

nvr:
	@echo "━━━ imx708-nvr — Motion-Triggered NVR ━━━"
	$(MAKE) -C $(NVR_DIR) all

calibrate:
	@echo "━━━ imx708-calibrate — Camera Calibration ━━━"
	$(MAKE) -C $(CAL_DIR) all

streamer:
	@echo "━━━ imx708-streamer — RTSP/WebRTC Streamer ━━━"
	$(MAKE) -C $(STR_DIR) all

scan:
	@echo "━━━ imx708-scan — Barcode/Document Scanner ━━━"
	$(MAKE) -C $(SCN_DIR) all

stereo:
	@echo "━━━ imx708-stereo — Stereo Depth Vision ━━━"
	$(MAKE) -C $(STO_DIR) all

# ── Run targets ────────────────────────────────────────────────────────────

.PHONY: detect-run nvr-run calibrate-run streamer-run scan-run stereo-run

detect-run:
	@echo "━━━ Running imx708-detect (server: $(SERVER)) ━━━"
	cd $(DET_DIR) && $(PYTHON) src/detect.py --server $(SERVER)

nvr-run:
	@echo "━━━ Running imx708-nvr (server: $(SERVER)) ━━━"
	cd $(NVR_DIR) && $(PYTHON) src/nvr.py --server $(SERVER)

calibrate-run:
	@echo "━━━ Running imx708-calibrate (server: $(SERVER)) ━━━"
	cd $(CAL_DIR) && $(PYTHON) src/calibrate.py --server $(SERVER)

streamer-run:
	@echo "━━━ Running imx708-streamer ━━━"
	cd $(STR_DIR) && $(PYTHON) src/streamer.py

scan-run:
	@echo "━━━ Running imx708-scan (server: $(SERVER)) ━━━"
	cd $(SCN_DIR) && $(PYTHON) src/scan.py --server $(SERVER)

stereo-run:
	@echo "━━━ Running imx708-stereo ━━━"
	cd $(STO_DIR) && $(PYTHON) src/stereo.py --server1 $(SERVER) --server2 $(subst 50051,50052,$(SERVER))

# ═══════════════════════════════════════════════════════════════════════════
# Commit — generate a commit message with sweet_commit and commit all changes
# ═══════════════════════════════════════════════════════════════════════════

# PROJECT selects which sub-project to commit: driver, server, gui, detect, nvr,
# calibrate, streamer, scan, stereo, or all.
# Default: all (commits each repo that has staged changes).
PROJECT ?= all

_COMMIT_DIRS := $(DRV_DIR) $(SRV_DIR) $(GUI_DIR) $(APP_DIRS)

.PHONY: commit
commit:
	@echo "━━━ Generating commit message with sweet_commit ━━━"
	@echo ""
	$(MAKE) _commit-$(PROJECT)

.PHONY: _commit-all _commit-driver _commit-server _commit-gui
.PHONY: _commit-detect _commit-nvr _commit-calibrate _commit-streamer _commit-scan _commit-stereo

_commit-all: _commit-driver _commit-server _commit-gui _commit-detect _commit-nvr _commit-calibrate _commit-streamer _commit-scan _commit-stereo

_commit-driver:
	@if [ -d $(DRV_DIR)/.git ]; then \
		echo "[imx708-driver]" && \
		cd $(DRV_DIR) && make clean && sweet_commit && git push ; \
	else \
		echo "$(DRV_DIR): not a git repo, skipping"; \
	fi

_commit-server:
	@if [ -d $(SRV_DIR)/.git ]; then \
		echo "[imx708-server]" && \
		cd $(SRV_DIR) && make clean && sweet_commit && git push ; \
	else \
		echo "$(SRV_DIR): not a git repo, skipping"; \
	fi

_commit-gui:
	@if [ -d $(GUI_DIR)/.git ]; then \
		echo "[imx708-gui]" && \
		cd $(GUI_DIR) && sweet_commit && git push ; \
	else \
		echo "$(GUI_DIR): not a git repo, skipping"; \
	fi

_commit-detect:
	@if [ -d $(DET_DIR)/.git ]; then \
		echo "[imx708-detect]" && \
		cd $(DET_DIR) && sweet_commit && git push ; \
	else \
		echo "$(DET_DIR): not a git repo, skipping"; \
	fi

_commit-nvr:
	@if [ -d $(NVR_DIR)/.git ]; then \
		echo "[imx708-nvr]" && \
		cd $(NVR_DIR) && sweet_commit && git push ; \
	else \
		echo "$(NVR_DIR): not a git repo, skipping"; \
	fi

_commit-calibrate:
	@if [ -d $(CAL_DIR)/.git ]; then \
		echo "[imx708-calibrate]" && \
		cd $(CAL_DIR) && sweet_commit && git push ; \
	else \
		echo "$(CAL_DIR): not a git repo, skipping"; \
	fi

_commit-streamer:
	@if [ -d $(STR_DIR)/.git ]; then \
		echo "[imx708-streamer]" && \
		cd $(STR_DIR) && sweet_commit && git push ; \
	else \
		echo "$(STR_DIR): not a git repo, skipping"; \
	fi

_commit-scan:
	@if [ -d $(SCN_DIR)/.git ]; then \
		echo "[imx708-scan]" && \
		cd $(SCN_DIR) && sweet_commit && git push ; \
	else \
		echo "$(SCN_DIR): not a git repo, skipping"; \
	fi

_commit-stereo:
	@if [ -d $(STO_DIR)/.git ]; then \
		echo "[imx708-stereo]" && \
		cd $(STO_DIR) && sweet_commit && git push ; \
	else \
		echo "$(STO_DIR): not a git repo, skipping"; \
	fi

# ═══════════════════════════════════════════════════════════════════════════
# Testing
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: test
test: driver-test server-test app-test
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║  All tests complete                                    ║"
	@echo "╚══════════════════════════════════════════════════════════╝"

.PHONY: app-test test-detect test-nvr test-calibrate test-streamer test-scan test-stereo

app-test: test-detect test-nvr test-calibrate test-streamer test-scan test-stereo

test-detect:
	@echo "━━━ Testing imx708-detect ━━━"
	cd $(DET_DIR) && $(MAKE) test

test-nvr:
	@echo "━━━ Testing imx708-nvr ━━━"
	cd $(NVR_DIR) && $(MAKE) test

test-calibrate:
	@echo "━━━ Testing imx708-calibrate ━━━"
	cd $(CAL_DIR) && $(MAKE) test

test-streamer:
	@echo "━━━ Testing imx708-streamer ━━━"
	cd $(STR_DIR) && $(MAKE) test

test-scan:
	@echo "━━━ Testing imx708-scan ━━━"
	cd $(SCN_DIR) && $(MAKE) test

test-stereo:
	@echo "━━━ Testing imx708-stereo ━━━"
	cd $(STO_DIR) && $(MAKE) test

# ═══════════════════════════════════════════════════════════════════════════
# Clean
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: clean
clean:
	@echo "━━━ Cleaning all projects ━━━"
	$(MAKE) -C $(DRV_DIR) clean
	$(MAKE) -C $(SRV_DIR) clean
	$(MAKE) -C $(GUI_DIR) clean
	for d in $(APP_DIRS); do $(MAKE) -C $$d clean; done
	@echo "Done."

.PHONY: distclean
distclean:
	@echo "━━━ Deep cleaning all projects ━━━"
	$(MAKE) -C $(DRV_DIR) distclean
	$(MAKE) -C $(SRV_DIR) distclean
	$(MAKE) -C $(GUI_DIR) distclean
	for d in $(APP_DIRS); do $(MAKE) -C $$d distclean 2>/dev/null || $(MAKE) -C $$d clean; done
	@echo "Done."

# ═══════════════════════════════════════════════════════════════════════════
# Help
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: help
help:
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║  IMX708 Ecosystem — Top-Level Build                     ║"
	@echo "╚══════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Projects:"
	@echo "  Core stack:"
	@echo "  imx708-driver  — Linux kernel module + libimx708 C library"
	@echo "  imx708-server  — C++ gRPC daemon (depends on libimx708)"
	@echo "  imx708-gui     — PySide6 desktop GUI (depends on server)"
	@echo ""
	@echo "  Application layer (Python, depend on imx708-server):"
	@echo "  imx708-detect     — Smart Detection Cam"
	@echo "  imx708-nvr        — Motion-Triggered NVR"
	@echo "  imx708-calibrate  — Camera Calibration & Auto-Tuning"
	@echo "  imx708-streamer   — RTSP/WebRTC Streaming Daemon"
	@echo "  imx708-scan       — Barcode, QR Code & Document Scanner"
	@echo "  imx708-stereo     — Dual-IMX708 Stereo Depth Vision"
	@echo ""
	@echo "Build targets:"
	@echo "  all            Build everything (default)"
	@echo "  driver         Build kernel module + lib + test apps"
	@echo "  driver-module  Build kernel module only"
	@echo "  driver-lib     Build userspace library only"
	@echo "  driver-test    Build test applications"
	@echo "  server         Build gRPC server (also builds driver lib)"
	@echo "  server-configure  CMake configure only"
	@echo "  server-build     Build without reconfiguring"
	@echo "  server-test      Run server unit tests"
	@echo "  server-run       Run the example client"
	@echo "  server-daemon    Start the gRPC daemon (requires sudo)"
	@echo "  gui            Generate gRPC stubs for the GUI"
	@echo "  gui-run        Launch the GUI (use SERVER=host:port)"
	@echo "  gui-deps       Install Python dependencies"
	@echo "  gui-exe        Build standalone executable"
	@echo "  gui-install    Build + install to system (sudo)"
	@echo "  gui-uninstall  Remove installed files (sudo)"
	@echo ""
	@echo "  apps           Build all application-layer projects"
	@echo "  detect         imx708-detect"
	@echo "  nvr            imx708-nvr"
	@echo "  calibrate      imx708-calibrate"
	@echo "  streamer       imx708-streamer"
	@echo "  scan           imx708-scan"
	@echo "  stereo         imx708-stereo"
	@echo ""
	@echo "  detect-run     Run imx708-detect"
	@echo "  nvr-run        Run imx708-nvr"
	@echo "  calibrate-run  Run imx708-calibrate"
	@echo "  streamer-run   Run imx708-streamer"
	@echo "  scan-run       Run imx708-scan"
	@echo "  stereo-run     Run imx708-stereo"
	@echo ""
	@echo "Other targets:"
	@echo "  test           Run tests for all projects"
	@echo "  commit [PROJECT=all|driver|server|gui|detect|nvr|calibrate|streamer|scan|stereo]"
	@echo "  clean          Remove build artifacts"
	@echo "  distclean      Deep clean (removes .venv for GUI)"
	@echo "  help           Show this help"
	@echo ""
	@echo "Parameters:"
	@echo "  PLATFORM=native|rpi4  Target platform (default: native)"
	@echo "  SERVER=host:port       gRPC server address (default: localhost:50051)"
	@echo "  JOBS=N                 Parallel build jobs (default: nproc)"
	@echo ""
	@echo "Quick start:"
	@echo "  make              # build everything"
	@echo "  make server-daemon # start the gRPC daemon"
	@echo "  make gui-run      # launch the GUI"
	@echo "  make detect-run   # run smart detection"
	@echo ""
	@echo "Dependency chain:"
	@echo "  driver-lib ──► server ──► gui-proto"
	@echo "       │              │"
	@echo "       │              ├── detect, nvr, calibrate, scan, stereo"
	@echo "       │              └── streamer (standalone V4L2)"
	@echo "       └── driver-test"
