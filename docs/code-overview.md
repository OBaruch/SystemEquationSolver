# Code Overview

[← Back to README](../README.md)

A file-by-file description of the original scripts. Nothing described here
was modified; quoted identifiers and Spanish messages are exactly as in the
source.

Numerical observations marked *(re-computed)* were obtained during this
documentation effort by re-implementing the same arithmetic in a separate
environment — the original scripts were **not** executed, because no
MATLAB/Octave runtime was available. They are therefore **Inferred**, not
Confirmed.

## Overview

| File | Lines of logic | Runtime style | Loop | Output |
|---|---|---|---|---|
| [`src/linear/GaussJordan.m`](../src/linear/GaussJordan.m) | ~20 | Octave | `for k=1:nr` | `AB` after every step |
| [`src/linear/Jacobi.m`](../src/linear/Jacobi.m) | ~35 | Octave | `for` / `while` | table `s` |
| [`src/linear/GaussSeidel.m`](../src/linear/GaussSeidel.m) | ~35 | Octave | `for` / `while` | table `s` |
| [`src/nonlinear/NewtonRaphsonBi.m`](../src/nonlinear/NewtonRaphsonBi.m) | ~30 | MATLAB-style + symbolic | `for` (5 iterations) | `fprintf` trace |
| [`src/nonlinear/PuntoFijoMultivariable.m`](../src/nonlinear/PuntoFijoMultivariable.m) | ~25 | MATLAB-style + symbolic | `for` (5 iterations) | `fprintf` trace |
| [`src/nonlinear/GaussNewton.m`](../src/nonlinear/GaussNewton.m) | ~30 | MATLAB-style + symbolic | `while` | `fprintf` trace |

All files are scripts (no `function` definitions), start with
`clear all` / `clc`, and are independent of each other.

File-format facts (Confirmed): all files use CRLF line endings; the three
non-linear scripts contain ISO-8859-1 characters (`MÉTODO`, `Iteración`).

---

## Linear systems

### `GaussJordan.m`

**Purpose:** solve a 4×4 linear system directly with Gauss-Jordan
elimination expressed as products of elementary matrices.

**Data:**

```
A = [19  4 -4  3
     -5 12 -5 -7
      2  3 15  4
     -1 -3  5  9]      B = [82; 19; 48; 14]
```

**Flow:**

1. `format long`; build augmented matrix `AB = [A, B]`.
2. If `det(A) != 0`: for each column `k`, build an identity `e`, replace its
   column `k` by `-AB(:,k)/AB(k,k)` with `1/AB(k,k)` on the pivot, and
   update `AB = e*AB` (printed each time).
3. If `det(A) == 0`: print `"Sin solucion...La determinante de la matriz es cero"`.

**Result:** the last column of the final `AB` is the solution.
*(re-computed)* `det(A) = 28012`, solution `x = [3; 5; 1; 3]`.

**Notes:** no row pivoting; `nr`/`nc` from `size(A)` are used as loop bound
and identity size.

### `Jacobi.m`

**Purpose:** solve a 5×5 system with the Jacobi method.

**Header comments:** a scratch list of Octave commands the author was
learning (`randi`, `triu`, `tril`, `inv`, `det`, transpose), all commented out.
Note that the comments label `triu` as *lower* and `tril` as *upper* triangle
(swapped).

**Data:**

```
A = [ 4 -3 -5 11 -6
      0  6 -5  6 11
      7 -7 -6  1  2
     -1 10 -8 -3  6
     -6 -8 11  4  5]    B = [9; 65; -20; 43; -19]    tol = 10e-5  (= 1e-4)
```

**Flow:**

1. If `det(A) != 0`: `D` = diagonal of `A`, `R = A - D`, `x0 = 0`
   (the alternative `x0 = A\B` is commented out).
2. If `tol >= 1`, run exactly `tol` iterations; otherwise loop
   `while (errAbs > tol)`.
3. Each iteration: `x1 = inv(D)*(B - R*x0)`, absolute error
   `norm(x0 - x1)`, relative error (computed but not stored), append
   `[x1' errAbs]` to table `s`.
4. Print `s`.

**Observations:**

- Line 15 is the plain text `Metodo de Jacobi` without a comment marker.
  Octave would interpret it as a command-syntax call to an undefined
  `Metodo` and stop there (Inferred).
