# Track Specification: Implement initial extensibility features (Math, Bibliography, Code Listings)

## Overview
This track aims to extend the core Universidad Isabel I LaTeX template with academic features required for advanced assignments, specifically support for mathematical notation, bibliographies, and source code listings.

## Objectives
- Integrate `amsmath` and related packages for robust math support.
- Set up `biblatex` with a university-compliant citation style.
- Integrate `listings` or `minted` for high-quality code rendering.
- Ensure all new features adhere to the brand guidelines (colors, fonts).

## Technical Requirements
- **Math:** `amsmath`, `amssymb`, `amsfonts`.
- **Bibliography:** `biblatex` with `biber` backend.
- **Code Listings:** `listings` package with custom styles using `uired` and `uigray`.
- **Compilation:** `Makefile` must be updated to handle `biber` and multiple passes.

## Scope
- Update `plantilla.tex` with necessary package declarations and styles.
- Provide a `referencias.bib` example file.
- Update `Makefile`.
- Verification via visual inspection of generated PDF samples.
