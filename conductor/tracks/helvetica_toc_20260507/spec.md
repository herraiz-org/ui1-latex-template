# Track: Apply Helvetica to Table of Contents Entries

## Overview
Update `ui1activity.cls` to apply Helvetica (`\sffamily`) to all three levels of
table of contents entries (section, subsection, subsubsection), using the `titletoc`
package (companion to the already-loaded `titlesec`). Font weight follows a
hierarchical scheme: bold Helvetica for section entries, regular Helvetica for
subsection and subsubsection entries.

## Functional Requirements
- Load the `titletoc` package in `ui1activity.cls`.
- Section-level TOC entries use `\sffamily\bfseries`.
- Subsection-level TOC entries use `\sffamily` (no bold).
- Subsubsection-level TOC entries use `\sffamily` (no bold).
- All other TOC formatting (indentation, dot leaders, page numbers) remains unchanged.

## Non-Functional Requirements
- No existing `.tex` documents using this class should break.
- The `titletoc` package must not conflict with `titlesec` (they are designed to
  work together).

## Acceptance Criteria
- A document with `\tableofcontents` renders section entries in bold Helvetica.
- Subsection and subsubsection entries render in regular Helvetica.
- The rest of the TOC layout (spacing, leaders, page numbers) is visually unchanged.
- All existing tests continue to compile successfully.

## Out of Scope
- Styling page numbers in the TOC with Helvetica.
- Changing TOC indentation, spacing, or dot leader style.
- Applying Helvetica to the "Contents" heading itself.
