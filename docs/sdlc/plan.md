# Plan

[← Back to README](../../README.md) · Previous: [intent.md](intent.md) · [spec.md](spec.md)

Implementation plan for the repository reorganization specified in
[spec.md — Part B](spec.md#part-b--repository-reorganization).
All tasks are complete; the plan is kept as a record of what was done and how
it was verified.

## Guardrails

- Never edit, reformat, re-encode or rename any `.m` file.
- Moves only with `git mv` so history follows the files.
- When evidence is missing, write "Unknown" instead of guessing.
- Do not add tooling or folders that the content does not justify.

## Phase 1 — Discovery

| Task | Output | Status |
|---|---|---|
| Inventory every file (code, docs, data, media) | 6 `.m` scripts + `LICENSE`; no documents, images or data | ✅ |
| Read every script, header and comment | Method, system, loop and output per script | ✅ |
| Inspect encodings and line endings | CRLF everywhere; ISO-8859-1 in non-linear scripts | ✅ |
| Read git history | Author, upload date (2021-02-20), web-UI upload | ✅ |
| Identify runtime dialects | Octave syntax (linear) vs. MATLAB-style + symbolic (non-linear) | ✅ |
| Re-compute each algorithm independently (outside the repo) to describe its behavior | Numerical observations tagged *Inferred (re-computed)* | ✅ |
| Record SHA-256 of every source file before changes | Baseline hashes | ✅ |

## Phase 2 — Restructure

| Task | Output | Status |
|---|---|---|
| `git mv Lineales src/linear` | history-preserving rename | ✅ |
| `git mv "No lineales" src/nonlinear` | removes the space from the path | ✅ |
| Add `.gitattributes` (`src/**/*.m -text`) | protects CRLF/encoding from normalization | ✅ |
| Add minimal `.gitignore` | MATLAB/Octave + editor artifacts | ✅ |

Not created on purpose: `data/`, `assets/`, `examples/`, `archive/`,
`docs/original/`, `docs/architecture.md`, `docs/assignment.md` — there is no
content or evidence to justify them.

## Phase 3 — Documentation

| Task | Output | Status |
|---|---|---|
| Context with Confirmed / Inferred / Unknown | [project-context.md](../project-context.md) | ✅ |
| Math background per method | [numerical-methods.md](../numerical-methods.md) | ✅ |
| File-by-file walkthrough | [code-overview.md](../code-overview.md) | ✅ |
| Issues and ideas, explicitly not applied | [possible-improvements.md](../possible-improvements.md) | ✅ |
| Intent / spec / plan records | this folder | ✅ |
| Rules for automated contributors | [AGENTS.md](../../AGENTS.md) | ✅ |
| Main entry point | [README.md](../../README.md) | ✅ |

## Phase 4 — Verification

| Check | Command | Expected | Result |
|---|---|---|---|
| Source integrity | `sha256sum -c docs/sdlc/source-integrity.sha256` | 6 × `OK` | ✅ |
| Pure renames | `git diff --cached -M --summary` | 6 × `rename … (100%)` | ✅ |
| Links resolve | scan of relative links in `*.md` | no missing targets | ✅ |

Baseline hashes (identical before and after the move):

```
dde4c26e4916ae3f50a483802facf980c960da1f54b3cb20e4019566bacf191b  GaussJordan.m
c3b284221a3d25294e25bc9e97f6c4dc81fdb684af5058f8fe1afe952375c03f  GaussSeidel.m
097df72cb0712bb82e1359429b99a765ac6497b682451c7f5d53b8e020ba9203  Jacobi.m
bb75a92820959e3ac3c27f8be22d297510bdaec038b7cdb762c769272b70d282  GaussNewton.m
16e988277c8bec6f442e64d945a449a17d512519d127489767813bff201b44e4  NewtonRaphsonBi.m
2ce82458a5ae5e2aab595128242480287e66aac1b090e440cfcfae146cbb5edd  PuntoFijoMultivariable.m
```

## Phase 5 — Delivery

| Task | Status |
|---|---|
| Single commit on a feature branch, descriptive message | ✅ |
| Pull request describing the reorganization and the preservation guarantee | ✅ |

## Future work (out of scope)

Anything in [possible-improvements.md](../possible-improvements.md). If a
modernized version is ever built, it should live in a separate folder or
repository, with its own intent/spec/plan, leaving `src/` untouched.
