# Specification: Refactor to Document Class (`ui1activity.cls`)

## Overview
Transform the monolithic `plantilla.tex` file into a professional, modular LaTeX Document Class (`ui1activity.cls`) and a minimal, clean `.tex` implementation file.

## Functional Requirements
- **Class Setup:** Initialize `ui1activity.cls` using `\NeedsTeXFormat{LaTeX2e}` and `\ProvidesClass{ui1activity}`.
- **Inheritance:** Inherit from the base `article` class, passing down options using `\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}` and `\LoadClass`.
- **Package Management:** Convert all `\usepackage` calls in the preamble to `\RequirePackage` within the `.cls` file, maintaining existing package options.
- **Parametrization:** Extract hardcoded cover page/title data (e.g., Author, Date, Subject, Degree) into standard internal variable definitions (e.g., `\newcommand{\subject}[1]{\def\@subject{#1}}`).
- **Encapsulation:**
    - Wrap the complex cover page structure into a single callable command (`\makecustomcover`) that uses the internal variables.
    - Encapsulate bibliography inclusion (e.g., `\makebibliography`).
    - Encapsulate standard branded table styles or custom environments into easy-to-use commands or environments.
- **Implementation:** Provide a minimal `main.tex` (or update `plantilla.tex`) that implements the `ui1activity` class and uses the new custom commands.

## Out of Scope
- Modifying the visual design, layout, or branding rules defined in the current template.
- Adding new features not present in the original `plantilla.tex`.
