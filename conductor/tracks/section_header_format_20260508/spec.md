# Specification: Adjust Section Header Formatting

## Overview
This track addresses formatting issues related to section headers in the `ui1activity.cls` LaTeX document class. Specifically, the font size for section headers is perceived as too small, and the spacing between the section header and the following paragraph is too large.

## Functional Requirements
1. **Increase Section Header Size:** The font size for top-level `\section` headers must be slightly increased compared to its current size.
2. **Reduce Section Header Spacing:** The vertical space immediately following a `\section` header (before the first paragraph) must be slightly reduced.
3. **Scope:** These adjustments apply *only* to top-level sections (`\section`). Subsections (`\subsection`) and subsubsections (`\subsubsection`) remain unchanged.

## Non-Functional Requirements
- The changes must be implemented within the `titlesec` configuration of `ui1activity.cls`.
- The modifications must maintain the existing Helvetica sans-serif font family and visual branding.

## Acceptance Criteria
- [ ] Compiling a document with `\section` demonstrates a noticeably (but slightly) larger font size for the header.
- [ ] Compiling a document with `\section` demonstrates a noticeably (but slightly) reduced vertical space between the header and the text that follows.
- [ ] The visual hierarchy between `\section`, `\subsection`, and `\subsubsection` remains logical.
- [ ] Existing automated tests related to formatting pass, or are updated to reflect the new sizing/spacing.

## Out of Scope
- Changes to the font family (Helvetica).
- Changes to the formatting of subsections or subsubsections.
- Changes to body text font sizes or paragraph spacing outside of the immediate post-section area.