# SPDX-License-Identifier: GPL-2.0-only
#
# Top-level Makefile — build all three IMX708 projects in dependency order
#
#   imx708-driver  (kernel module + libimx708 C library)
#   └─► imx708-server  (C++ gRPC daemon, depends on libimx708)
#       └─► imx708-gui  (PySide6 desktop client, depends on server)
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
all: driver server gui
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
# Commit — generate a commit message with sweet_commit and commit all changes
# ═══════════════════════════════════════════════════════════════════════════

# PROJECT selects which sub-project to commit: driver, server, gui, or all.
# Default: all (commits each repo that has staged changes).
PROJECT ?= all

_COMMIT_DIRS := $(DRV_DIR) $(SRV_DIR) $(GUI_DIR)

.PHONY: commit
commit:
	@echo "━━━ Generating commit message with sweet_commit ━━━"
	@echo ""
	$(MAKE) _commit-$(PROJECT)

.PHONY: _commit-all _commit-driver _commit-server _commit-gui

_commit-all: _commit-driver _commit-server _commit-gui

_commit-driver:
	@if [ -d $(DRV_DIR)/.git ]; then \
		echo "[imx708-driver]" && \
		cd $(DRV_DIR) && make clean &&  sweet_commit && git push ; \
	else \
		echo "$(DRV_DIR): not a git repo, skipping"; \
	fi

_commit-server:
	@if [ -d $(SRV_DIR)/.git ]; then \
		echo "[imx708-server]" && \
		cd $(SRV_DIR) && make clean && sweet_commit && git push 	; \
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

# ═══════════════════════════════════════════════════════════════════════════
# Testing
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: test
test: driver-test server-test
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════╗"
	@echo "║  All tests complete                                    ║"
	@echo "╚══════════════════════════════════════════════════════════╝"

# ═══════════════════════════════════════════════════════════════════════════
# Clean
# ═══════════════════════════════════════════════════════════════════════════

.PHONY: clean
clean:
	@echo "━━━ Cleaning all projects ━━━"
	$(MAKE) -C $(DRV_DIR) clean
	$(MAKE) -C $(SRV_DIR) clean
	$(MAKE) -C $(GUI_DIR) clean
	@echo "Done."

.PHONY: distclean
distclean:
	@echo "━━━ Deep cleaning all projects ━━━"
	$(MAKE) -C $(DRV_DIR) distclean
	$(MAKE) -C $(SRV_DIR) distclean
	$(MAKE) -C $(GUI_DIR) distclean
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
	@echo "  imx708-driver  — Linux kernel module + libimx708 C library"
	@echo "  imx708-server  — C++ gRPC daemon (depends on libimx708)"
	@echo "  imx708-gui     — PySide6 desktop GUI (depends on server)"
	@echo ""
	@echo "Build targets:"
	@echo "  all            Build driver + server + GUI stubs (default)"
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
	@echo "Other targets:"
	@echo "  test           Run tests for all projects"
	@echo "  commit [PROJECT=all|driver|server|gui]  Generate commit message with sweet_commit"
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
	@echo ""
	@echo "Dependency chain:"
	@echo "  driver-lib ──► server ──► gui-proto"
	@echo "       │                      │"
	@echo "       └── driver-test        └── gui-run"
