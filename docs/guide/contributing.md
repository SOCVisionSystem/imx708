---
layout: default
title: Contributing Guide
---

# 🤝 Contributing to SOCVisionSystem

First off, thank you for considering contributing! We welcome contributions
of all kinds — code, documentation, bug reports, feature requests, and
design improvements.

---

## Code of Conduct

We are committed to providing a welcoming and inclusive experience for
everyone. By participating, you agree to:

- **Be respectful** — Disagreement is fine, personal attacks are not.
- **Be constructive** — Focus on what is best for the community and project.
- **Be collaborative** — Work together to find the best solutions.
- **Be inclusive** — Use welcoming language and respect different perspectives.

---

## How to Contribute

### 1. Find Something to Work On

| Label | Description | Good for |
|-------|-------------|:--------:|
| `good first issue` | Small, well-scoped tasks | ✅ Beginners |
| `help wanted` | Larger tasks needing attention | ✅ All levels |
| `bug` | Something is broken | ✅ All levels |
| `enhancement` | New feature or improvement | ⚡ Intermediate |
| `documentation` | Docs, guides, examples | ✅ Beginners |

Browse [open issues](https://github.com/SOCVisionSystem/imx708/issues).

### 2. Set Up Your Environment

```bash
# Clone the repository
git clone https://github.com/SOCVisionSystem/imx708.git
cd imx708

# Build everything
make

# Run tests
make test
```

### 3. Make Your Changes

- Follow the coding conventions for each project (see below).
- Write or update tests.
- Update documentation if needed.
- Keep pull requests focused — one feature or fix per PR.

### 4. Submit a Pull Request

1. Fork the repository.
2. Create a feature branch: `git checkout -b feat/my-feature`.
3. Commit your changes: `git commit -m "feat: add my feature"`.
4. Push to your fork: `git push origin feat/my-feature`.
5. Open a pull request against the `main` branch.

### 5. What Happens Next

- A maintainer will review your PR within a few days.
- CI checks must pass (build + tests + lint).
- Address any review feedback.
- Once approved, your PR will be merged.

---

## Coding Conventions

### Kernel Driver (C)

- Follow [Linux kernel coding style](https://www.kernel.org/doc/html/v4.10/process/coding-style.html).
- 8-character tabs, 100-column limit.
- SPDX license header on every file: `// SPDX-License-Identifier: GPL-2.0-only`
- Every function needs a Doxygen-style comment.
- Use `devm_*` managed resources wherever possible.
- Run `checkpatch.pl --strict` before submitting.

### gRPC Server (C++17)

- RAII everywhere — no manual resource management.
- `#pragma once` in headers.
- Doxygen-style documentation (`/// @brief`, `/// @param`, `/// @return`).
- 4-space indentation, `snake_case` for functions/variables.
- Catch2 for unit tests.
- Run `make check` before submitting (tests + lint).

### GUI (Python)

- Type hints on all function signatures.
- Qt signals for cross-thread communication.
- macOS design tokens in `theme.py` — never hardcode colors.
- Widget factories in `widgets.py` — never inline stylesheets.
- Each page is a separate module in `pages/`.
- SPDX license header on every file.

---

## Pull Request Checklist

Before submitting, ensure:

- [ ] Code compiles and tests pass (`make test`)
- [ ] New tests cover the changes
- [ ] Documentation is updated
- [ ] Code follows project conventions
- [ ] Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- [ ] PR title is clear and descriptive
- [ ] No unrelated changes in the PR

---

## Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <description>

[optional body]

[optional footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

Examples:
```
feat: add HDR mode control to gRPC service
fix: correct frame buffer overflow in capture path
docs: update README with mode table corrections
test: add stress test for concurrent ioctl access
```

---

## Project-Specific Contribution Areas

### imx708-driver
- Additional SoC platform back-ends
- HDR mode validation and testing
- Power management optimization
- Additional V4L2 controls
- Device tree overlays for new boards

### imx708-server
- Authentication and authorization
- WebRTC frame streaming
- Kubernetes deployment manifests
- Prometheus metrics integration
- Additional RPC implementations

### imx708-gui
- Dark mode theme
- Frame preview rendering (QImage display)
- Keyboard shortcuts
- Settings persistence improvements
- Localization / i18n
- Touch-friendly mobile layout

---

## Getting Help

- [Open an issue](https://github.com/SOCVisionSystem/imx708/issues)
- [Discussion board](https://github.com/SOCVisionSystem/imx708/discussions)
- Join our community chat (coming soon)

---

*Thank you for helping make the IMX708 ecosystem better! 🚀*
