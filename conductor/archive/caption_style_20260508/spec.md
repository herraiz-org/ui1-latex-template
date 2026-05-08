# Spec: Styled Captions for Float Environments

## Overview

Update `ui1activity.cls` to apply a consistent, visually distinct caption style to
all caption-bearing float environments (figures, tables, code listings, and any future
environments using the `caption` package). The new style makes captions smaller, italic,
with a bold label, and slightly narrower than the body text to help readers visually
identify them at a glance.

## Functional Requirements

1. **Font size:** Caption text must be set at exactly 1 pt smaller than the current body
   font size (i.e., `\small` or `\fontsize{\dimexpr\f@size pt - 1pt}{...}` relative to
   `\normalsize`). This applies to the entire caption (label + text).

2. **Italic text:** The full caption — both the label (e.g., "Figura 1.") and the
   descriptive text — must be rendered in italics (`\itshape`).

3. **Bold label:** The label portion (e.g., "Figura 1.") must additionally be rendered
   in bold (`\bfseries`), so it appears bold-italic while the rest of the caption is
   italic only.

4. **Separator:** The separator between the label and caption text remains the default
   provided by the `caption` package (a period followed by a space).

5. **Horizontal indentation:** Each caption must be indented by 1 cm on both the left
   and right sides relative to the full text width, making it visually narrower than
   body paragraphs.

6. **Scope:** The style must apply to all environments managed by the `caption` package —
   `figure`, `table`, `lstlisting`, and any other float environment that uses `\caption`
   — without requiring per-environment configuration.

7. **List of Figures / List of Tables:** Entries in `\listoffigures` and `\listoftables`
   are NOT affected; they retain their default size and style.

## Non-Functional Requirements

- The implementation must use the `caption` package API (`\captionsetup`) already present
  in `ui1activity.cls`, so no new packages are introduced.
- The style must be compatible with both the Palatino (default) and Times New Roman font
  options supported by the class.
- The change must not break any existing BATS tests or compiled LaTeX fixtures.

## Acceptance Criteria

- [ ] A compiled PDF shows figure captions in bold-italic label + italic text, 1 pt
      smaller than body, indented 1 cm per side.
- [ ] Same styling applies to table and lstlisting captions.
- [ ] List of Figures / List of Tables entries are visually unchanged.
- [ ] The Times New Roman font option produces the same visual pattern (bold-italic
      label, italic text).
- [ ] All existing BATS shell tests pass without modification.
- [ ] The LaTeX fixture compiles without errors or warnings related to captions.

## Out of Scope

- Changes to caption placement (above/below float).
- Changes to caption alignment (currently centred or left-aligned per `caption` default).
- Styling of `\captionof` calls outside float environments.
- Any changes to the List of Figures or List of Tables formatting.
