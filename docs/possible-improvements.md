# Possible Improvements

[← Back to README](../README.md)

> **None of these improvements have been applied.** The source code in
> [`src/`](../src/) is intentionally preserved exactly as originally written,
> including its defects, to retain the historical context of the project.
> This list exists only as a reference for anyone who wants to build a
> modern version separately.

## 1. Defects that prevent or distort execution

| # | File | Issue | Effect | Possible fix |
|---|---|---|---|---|
| 1 | `src/linear/Jacobi.m` (line 15) | `Metodo de Jacobi` is not commented | Octave treats it as a call to an undefined `Metodo`; the script stops | Prefix with `%` |
| 2 | `src/nonlinear/GaussNewton.m` (line 15) | Stray `clcl` after `(11/36)` | Syntax error; the script cannot run | Remove the token |
| 3 | `src/linear/GaussSeidel.m` | Update uses `inv(D)` instead of `inv(L)` (`L = tril(A)` is unused) | Converges to the solution of `(D+U)x = B`, not `Ax = B` | `x1 = L \ (B - U*x0)` |
| 4 | `src/linear/GaussSeidel.m` | Initial guess `x0 = A\B` is already the exact solution | Hides whether the method converges | Start from zeros or a user-supplied guess |
| 5 | `src/linear/Jacobi.m`, `GaussSeidel.m` | Example matrix is not diagonally dominant and there is no iteration cap in the `while` loop | Jacobi diverges and only stops when the error becomes `NaN` | Add `max_iter`, check convergence conditions, or reorder rows |
| 6 | `src/nonlinear/PuntoFijoMultivariable.m` | The rearrangement `G` is not a contraction near the root | Iterates move away from the root | Choose another rearrangement or check `‖J_G‖ < 1` |

## 2. Numerical robustness

- `det(A) != 0` / `det(A) == 0` compares floating-point values exactly;
  a condition number (`cond`, `rcond`) is a more reliable singularity test.
- `inv(...)` is used to solve linear systems in every iterative script;
  the backslash operator (`\`) is more accurate and cheaper.
- Gauss-Jordan uses no pivoting; a zero or tiny pivot breaks it even when
  `det(A) != 0`.
- `inv(J'*J)` in Gauss-Newton squares the condition number; `J \ F`
  (QR-based least squares) avoids that.
- `tol = 10e-5` equals `1e-4` (not `1e-5`); likely intended as `1e-5`.
- `errRel` is computed but never used or reported.

## 3. Code structure

- Convert each script into a `function` taking `(A, B, x0, tol, max_iter)`
  or `(F, v, x0, tol, max_iter)` and returning the solution and history,
  so systems are not hard-coded.
- The `tol >= 1` convention (tolerance reused as iteration count) could be
  replaced with separate `tol` and `max_iter` parameters.
- Remove unused variables (`L`, `J`/`J_ev` in fixed-point, `max_iter` in
  Gauss-Newton, `nc`).
- Mixed Octave-only (`!=`, `endfor`, `#`) and MATLAB syntax: choosing one
  dialect would make all scripts portable.
- Replace `clear all` with `clear` (or nothing, inside functions).

## 4. Repository-level

- Convert files to UTF-8 with LF line endings (currently ISO-8859-1 +
  CRLF) — **not done** because it would change the original bytes.
- Add automated tests comparing each method against `A\B` or known roots.
- Translate comments and messages to English.
