# Spec: GitHub Actions CI Workflow

## Overview

Add a GitHub Actions workflow that automatically runs the full test suite on
every push and every pull request. The workflow runs inside the
`ghcr.io/xu-cheng/texlive-full:latest` Docker container, which ships a
complete TeX Live installation, eliminating any LaTeX dependency setup step.

## Functional Requirements

1. **Triggers**
   - Run on every `push` to any branch.
   - Run on every `pull_request` targeting any branch.

2. **Runner**
   - Use `ubuntu-latest` as the host runner.
   - Execute all steps inside the `ghcr.io/xu-cheng/texlive-full:latest`
     container.

3. **Test Jobs**
   The workflow must contain the following jobs (or steps within one job):

   ### 3.1 Shell Script Linting (`shellcheck`)
   - Run `shellcheck` on all Bash scripts under `bin/`.
   - The step must fail if `shellcheck` reports any issue.

   ### 3.2 BATS Shell Tests
   - Initialise git submodules (BATS lives at `tests/bats`).
   - Execute `bash tests/run_tests.sh tests/shell/*.bats`.
   - The step must fail if any BATS test fails.

   ### 3.3 LaTeX Compilation Tests
   - Execute `make test`, which compiles every `.tex` file under
     `tests/latex/` using `pdflatex` (and `biber` when a bibliography is
     referenced).
   - The step must fail if any compilation exits with a non-zero status.

4. **No Caching**
   - No caching is required. The Docker image already provides the full TeX
     Live environment and `shellcheck`; BATS is a git submodule.

## Non-Functional Requirements

- The workflow file must live at `.github/workflows/ci.yml`.
- Job/step names must be human-readable (visible in the GitHub Actions UI).
- The workflow must not require any repository secrets.

## Acceptance Criteria

- [ ] Pushing a commit triggers the workflow automatically.
- [ ] Opening or updating a pull request triggers the workflow automatically.
- [ ] A `shellcheck` violation in `bin/new-activity` causes the workflow to
      fail.
- [ ] A failing BATS test causes the workflow to fail.
- [ ] A LaTeX compilation error (non-zero `make test` exit) causes the
      workflow to fail.
- [ ] All three check types pass on the current `main` branch (green build).

## Out of Scope

- Deployment or release automation.
- Caching of TeX Live packages or build artefacts.
- Code coverage reporting.
- Notifications (Slack, email, etc.).
- Matrix builds across multiple OS or TeX Live versions.
