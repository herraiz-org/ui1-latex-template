# Spec: Fix Page Numbering for First Content Page

## Overview

In `ui1activity.cls`, the first physical page contains the cover table and
table of contents. The first content page (physical page 2) is currently
assigned page number "2", both in the document footer and in TOC entries.
It should be assigned page number "1".

The fix must be fully transparent: no changes required to existing `.tex`
files.

## Root Cause

The page counter starts at 1 for the cover page. By the time the first
content section is typeset, the counter has already advanced to 2.
Additionally, the background image logic relies on `\value{page}=1` to
select `imgs/portada` on the cover page — a naive counter reset would
break this.

## Functional Requirements

1. The first content page (after the cover/TOC) must have page counter
   value 1 when LaTeX typesets its sections, so TOC entries are recorded
   as "1".
2. The page footer on the first content page must display "1".
3. The cover page (physical page 1) must continue to use the `portada`
   background image.
4. All subsequent content pages must continue to use the `interior`
   background image.
5. The fix must be automatic — existing `.tex` files that call
   `\makecustomcover` and then `\tableofcontents` separately require no
   modification.

## Non-Functional Requirements

- The solution must not introduce visible artifacts (double TOC, duplicate
  background, etc.).
- Compatibility: standard modern TeX Live distribution (LaTeX2e >= 2021).

## Acceptance Criteria

- [ ] Compiling an activity `.tex` that uses `\makecustomcover` followed
      by `\tableofcontents` produces a TOC where the first section entry
      shows page "1".
- [ ] The footer on the first content page displays "1".
- [ ] The cover page renders with `imgs/portada` as its background.
- [ ] Pages 2+ of content render with `imgs/interior` as their background.
- [ ] No changes to any existing `.tex` activity files are required.
- [ ] Existing BATS tests continue to pass.

## Out of Scope

- Changes to the cover table layout or TOC formatting.
- Support for Roman numeral page numbering on the cover/TOC page.
- Hyperref PDF bookmark numbering (separate concern).