- *(re-computed)* `det(A) = -82450`; exact solution `[2; 5; 1; 3; 2]`.
  The Jacobi iteration matrix has spectral radius ≈ 3.39 (> 1), so the
  iterates diverge. In IEEE arithmetic the error grows to `Inf`/`NaN`, and the
  `while` loop only ends when the comparison with `NaN` becomes false
  (≈ 580 iterations in the re-computation).

### `GaussSeidel.m`

**Purpose:** solve the same 5×5 system as `Jacobi.m` with Gauss-Seidel.

**Flow:** identical structure to `Jacobi.m`, with:

- `D` = diagonal, `L = tril(A)` (lower triangle **including** the diagonal),
  `U = triu(A) - D` (strictly upper).
- Initial guess `x0 = A\B`, commented as *"DEFINIDO Valores reales de x"*
  (defined: real values of x) — i.e. the exact solution.
- Update: `x1 = inv(D)*(B - U*x0)`; stop `while (errAbs >= tol)`.

**Observations:**

- `L` is computed but never used. The update uses `inv(D)` rather than
  `inv(L)`, so the lower-triangular part of `A` is ignored. The iteration
  therefore solves `(D + U)·x = B`, not `A·x = B`.
- *(re-computed)* because `D⁻¹U` is strictly upper triangular (nilpotent),
  the loop terminates after 6 iterations at
  `[83.6875; 38.4093; -1.5889; -21.9333; -3.8]`, which is the solution of
  `(D + U)·x = B`. A textbook Gauss-Seidel on this matrix would diverge
  (spectral radius ≈ 9.5).

---

## Non-linear systems

The three scripts share the same skeleton:

```
syms x y          % symbolic variables
x0 = [..; ..];    % initial guess
v  = [x; y];
F  = [...];       % system in implicit form F = 0
J  = jacobian(F, v);
max_iter = 5; tol = ...; err = 100;
loop:
    evaluate with double(subs(..., v, x0))
    update x, err = norm(x - x0), x0 = x
    fprintf('Iteración: #%d', 'Valores de x0:%f', 'Error:%f')
```

Each file keeps the *other* loop variant (fixed iterations vs. tolerance)
commented out.

### `NewtonRaphsonBi.m`

**Purpose:** bivariate Newton-Raphson for a square non-linear system.

**Header comment (translated):** Newton-Raphson applies to non-linear
systems with the same number of equations as unknowns (square matrix); if
there are more equations than unknowns use `GaussNewton`; equations must be
implicit and equal to zero.

**System:** `F = [exp(x^2+3*y) - 3; x^2 - y]`, `x0 = [1; 1]`,
`tol = 10e-4` (unused by the active loop).

**Active loop:** `for i=1:max_iter` (5 iterations),
`x = x0 - inv(J_ev)*F_ev`.

*(re-computed)* iterates approach `[0.5259; 0.2759]` with the last step
size ≈ 0.034, i.e. still not converged after 5 iterations.

### `PuntoFijoMultivariable.m`

**Purpose:** bivariate fixed-point iteration for the same system as
`NewtonRaphsonBi.m`.

**Data:** `x0 = [0.525; 0.275]`,
`F_desp = [(log(3) - 3*y)^(1/2); x^2]` ("despeje" = the system solved for
`x` and `y`).

**Active loop:** `for i=1:max_iter` (5 iterations), `x = G(x0)`.

**Observations:**

- `F`, `J` and `J_ev` are computed but not used by the iteration.
- *(re-computed)* the step size grows every iteration
  (≈ 0.002 → 0.018), i.e. this rearrangement moves away from the root
  instead of converging.

### `GaussNewton.m`

**Purpose:** Gauss-Newton for an over-determined non-linear system
(3 equations, 2 unknowns).

**Header comment (translated):** Gauss-Newton works when some equation is
non-linear and there are *more* equations than variables (non-square
matrix); equations must be implicit and equal to zero.

**System (as written):**

```
F = [exp(-x^2-3*y^2) - exp(-7/2);
     5*x^2 + 3*y^2 - (19/12);
     x^2 + x*y - y*2 - (11/36)clcl];
```

`x0 = [1; 1]`, `tol = 10e-5`.

**Active loop:** `while (err > tol)`,
`x = x0 - inv(J_ev'*J_ev)*J_ev'*F_ev`.

**Observations:**

- The third equation (line 15) ends with the stray token `clcl` (looks like an
  accidental keystroke of `clc`), which is a syntax error, so the script
  cannot run as uploaded (Inferred from syntax; not executed).
- The `for` variant is commented out; `max_iter` is unused by the active
  loop.
