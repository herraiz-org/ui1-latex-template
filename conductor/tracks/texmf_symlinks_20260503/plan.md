# Implementation Plan: Global texmf Symlinks

## Phase 1: Automation Setup
- [ ] Task: Create tests for `Makefile` install targets
    - [ ] Create a shell script test (e.g., `tests/test_install.sh`) to execute `make install` into a mocked `TEXMFHOME` and verify the symlinks are correctly created.
    - [ ] Extend the test to run `make uninstall` and verify the symlinks are properly removed.
- [ ] Task: Implement `Makefile` installation targets
    - [ ] Define a `TEXMF_DIR` variable (defaulting to `~/texmf/tex/latex/ui1_template`).
    - [ ] Implement an `install` target to create the directory and generate the absolute symlinks for `ui1activity.cls` and the `imgs` directory.
    - [ ] Implement an `uninstall` target to remove the created symlinks.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Automation Setup' (Protocol in workflow.md)