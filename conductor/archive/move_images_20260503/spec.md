# Track Specification: Move Images to Directory

## Overview
This track focuses on improving the project's organization by moving top-level image assets into a dedicated `imgs/` directory and updating all relevant references in the LaTeX source.

## Scope
- Create a new `imgs/` directory at the project root.
- Move existing image files (`portada.png`, `interior.png`, etc.) from the project root to the `imgs/` directory.
- Update explicit relative paths in the LaTeX source file (`plantilla.tex`) to point to the new image locations (e.g., `imgs/portada.png`).

## Acceptance Criteria
- All image files previously in the root directory are located in the `imgs/` directory.
- The `plantilla.tex` file compiles successfully without any missing image errors.
- The compiled PDF output is visually identical to the original version.
- The project root directory is cleaner, containing only essential configuration and source files.

## Out of Scope
- Modifying the visual design or content of the template.
- Adding new image assets not currently in the project.