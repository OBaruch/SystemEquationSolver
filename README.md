# System Equation Solver

A small collection of **MATLAB / GNU Octave scripts** that implement classic
**numerical methods for solving systems of equations**, both **linear**
(Gauss-Jordan, Jacobi, Gauss-Seidel) and **non-linear** (multivariate
Newton-Raphson, multivariate fixed-point iteration, Gauss-Newton).

> **Original implementation.** This repository preserves the original
> implementation of the project. The source code has intentionally not been
> refactored or modernized in order to retain the historical context and
> original development approach.

---

## Project Overview

| | |
|---|---|
| **Type** | Standalone numerical-methods scripts (no functions, no shared modules) |
| **Language** | MATLAB / GNU Octave (`.m`) |
| **Scripts** | 6 (3 linear, 3 non-linear) |
| **Original date** | February 2021 (first commit: 2021-02-20) |
| **Author** | Baruch Lopez |
| **License** | [MIT](LICENSE) |

Each script is self-contained: it hard-codes one example system, runs one
numerical method on it, and prints the intermediate results to the console.

## Project Context

**Project origin: Unknown** — most likely *Coursework / Academic* (inferred).

The repository contains no assignment statement, report, course name or
university reference, so the origin **cannot be confirmed**. The following
evidence suggests (but does not prove) that the scripts were written while
studying a *Numerical Methods* course:

- the set of methods matches a typical numerical-methods syllabus unit on
  systems of equations;
- the systems are fixed textbook-style examples with integer coefficients;
- the Spanish comments read like study notes (e.g. *"the method works when…"*,
  *"if there are more equations than variables go to the GaussNewton method"*).

See [docs/project-context.md](docs/project-context.md) for the full
Confirmed / Inferred / Unknown breakdown.

## Problem Statement

Solve systems of equations numerically:

- **Linear systems** `A·x = B` — directly (Gauss-Jordan) or iteratively
  (Jacobi, Gauss-Seidel).
- **Non-linear systems** `F(x, y) = 0` — square systems (Newton-Raphson,
  fixed-point) and over-determined systems with more equations than unknowns
  (Gauss-Newton, least squares).

## Objective

Implement and observe each method step by step: every script prints the
intermediate matrices or the iterate, error and iteration number, so the
convergence (or divergence) of the method can be followed on screen.

## Repository Structure

```
SystemEquationSolver/
├── README.md                  ← this file
├── LICENSE                    ← original MIT license (2021)
├── AGENTS.md                  ← guardrails for automated contributors
├── src/                       ← ORIGINAL source code (unchanged)
│   ├── linear/                ← originally "Lineales/"
│   │   ├── GaussJordan.m
│   │   ├── GaussSeidel.m
│   │   └── Jacobi.m
│   └── nonlinear/             ← originally "No lineales/"
│       ├── GaussNewton.m
│       ├── NewtonRaphsonBi.m
│       └── PuntoFijoMultivariable.m
└── docs/
    ├── project-context.md     ← origin, evidence, history
    ├── numerical-methods.md   ← math behind each method
    ├── code-overview.md       ← what each script does, line by line
    ├── possible-improvements.md ← observed issues (NOT applied)
    └── sdlc/
        ├── intent.md          ← why the project / the reorganization exist
        ├── spec.md            ← reverse-engineered specification
        ├── plan.md            ← reorganization plan and verification
        └── source-integrity.sha256 ← checksums of the original sources
```

Only folders were renamed/moved (`Lineales/` → `src/linear/`,
`No lineales/` → `src/nonlinear/`); file names and file contents are identical
to the 2021 upload.

## Original Implementation

The scripts in [`src/`](src/) are kept **byte-for-byte identical** to the
original upload, including their Windows (CRLF) line endings, their
ISO-8859-1 encoded accents, their Spanish comments and their known defects.
Integrity can be verified with:

```bash
sha256sum -c docs/sdlc/source-integrity.sha256
```

Defects and improvement ideas found during the review are documented — not
fixed — in [docs/possible-improvements.md](docs/possible-improvements.md).

## Technologies

| Technology | Evidence |
|---|---|
| **GNU Octave** | Linear scripts use Octave-only syntax: `!=`, `endfor`, `endif`, `endwhile`, `#` comments. |
| **MATLAB** (inferred) | Non-linear scripts use plain `end`, `%` comments and ISO-8859-1 accents typical of the MATLAB editor on Windows. |
| **Symbolic Math** | Non-linear scripts use `syms`, `jacobian`, `subs` (MATLAB Symbolic Math Toolbox, or Octave's `symbolic` package). |

No external data, build system or dependency manifest exists.

## How It Works

| Script | Method | Hard-coded system | Stop criterion |
|---|---|---|---|
| `linear/GaussJordan.m` | Gauss-Jordan with elementary matrices | 4×4 linear | direct (4 elimination steps) |
| `linear/Jacobi.m` | Jacobi iteration | 5×5 linear, `x0 = 0` | `‖x₁−x₀‖ > tol` loop, or `tol` iterations if `tol ≥ 1` |
| `linear/GaussSeidel.m` | Gauss-Seidel (as implemented) | same 5×5, `x0 = A\B` | same as Jacobi |
| `nonlinear/NewtonRaphsonBi.m` | Newton-Raphson, 2 variables | 2 equations, 2 unknowns | 5 iterations |
| `nonlinear/PuntoFijoMultivariable.m` | Fixed-point iteration, 2 variables | same system as Newton-Raphson | 5 iterations |
| `nonlinear/GaussNewton.m` | Gauss-Newton (least squares) | 3 equations, 2 unknowns | `‖x−x₀‖ > tol` loop |

Common pattern in all scripts:

1. `clear all`, `clc` — reset the workspace.
2. Define the system (matrix `A`, vector `B`, or symbolic vector `F`).
3. Linear scripts check `det(A) != 0` before solving.
4. Iterate, printing each step (`AB`, the table `s = [x₁' errAbs]`, or
   `fprintf` lines with iteration, values and error).

Details: [docs/code-overview.md](docs/code-overview.md) ·
Math: [docs/numerical-methods.md](docs/numerical-methods.md).

## Inputs and Outputs

- **Inputs:** none external. Every system, initial guess and tolerance is
  hard-coded at the top of each script; to try another system the variables
  are edited directly.
- **Outputs:** console only (matrices printed by omitting `;`, and
  `fprintf` traces). No files are written.

## Running the Project

The repository does not document how the scripts were run or which versions
were used. Based on the syntax, the following should work but **has not been
verified** for this reorganization:

- Linear scripts: open GNU Octave, `cd src/linear`, run e.g. `GaussJordan`.
- Non-linear scripts: open MATLAB (with the Symbolic Math Toolbox), `cd
  src/nonlinear`, run e.g. `NewtonRaphsonBi`. In GNU Octave the `symbolic`
  package would be required (`pkg load symbolic`).

Known blockers in the original code (kept as-is): `Jacobi.m` contains an
uncommented line `Metodo de Jacobi`, and `GaussNewton.m` contains a stray
`clcl` token inside the system definition. See
[docs/possible-improvements.md](docs/possible-improvements.md).

## Documentation

- [Project context](docs/project-context.md)
- [Numerical methods background](docs/numerical-methods.md)
- [Code overview](docs/code-overview.md)
- [Possible improvements (not applied)](docs/possible-improvements.md)
- Spec-driven records: [intent](docs/sdlc/intent.md) ·
  [spec](docs/sdlc/spec.md) · [plan](docs/sdlc/plan.md)

## Historical Note

This repository was later reorganized and documented to improve readability
and preserve the historical context of the original project. The original
source code remains unchanged.
