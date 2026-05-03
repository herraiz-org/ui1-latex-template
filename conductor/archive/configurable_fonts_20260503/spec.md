# Specification: Configurable Fonts (Palatino & Times New Roman)

## Overview
This track introduces the ability to choose between Palatino and Times New Roman as the primary body font for the `ui1activity` document class. It also configures Helvetica as the font for section headers, appropriately scaled to match the selected body font.

## Functional Requirements
- **Font Options**: The class will accept `palatino` and `times` as simple class options.
- **Default Font**: If no font option is provided, the class will default to `palatino`.
- **Palatino Configuration**:
  - Uses `newpxtext` and `newpxmath` for the body font.
  - Loads Helvetica (`helvet`) with `scaled=0.95`.
- **Times New Roman Configuration**:
  - Uses `newtxtext` and `newtxmath` for the body font.
  - Loads Helvetica (`helvet`) with `scaled=0.92`.
- **Header Formatting**:
  - Uses the `titlesec` package to format sections, subsections, and subsubsections.
  - Section headers will use the sans-serif family (`\sffamily`), boldface (`\bfseries`), and be colored in standard black.

## Non-Functional Requirements
- **Backward Compatibility**: Existing documents not specifying a font will now compile using Palatino.
- **Code Modularity**: Font configuration logic should be cleanly organized within `ui1activity.cls`.

## Acceptance Criteria
- [ ] Compiling a document with `\documentclass[palatino]{ui1activity}` uses Palatino for body and 95% scaled Helvetica for headers.
- [ ] Compiling a document with `\documentclass[times]{ui1activity}` uses Times New Roman for body and 92% scaled Helvetica for headers.
- [ ] Compiling a document without any font option defaults to Palatino.
- [ ] Section headers (`\section`, `\subsection`, `\subsubsection`) are formatted in black sans-serif bold.

## Out of Scope
- Adding support for fonts other than Palatino and Times New Roman.
- Modifying fonts for elements other than body text and section headers.