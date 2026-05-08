# Track: Project Structure Refactor

## Overview

The project grew organically from a LaTeX template into a multi-component
system (document class, CLI tool, Claude Code skill). The layout is functional
but reflects that history rather than deliberate structure. This track
reorganizes the repository into a clear, idiomatic layout without changing any
functional behavior.

## Functional Requirements

### FR-1: Remove broken circular symlink
Remove `imgs/imgs`, a self-referential symlink that points back to the parent
`imgs/` directory. This is a latent defect that can cause infinite loops in
tools that traverse symlinks.

### FR-2: Move CLI script to `bin/`
Move `new-activity` from the project root to `bin/new-activity`. Update the
`Makefile` install/uninstall targets to reference the new path. Update
`.claude/skills/new-activity.md` if it references the root location.

### FR-3: Move example files to `examples/`
Move `plantilla.tex` and `referencias.bib` from the project root to
`examples/`. Update the `Makefile` `all` and `clean` targets to compile from
`examples/plantilla.tex`.

### FR-4: Migrate relevant content from `docs/superpowers/` to conductor, then delete `docs/`
Extract the following design decisions (not captured elsewhere) and add them
to a new "Design Constraints" section in `conductor/product-guidelines.md`:
- Cover table width = 144mm (exact match to the original docx; 8154 twips)
- Page margins derived from original docx twip measurements
- Background image locations inside the original docx:
  - `word/media/image2.png` → `imgs/portada.png`
  - `word/media/image1.png` → `imgs/interior.png`

Delete `docs/` entirely after migration.

### FR-5: Reorganize `tests/` into subdirectories
- `tests/shell/` — all `.bats` files and `.sh` scripts
- `tests/latex/` — all `.tex` fixture files
Update `tests/run_tests.sh` and the `Makefile` `test` target to reference the
new paths. Check `.bats` files for any hardcoded paths that need updating.

### FR-6: Add comprehensive `README.md`
Create `README.md` at the project root with:
- Project overview and purpose
- Prerequisites (TeX Live / MacTeX, biber, BATS)
- Installation instructions (`make install`)
- Quick start with a full `new-activity` example command
- Project structure table (post-refactor layout)
- All CLI flags (required and optional) with descriptions and defaults
- How to run the BATS test suite
- Contributing notes

## Non-Functional Requirements

- No functional behavior changes — `.cls`, `new-activity`, and the Claude Code
  skill behavior must remain identical.
- All existing BATS tests must pass after every phase.
- `make install`, `make uninstall`, `make all`, and `make clean` must work
  correctly after the refactor.
- Git history is preserved; use `git mv` for file moves.

## Acceptance Criteria

- [ ] `imgs/imgs` no longer exists in the repository
- [ ] `bin/new-activity` exists and is executable; `make install` copies it to `~/bin/`
- [ ] `examples/plantilla.tex` and `examples/referencias.bib` exist; no `.tex`
      or `.bib` files remain at the project root
- [ ] `docs/` no longer exists
- [ ] `conductor/product-guidelines.md` contains the three design constraint
      notes from the legacy docs
- [ ] `tests/shell/` contains all `.bats` and `.sh` files; `tests/latex/`
      contains all `.tex` fixture files
- [ ] `tests/run_tests.sh` runs correctly with new paths
- [ ] `README.md` exists at root with all six required sections
- [ ] All BATS tests pass

## Out of Scope

- Changes to `ui1activity.cls` content or behavior
- Changes to `.claude/skills/new-activity.md` logic (path updates only if needed)
- Changes to `conductor/` structure beyond adding the design constraints note
- Renaming or rewriting the `new-activity` script behavior
