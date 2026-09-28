# Project Context

[← Back to README](../README.md)

This document reconstructs the context of the project from the evidence
available in the repository. Every statement is tagged:

- **Confirmed** — directly supported by files, code or git history.
- **Inferred** — reasonably deduced, but not proven.
- **Unknown** — the repository does not provide enough information.

## Classification

**Project origin: Unknown** (most likely *Coursework / Academic Project* —
inferred, not confirmed).

## Evidence inventory

The original upload contained only:

| Item | Kind | Notes |
|---|---|---|
| `Lineales/GaussJordan.m` | source code | GNU Octave syntax |
| `Lineales/GaussSeidel.m` | source code | GNU Octave syntax |
| `Lineales/Jacobi.m` | source code | GNU Octave syntax |
| `No lineales/GaussNewton.m` | source code | MATLAB-style syntax, symbolic math |
| `No lineales/NewtonRaphsonBi.m` | source code | MATLAB-style syntax, symbolic math |
| `No lineales/PuntoFijoMultivariable.m` | source code | MATLAB-style syntax, symbolic math |
| `LICENSE` | license | MIT, "Copyright (c) 2021 Baruch Lopez" |

There were **no** PDFs, Word/PowerPoint documents, images, diagrams, data
files, notebooks, generated outputs, configuration files or README. All
context therefore comes from the code, its comments, the file names and the
git history.

## Findings

| Topic | Finding | Status |
|---|---|---|
| Author | Baruch Lopez (LICENSE and commit author) | Confirmed |
| Date | Uploaded on 2021-02-20 in two commits ("Initial commit", "Add files via upload") via the GitHub web UI | Confirmed |
| Language of comments | Spanish | Confirmed |
| Language / runtime | Linear scripts: GNU Octave (`!=`, `endfor`, `endif`, `#`). Non-linear scripts: MATLAB-compatible syntax with symbolic math | Confirmed (syntax) |
| Non-linear scripts written in MATLAB | ISO-8859-1 encoding and `%`/`end` style point to the MATLAB editor, but Octave can run the same syntax | Inferred |
| Two different environments | The two folders use visibly different styles, suggesting they were written at different times or in different tools | Inferred |
| Subject area | Numerical methods for systems of linear and non-linear equations | Confirmed |
| Academic course | Method selection and textbook-like examples resemble a *Numerical Methods* course | Inferred |
| University, course name, assignment, grade | Not mentioned anywhere | Unknown |
| Whether files were deliverables | No assignment statement or report exists | Unknown |
| Where the example systems come from | Not referenced | Unknown |

## Purpose (as far as it can be determined)

The scripts implement, one per file, the standard numerical methods for
systems of equations and print every intermediate step. The comments in the
non-linear scripts explain *when* each method applies:

- **Newton-Raphson (bivariate)** — non-linear system with *the same number of
  equations as unknowns* (square Jacobian); equations must be written in
  implicit form `f(x, y) = 0`.
- **Gauss-Newton** — non-linear system with *more equations than unknowns*
  (non-square Jacobian); equations must be written in implicit form.
- **Fixed point (bivariate)** — no explanatory comment; uses the same system
  as Newton-Raphson rewritten as `x = g(x)`.

This reads like a personal study reference that compares the methods side by
side (Inferred).

## Relationship between the scripts

- The three **linear** scripts share the same structure (define `A`, `B`,
  `tol`; check `det(A)`; iterate while printing a results table `s`).
  `Jacobi.m` and `GaussSeidel.m` solve **the same 5×5 system**, which suggests
  they were meant to be compared (Inferred).
- The three **non-linear** scripts share the same loop skeleton (evaluate,
  update, `norm` error, `fprintf` trace), and each keeps the *alternative*
  loop (fixed iterations vs. tolerance) commented out.
- `NewtonRaphsonBi.m` and `PuntoFijoMultivariable.m` solve **the same
  system**; the fixed-point initial guess `[0.525; 0.275]` is close to the
  value Newton-Raphson reaches after 5 iterations (≈ `[0.5259; 0.2759]`),
  suggesting the Newton result was reused as a starting point (Inferred).
- There are no function calls between scripts; each is run independently.

## Scope

- In scope: demonstrating the methods on fixed examples.
- Out of scope (nothing in the repo addresses it): user input, reusable
  functions, tests, performance, plotting, file output.

## History of this repository

| Date | Event |
|---|---|
| 2021-02-20 | Original upload of the six scripts and the MIT license. |
| 2026-09 | Repository reorganized and documented (folders moved into `src/`, documentation added). Source files left byte-for-byte unchanged. |
