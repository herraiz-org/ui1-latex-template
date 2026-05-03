# Implementation Plan: Move Images to Directory

## Phase 1: File Reorganization
- [x] Task: Create `imgs/` directory at the root of the project. 80379d3
- [x] Task: Move `portada.png` and `interior.png` into the `imgs/` directory. 57de1bb
- [x] Task: Update image reference paths in `plantilla.tex` to point to `imgs/portada.png` and `imgs/interior.png`. aa49d05
- [ ] Task: Run compilation (`pdflatex plantilla.tex` or `make`) to verify successful build.
- [ ] Task: Conductor - User Manual Verification 'File Reorganization' (Protocol in workflow.md)