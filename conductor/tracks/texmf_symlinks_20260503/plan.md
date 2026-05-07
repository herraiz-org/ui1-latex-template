# Implementation Plan: Global texmf Symlinks

## Phase 1: Automation Setup [checkpoint: 698ebcb]
- [x] Task: Create tests for `Makefile` install targets [30bf85f]
    - [x] Create a shell script test (e.g., `tests/test_install.sh`) to execute `make install` into a mocked `TEXMFHOME` and verify the symlinks are correctly created.
    - [x] Extend the test to run `make uninstall` and verify the symlinks are properly removed.
- [x] Task: Implement `Makefile` installation targets [8838be8]
    - [x] Define a `TEXMF_DIR` variable (defaulting to `~/texmf/tex/latex/ui1_template`).
    - [x] Implement an `install` target to create the directory and generate the absolute symlinks for `ui1activity.cls` and the `imgs` directory.
    - [x] Implement an `uninstall` target to remove the created symlinks.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Automation Setup' (Protocol in workflow.md) [698ebcb]