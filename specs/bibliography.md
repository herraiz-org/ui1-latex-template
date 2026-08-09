# Bibliography

**Source of truth:** `ui1activity.cls`, lines 63–149 (setup, source maps, drivers, cite
command) and 246–256 (`\makebibliography`).
**Tests:** `tests/shell/{legislation,legislation_cite,jurisprudencia,normal_citation,bib_spacing}.bats`.

The class extends `biblatex`'s APA style with two entry types for Spanish legal sources.
This is the most intricate part of the project, and most of it exists to work around
constraints in biber and `biblatex` rather than to express a design preference.

## The problem being solved

Spanish academic writing cites two kinds of source that standard `biblatex` cannot
represent:

- **Jurisprudencia** — court rulings, cited in text as `(STS 751/1984)` and listed in
  full with the court, chamber, date and ECLI identifier.
- **Legislation** — statutes published in the BOE, cited by a *shortened* title and
  listed with the BOE issue number and section.

Both need their own rendering, their own list, and their own inline citation format.

## Why source maps, not new fields

The natural implementation is a custom entry type with custom fields (`court`, `ecli`,
`chamber`…). That does not work: **biber discards any field outside its data model**, so
by the time the driver runs, the fields are gone.

`\DeclareSourcemap` is the way through, because source maps run *before* the data-model
check. The class therefore remaps each custom field onto one of biblatex's generic
`user*` fields (`ui1activity.cls:88–98`):

| `.bib` field | Mapped to | Meaning |
|---|---|---|
| `kind` | `usera` | Ruling type — `Sentencia`, `Auto`, `Providencia` |
| `court` | `userb` | Court name, **including the Spanish preposition** |
| `shortcourt` | `userc` | Abbreviation used inline — `STS`, `ATS` |
| `chamber` | `userd` | Chamber and section |
| `fdate` | `usere` | Date of the ruling, as free text |
| `ecli` | `userf` | ECLI identifier, **without** the `ECLI:` prefix |

The consequence for anyone editing the driver: the field names in
`\DeclareBibliographyDriver{jurisprudencia}` are `usera`…`userf`, not the names an author
writes in the `.bib`. The table above is the decoder ring.

Two conventions are load-bearing and easy to get wrong:

- **`court` carries its own preposition** — `del Tribunal Supremo`, `de la Audiencia
  Nacional`. The driver emits `<kind> <court> <number>`, so a bare `Tribunal Supremo`
  renders as "Sentencia Tribunal Supremo 751/1984", which is not Spanish. Putting the
  preposition in the field handles grammatical gender without a second field.
- **`ecli` omits the `ECLI:` prefix** — the driver prepends it.

## Deriving `shorttitle` for legislation

Legislation titles are long: *"Ley 16/1987, de 30 de julio, de Ordenación de los
Transportes Terrestres"*. In the reference list that is correct; in an inline citation it
is unreadable. The wanted inline form is *"Ley de Ordenación de los Transportes
Terrestres"* — normative type, then descriptive part, with the number and date removed.

The pattern is too variable for TeX-level string surgery, so a second source map
(`ui1activity.cls:99–106`) copies `title` into `shorttitle` and rewrites it with a Perl
regex:

```
^(.*?)\s+\d+/\d\d\d\d,?\s*(?:de\s\d\d?\sde\s(?:enero|…|diciembre)(?:,\s*de\s\d\d\d\d)?,?\s*)?((?:de\s|sobre\s|por\s|relativo\s|que\s|del\s|en\s|a\s).*)$
```

Group 1 is the normative type (`Ley`, `Ley Orgánica`, `Real Decreto`, `Real Decreto-ley`),
group 2 is the descriptive tail, recognised by the preposition or conjunction that starts
it. The number and the date expression between them are dropped.

**It fails soft.** A title that matches no pattern is left alone and cites in full, which
is why authors never need to write `shorttitle` by hand. Adding a new normative form
means extending the alternation of leading words in group 2.

## Custom drivers

Two `\DeclareBibliographyDriver` definitions render the list entries.

`legislation` (`ui1activity.cls:76–83`) produces:

```
<title>. BOE número <number> § <eid> (<year>)
```

`jurisprudencia` (`ui1activity.cls:119–129`) produces:

```
<kind> <court> <number> (<chamber>), de <fdate>. ECLI:<ecli> <url>
```

The `url` is optional — `\iffieldundef` suppresses the trailing period and link when it
is absent. Every field is declared with a pass-through `\DeclareFieldFormat` so APA's
default formatting does not interfere.

## Inline citations

`\cite` is aliased to `\parencite` (`ui1activity.cls:71`) so all citations are
parenthetical, and `\parencite` is redefined (`131–142`) to special-case rulings:

```latex
\ifentrytype{jurisprudencia}
  {\printfield{userc}\addnbspace\printfield{number}}   % (STS 751/1984)
  {\usebibmacro{cite}\usebibmacro{cite:post}}          % APA, unchanged
```

The `\toggletrue{apa:inpcite}` / `\togglefalse{apa:inpcite}` pair around the body is not
optional. APA's style uses that toggle to decide whether to print the author; a
redefinition that omits it silently drops authors from *ordinary* citations, which is
exactly the regression that
`git show 1e5483a:conductor/archive/parencite_fix_20260517/spec.md` records — output like
`(2021, pp. 102-103)`. `tests/shell/normal_citation.bats` guards it.

## Conditional sections

`\makebibliography` (`ui1activity.cls:248–256`) prints, in order:

1. **Jurisprudencia** — Spanish heading only; the feature is Spanish-only by design.
2. **Legislación / Legislation** — heading picked by `\iflanguage` through
   `\ui@legistitle`, which is why `babel` loads English alongside Spanish.
3. **References** — everything else, via the `notlegislationorjuris` filter.

Sections one and two appear only when entries of that type were cited. That is tracked
by two booleans set from `\AtDataInput` hooks (`ui1activity.cls:146–149`), which fire per
entry as biber's data is read:

```latex
\AtDataInput[jurisprudencia]{\global\booltrue{ui@hasjuris}}
```

Without them, `\printbibliography[type=…]` emits a warning for every empty section. The
`\global` matters — the hook runs inside a group.

Documents call `\makebibliography`, never `\printbibliography` directly.

## Adding a third legal entry type

1. Map its custom fields onto free `user*` fields in a new `\map` block. Check which
   `user*` fields are still unclaimed — `jurisprudencia` uses `usera` through `userf`.
2. Add pass-through `\DeclareFieldFormat`s for each.
3. Write the driver.
4. Add a `\newbool` plus an `\AtDataInput` hook, and print the section conditionally in
   `\makebibliography`.
5. Extend the `notlegislationorjuris` filter, or the new entries will also appear in the
   general references list.
6. Seed a commented example in `bin/new-activity`'s `referencias.bib`, and document the
   fields in the README table.
