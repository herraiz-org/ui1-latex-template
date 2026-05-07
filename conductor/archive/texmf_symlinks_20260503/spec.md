# Specification: Setup Global texmf Symlinks

## Overview
This track aims to make the `ui1activity.cls` LaTeX class and its required assets globally discoverable by any local LaTeX document. This will be achieved by creating symbolic links in the user's local TeX Directory Structure (`~/texmf/tex/latex/ui1_template/`) pointing back to the repository.

## Functional Requirements
1. **Makefile Automation:** Extend the existing `Makefile` with `install` and `uninstall` targets.
2. **File-Specific Symlinks:** The `install` target must create individual symbolic links for:
   - `ui1activity.cls`
   - `imgs/` (the entire directory containing background images)
3. **No File Relocation:** Files must remain in their current repository locations; only symlinks will be created in the `texmf` tree.
4. **Absolute Paths:** The `Makefile` must resolve absolute paths for the symlinks to ensure they work correctly.
5. **Standard TeX Directory:** The symlinks should be placed in the standard user LaTeX directory, typically `~/texmf/tex/latex/ui1_template/`.

## Non-Functional Requirements
- Idempotency: The `install` target should not fail if the links already exist (e.g., using `ln -sf` and `mkdir -p`).

## Out of Scope
- Modifying the contents of the `.cls` file or any templates.
- Moving any actual files from the current project directory.