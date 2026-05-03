# Implementation Plan: Refactor to Document Class (`ui1activity.cls`)

## Phase 1: Class Initialization & Core Layout [checkpoint: 5578e64]
- [x] Task: Create new `ui1activity.cls` file and setup class definitions. (3c61a7f)
    - [x] Create `ui1activity.cls`.
    - [x] Add `\NeedsTeXFormat{LaTeX2e}` and `\ProvidesClass{ui1activity}`.
    - [x] Inherit from `article` with option passing (`\DeclareOption*...`, `\ProcessOptions\relax`, `\LoadClass{article}`).
- [x] Task: Migrate preamble packages to `ui1activity.cls`. (7614cf5)
    - [x] Extract `\usepackage` lines from `plantilla.tex`.
    - [x] Convert them to `\RequirePackage` in `ui1activity.cls`.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Class Initialization & Core Layout' (Protocol in workflow.md) (5578e64)

## Phase 2: Parametrization & Encapsulation [checkpoint: b2da002]
- [x] Task: Define internal variables for cover page data. (8dbe979)
    - [x] Define variables like `\newcommand{\subject}[1]{\def\@subject{#1}}` for subject, degree, author, date, etc.
- [x] Task: Encapsulate the custom cover page. (345b929)
    - [x] Extract the cover page TikZ/background and minipage layout from `plantilla.tex`.
    - [x] Wrap it in a `\makecustomcover` command in `ui1activity.cls` using the internal variables.
- [x] Task: Encapsulate bibliography and tables/environments. (cda354e)
    - [x] Wrap bibliography setup in `\makebibliography`.
    - [x] Define standard commands/environments for tables if necessary.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Parametrization & Encapsulation' (Protocol in workflow.md) (b2da002)

## Phase 3: Implementation & Clean Up
- [x] Task: Refactor `plantilla.tex` (or create `main.tex`) to use the new class. (7cb0145)
    - [x] Change `\documentclass{article}` to `\documentclass{ui1activity}`.
    - [x] Remove the old preamble and cover page code.
    - [x] Insert variable definitions (e.g., `\subject{...}`).
    - [x] Call `\makecustomcover` and other custom commands.
- [ ] Task: Verify PDF compilation.
    - [ ] Compile the new `.tex` file to ensure the output matches the original visually.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Implementation & Clean Up' (Protocol in workflow.md)
