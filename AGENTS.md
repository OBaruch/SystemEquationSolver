# AGENTS.md

Guidance for any automated or AI-assisted contributor working in this
repository. Human contributors should follow the same rules.

## What this repository is

A **historical** repository: six original MATLAB/GNU Octave scripts (2021)
implementing numerical methods for systems of equations, plus documentation
added later. Start with [README.md](README.md) and
[docs/sdlc/intent.md](docs/sdlc/intent.md).

## Non-negotiable rules

1. **Do not modify anything under `src/`.** No edits, formatting, re-encoding,
   line-ending changes, renames or "fixes" — even for obvious bugs.
2. Before finishing any change, run:

   ```bash
   sha256sum -c docs/sdlc/source-integrity.sha256
   ```

   Every line must report `OK`.
3. Known defects are documented in
   [docs/possible-improvements.md](docs/possible-improvements.md). Add new
   findings there; do not apply them.
4. Tag claims as **Confirmed**, **Inferred** or **Unknown**. Never present an
   inference as fact, and never invent origin, versions, commands or
   dependencies.
5. Do not add infrastructure (CI, containers, build files, test frameworks,
   package managers) unless explicitly requested.

## Workflow

Follow intent → spec → plan: update [intent.md](docs/sdlc/intent.md),
[spec.md](docs/sdlc/spec.md) and [plan.md](docs/sdlc/plan.md) before or
together with any structural change, and keep links relative.

## Conventions

- Documentation language: English. Original code comments stay in Spanish.
- Source files use CRLF and ISO-8859-1; `.gitattributes` keeps git from
  normalizing them.
