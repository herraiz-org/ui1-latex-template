# Installation and Agent Skills

**Source of truth:** `Makefile`, lines 22–34 (configuration) and 64–127
(`install` / `uninstall`).
**Tests:** `tests/shell/install.bats`, `tests/shell/test_install_gemini_skill.bats`,
`tests/shell/test_install.sh`.

`make install` does three separate jobs: it publishes the LaTeX sources to the user's
texmf tree, copies the CLIs onto `PATH`, and distributes the Agent Skills to every
coding-agent discovery path.

## LaTeX sources

Symlinks — not copies — into `$(TEXMF_DIR)`, default `~/texmf/tex/latex/ui1_template`:

- `ui1activity.cls`
- `beamerthemeui1beamer.sty`
- `imgs/` (the whole directory)

Symlinking means edits in the working tree take effect immediately, with no reinstall
step. The `imgs` link is what lets a generated activity anywhere on disk resolve
`\includegraphics{imgs/portada}` — see [`cover-and-pagination.md`](cover-and-pagination.md).
It is removed with `rm -f` before being recreated, because `ln -s` into an existing
directory symlink would nest a link inside the target rather than replace it.

## CLI scripts

`bin/new-activity` and `bin/new-slides` are copied (not linked) to `$(INSTALL_BIN)`,
default `~/bin`, and made executable. The target then appends
`export PATH="$HOME/bin:$PATH"` to `$(ZSHRC)` only if that exact line is absent, so
repeated installs do not accumulate duplicates.

## Agent Skills

One source of truth per CLI — `skills/new-activity/SKILL.md` and
`skills/new-slides/SKILL.md` — is copied to a **canonical** directory, and every other
agent's discovery path gets a **symlink** to it. Updating a skill therefore means
updating one file.

| Variable | Default | Role |
|---|---|---|
| `INSTALL_AGENT_SKILLS` | `~/.agents/skills` | Canonical location; holds the real file |
| `SKILL_COMPAT_DIRS` | see below | Space-separated list of directories that get symlinks |
| `INSTALL_SKILLS` | `~/.claude/skills` | Legacy override, still honored via the list |
| `INSTALL_GEMINI_SKILLS` | `~/.gemini/skills` | Legacy override, still honored via the list |

The default compatibility list covers `~/.claude/skills`, `~/.gemini/skills`,
`~/.gemini/config/skills` and `~/.gemini/antigravity-cli/skills`. A destination equal to
the canonical directory is skipped, so the real file is never replaced by a link to
itself.

### Refusing to clobber

Before creating a link, the target is classified, and anything unrecognised aborts the
install with a non-zero exit:

- **A symlink to the canonical directory** — ours; removed and recreated.
- **A symlink elsewhere** — someone else's; **error**.
- **A directory holding exactly one entry, `SKILL.md`** — a legacy copied install from
  before the canonical-directory scheme; migrated by deleting it and linking.
- **A directory with anything else in it** — a hand-maintained skill; **error**.
- **Any other existing file** — **error**.

The principle: `make install` may replace what it created, and may migrate the shape it
used to create, but never destroys a skill a human wrote. Test coverage for the migration
path is in `test_install_gemini_skill.bats`.

## Uninstall

`make uninstall` reverses all three jobs, with the same caution: it removes a
compatibility target only when it is a symlink pointing at *our* canonical directory, or
a directory whose sole entry is `SKILL.md`. Then it deletes the canonical `SKILL.md` and
removes the directory if `rmdir` succeeds — a non-empty directory is left alone.

It does not touch the `~/.zshrc` PATH line. Removing a line from a user's shell config is
more dangerous than leaving a harmless one behind.

## Overriding paths

Every destination is a `?=` variable, so tests and packagers can redirect the whole
install into a temporary tree:

```bash
make install TEXMF_DIR=/tmp/t/texmf INSTALL_BIN=/tmp/t/bin \
             INSTALL_AGENT_SKILLS=/tmp/t/skills SKILL_COMPAT_DIRS=/tmp/t/compat \
             ZSHRC=/tmp/t/zshrc
```

That is exactly how `install.bats` exercises it without touching the real home
directory — follow the same pattern when adding install tests.
