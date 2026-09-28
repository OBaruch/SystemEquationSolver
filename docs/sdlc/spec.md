# Specification

[← Back to README](../../README.md) · Previous: [intent.md](intent.md) · Next: [plan.md](plan.md)

Two specifications are recorded here:

- **Part A** — a *reverse-engineered* behavioral specification of the
  original scripts (what they do, as written). It describes existing
  behavior; it is not a requirements document the code was built against.
- **Part B** — the specification of the repository reorganization, with
  acceptance criteria.

Status tags: **C** = Confirmed (read from code), **I** = Inferred
(reasoned or re-computed outside the original runtime), **U** = Unknown.

---

## Part A — Original behavior (as implemented)

### A.1 Global conventions

| ID | Behavior | Status |
|---|---|---|
| A.1.1 | Every script is a standalone script (no `function`), independent of the others. | C |
| A.1.2 | Every script begins by clearing the workspace (`clear all`) and the console (`clc`). | C |
| A.1.3 | All inputs (system, initial guess, tolerance, iteration count) are hard-coded. | C |
| A.1.4 | All output goes to the console; no files are read or written. | C |
| A.1.5 | Linear scripts target GNU Octave syntax; non-linear scripts use MATLAB-compatible syntax with symbolic math (`syms`, `jacobian`, `subs`). | C |
| A.1.6 | Target runtime versions. | U |

### A.2 Linear solvers — `src/linear/`

| ID | Script | Behavior | Status |
|---|---|---|---|
| A.2.1 | all | Proceed only if `det(A) != 0`; otherwise print `"Sin solucion...La determinante de la matriz es cero"`. | C |
| A.2.2 | `GaussJordan.m` | For `k = 1..nr`, left-multiply `[A,B]` by an elementary matrix that normalizes pivot `k` and eliminates column `k`; print `AB` after each step. | C |
| A.2.3 | `GaussJordan.m` | For the hard-coded 4×4 system the final column is `[3; 5; 1; 3]`. | I (re-computed) |
| A.2.4 | `Jacobi.m`, `GaussSeidel.m` | If `tol >= 1`, perform exactly `tol` iterations; otherwise iterate until the absolute error `norm(x0-x1)` meets `tol` (`>` for Jacobi, `>=` for Gauss-Seidel), with no iteration cap. | C |
| A.2.5 | `Jacobi.m`, `GaussSeidel.m` | Accumulate rows `[x1', errAbs]` in `s` and print `s` at the end. | C |
| A.2.6 | `Jacobi.m` | Update `x1 = inv(D)*(B - (A-D)*x0)` from `x0 = 0`. | C |
| A.2.7 | `Jacobi.m` | Uncommented line `Metodo de Jacobi` halts execution in Octave before any computation. | I |
| A.2.8 | `Jacobi.m` | If that line is bypassed, the iteration diverges for the hard-coded system (spectral radius ≈ 3.39). | I (re-computed) |
| A.2.9 | `GaussSeidel.m` | Update `x1 = inv(D)*(B - U*x0)` from `x0 = A\B`, where `U` is the strictly upper triangle; `L = tril(A)` is computed but unused. | C |
| A.2.10 | `GaussSeidel.m` | Terminates after 6 iterations at the solution of `(D+U)x = B`, not of `Ax = B`. | I (re-computed) |

### A.3 Non-linear solvers — `src/nonlinear/`

| ID | Script | Behavior | Status |
|---|---|---|---|
| A.3.1 | all | Unknowns `v = [x; y]` symbolic; `J = jacobian(F, v)`; numeric evaluation via `double(subs(...))`. | C |
| A.3.2 | all | Each iteration prints `Iteración: #i`, the current values and the error `norm(x - x0)`. | C |
| A.3.3 | `NewtonRaphsonBi.m` | `F = [exp(x^2+3y)-3; x^2-y]`, `x0 = [1;1]`, 5 iterations of `x = x0 - inv(J)*F`. | C |
| A.3.4 | `NewtonRaphsonBi.m` | After 5 iterations `x ≈ [0.5259; 0.2759]`, last step ≈ 0.034. | I (re-computed) |
| A.3.5 | `PuntoFijoMultivariable.m` | Same `F`; iterate `G = [sqrt(log(3)-3y); x^2]` from `[0.525; 0.275]` for 5 iterations. | C |
| A.3.6 | `PuntoFijoMultivariable.m` | Step size grows each iteration (≈ 0.002 → 0.018): not converging. | I (re-computed) |
| A.3.7 | `GaussNewton.m` | 3 equations, 2 unknowns, `x0 = [1;1]`; iterate `x = x0 - inv(J'J)J'F` while `err > tol`. | C |
| A.3.8 | `GaussNewton.m` | Stray `clcl` in `F` makes the script fail to parse. | I |
| A.3.9 | all | Each script keeps the alternative loop form (fixed iterations vs. tolerance) commented out. | C |

---

## Part B — Repository reorganization

### B.1 Functional requirements

| ID | Requirement |
|---|---|
| B.1.1 | Move `Lineales/` → `src/linear/` and `No lineales/` → `src/nonlinear/` using history-preserving renames; keep file names. |
| B.1.2 | Add `README.md` with overview, context, problem, objective, structure, original-implementation note, technologies, how it works, inputs/outputs, running notes, documentation links and historical note. |
| B.1.3 | Add `docs/project-context.md`, `docs/numerical-methods.md`, `docs/code-overview.md`, `docs/possible-improvements.md`. |
| B.1.4 | Add `docs/sdlc/intent.md`, `spec.md`, `plan.md` and `source-integrity.sha256`. |
| B.1.5 | Add `.gitattributes` preventing line-ending normalization of `src/**/*.m`. |
| B.1.6 | Add a minimal `.gitignore` for MATLAB/Octave and editor artifacts. |
| B.1.7 | Add `AGENTS.md` stating the preservation rules for automated contributors. |
| B.1.8 | Keep `LICENSE` unchanged at the root. |

### B.2 Non-functional requirements

| ID | Requirement |
|---|---|
| B.2.1 | All documentation in English. |
| B.2.2 | Every non-obvious claim tagged Confirmed / Inferred / Unknown. |
| B.2.3 | Relative links only; every link resolves inside the repository. |
| B.2.4 | No new tooling, dependencies, CI, containers or build files. |
| B.2.5 | No folders without content (no `data/`, `assets/`, `archive/`, `docs/original/` — nothing exists to put there). |

### B.3 Acceptance criteria

| ID | Criterion | How verified |
|---|---|---|
| AC-1 | Source bytes unchanged | `sha256sum -c docs/sdlc/source-integrity.sha256` → all `OK`; hashes equal those of commit `d201524`. |
| AC-2 | Git records moves as 100 % renames | `git diff --cached -M --summary` shows `rename ... (100%)` for all six files. |
| AC-3 | No source file deleted | Six `.m` files present under `src/`. |
| AC-4 | Docs navigable | Every relative Markdown link targets an existing path. |
| AC-5 | No invented facts | Unknowns explicitly stated (university, course, runtime versions, run instructions). |
