# specs/

Reference documentation for `ui1_template`. [`CLAUDE.md`](../CLAUDE.md) at the repo root
is the always-loaded summary — constraints, commands, and an index. These files hold the
explanation behind it, to be read when working on the subsystem they describe.

## The rule

**These documents describe the code as it is, not as it was planned.** Every factual
claim must be checkable against the source, and each subsystem document names the file
and line range it covers.

This is not a formality. The documents this directory replaces recorded page margins of
`top=7mm, bottom=20mm, footskip=7mm`; `ui1activity.cls` has used `18mm`/`22mm`/`5mm`
since the commit that introduced `geometry`. The claim was wrong from the first day and
survived 27 development cycles because nothing checked it.

So: `tests/shell/docs_consistency.bats` extracts the checkable values — margins, the
cover table width, the brand colors, the logo crop, the package inventory — from the
source and asserts these documents agree. A change that alters one of those values fails
the suite until the document is updated in the same commit.

Prose that cannot be tested is on you. Keep it about *why*; the *what* is in the code.

## Contents

| File | Covers |
|---|---|
| [`product.md`](product.md) | What the template is for and who uses it |
| [`product-guidelines.md`](product-guidelines.md) | Branding, language, audience, and the constraints inherited from the original `.docx` |
| [`tech-stack.md`](tech-stack.md) | Every package the class and theme load, and why |
| [`bibliography.md`](bibliography.md) | The `biblatex` customization: source maps, custom drivers, citation commands |
| [`cover-and-pagination.md`](cover-and-pagination.md) | Cover table, page-counter reset, background selection |
| [`beamer-theme.md`](beamer-theme.md) | Slide frame geometry, logo crop, header/footer bands |
| [`install-and-skills.md`](install-and-skills.md) | `make install`: texmf symlinks and Agent Skill distribution |

## History

This project used the [Conductor](https://github.com/fcoury/conductor) spec-driven
workflow through 27 tracks, retired in `c7186ef`. Those specs and plans record how each
feature was designed; they are historical and are not maintained. Read them with
`git show 1e5483a:conductor/archive/<track>/spec.md`, and trust the code over anything
they say.
