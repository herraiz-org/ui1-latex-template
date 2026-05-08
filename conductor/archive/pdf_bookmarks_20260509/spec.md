# Spec: PDF Bookmarks and Metadata via hyperref

## Overview
Integrate the `hyperref` package into `ui1activity.cls` to embed the
document's table of contents as navigable PDF bookmarks in the viewer's
sidebar, and to populate the PDF's document properties (Title, Author,
Subject) automatically from the activity's existing metadata commands.

## Functional Requirements

1. **Package Integration:** Load `hyperref` in `ui1activity.cls`,
   positioned after all other packages to avoid conflicts.
2. **Invisible Links:** Configure `hyperref` with `hidelinks` so no
   colored boxes or underlines appear on links or cross-references in
   the document body.
3. **Bookmark Depth:** All three levels of sectioning (`\section`,
   `\subsection`, `\subsubsection`) must appear as bookmarks in the
   PDF outline/sidebar.
4. **PDF Metadata Auto-Population:** At `\begin{document}`,
   automatically set:
   - PDF `Title` from `\activitytitle`
   - PDF `Author` from `\alumno`
   - PDF `Subject` from `\asignatura`
5. **Compatibility:** The integration must not break existing visual
   formatting, bibliography rendering, caption styling, or any other
   existing feature of the class.

## Non-Functional Requirements

- **Compiler:** Must work with `pdflatex` (the project's primary
  compiler).
- **No Visual Regressions:** The printed/rendered appearance of the
  document must remain identical to the pre-hyperref version.
- **Package Load Order:** `hyperref` must be loaded in a position that
  avoids conflicts with `caption`, `titlesec`, `biblatex`, `listings`,
  and other loaded packages.

## Acceptance Criteria

- [ ] A compiled PDF from a test activity includes an outline/bookmarks
      panel in a PDF viewer (e.g., Evince, Okular, Zathura) showing all
      sections, subsections, and subsubsections.
- [ ] The PDF Document Properties dialog shows the correct Title,
      Author, and Subject populated from the activity's metadata.
- [ ] No colored links, boxes, or underlines appear in the document
      body.
- [ ] All existing BATS tests continue to pass.
- [ ] A new BATS test verifies that `pdfinfo` reports the correct Title,
      Author, and Subject for a compiled test activity.
- [ ] A new BATS test verifies that the compiled PDF contains
      bookmark/outline data.

## Out of Scope

- Clickable cross-references within the document body (they exist but
  are invisible; no requirement to expose them).
- Support for `\paragraph` or `\subparagraph` bookmark levels.
- `hyperref` options for external URL handling or email links.
- Any changes to the `new-activity` CLI or its generated `.tex`
  template.
