# Product Guidelines

## Language and Documentation
The template should follow a **Bilingual** approach (Spanish/English). All internal comments, user instructions, and variable definitions must be provided in both languages to ensure accessibility for international students and clarity for all users.

## Branding and Visual Identity
Adherence to the University Isabel I visual identity is **Strict**.
- The background images (`imgs/portada.png` and `imgs/interior.png`) are mandatory and should not be disabled or significantly modified by the user.
- The official university colors (`uired`, `uigray`) must be used for all decorative elements (tables, highlights).
- The document font (Palatino or Times New Roman) is mandatory to maintain brand consistency.

## Content and Structure
The template adopts a **Free-form** structure for the interior pages. Aside from the cover page and mandatory background underlays, the document will remain a blank canvas for the user. This gives power users complete control over their document's organization using standard LaTeX sectioning.

## Technical Expertise
This template is optimized for **Expert** users.
- Comments are minimized to avoid clutter.
- The code structure prioritizes clean implementation and ease of programmatic extension.
- Users are expected to have a solid understanding of LaTeX environments and `pdflatex` compilation workflows.

## Design Constraints

These constraints are derived from the original `ADE. Plantilla actividades 2026.docx` and must be preserved to maintain pixel-accurate fidelity with the University Isabel I branded template.

- **Cover table width:** 144mm (8154 docx twips). This exact value matches the original docx cover table and must not be changed.
- **Page margins** were derived from the original docx twip measurements: Top 7mm, Left 27.5mm, Right 25mm, Bottom 20mm, Footer skip 7mm.
- **Background image sources** from the original docx:
  - `word/media/image2.png` → `imgs/portada.png` (cover page background)
  - `word/media/image1.png` → `imgs/interior.png` (interior pages background)
