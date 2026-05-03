# Track: Use Helvetica in Cover Table

## Overview
Update the custom cover table in `ui1activity.cls` to use the Helvetica font (`\sffamily`) for specific elements, with appropriate sizing and scaling to ensure it looks visually balanced with the rest of the document.

## Functional Requirements
- Apply the Helvetica sans-serif font (`\sffamily`) to the text in the top red header cell (Grado and Curso académico).
- Apply the Helvetica sans-serif font to the field labels in the lower gray cells (e.g., "Asignatura:", "Unidad didáctica:", "Alumno:", "Fecha:").
- Retain the document's default serif font for the actual values corresponding to these labels (e.g., the student's name, the course name).
- Adjust the font sizing of these elements to ensure they scale proportionally and visually harmoniously with the rest of the document's typography.

## Non-Functional Requirements
- Ensure changes do not break existing `.tex` document compilations using this class.
- The Helvetica font is already loaded in the class file, so we just need to apply `\sffamily` where appropriate.

## Acceptance Criteria
- The top header cell displays in Helvetica.
- The field labels in the gray cells display in bold Helvetica.
- The values in the gray cells display in the default serif font.
- The font sizes are visually balanced.
- Tests pass successfully.