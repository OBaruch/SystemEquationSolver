# Numerical Methods Background

[← Back to README](../README.md)

A short reference for the methods implemented in [`src/`](../src/), written
to help read the original scripts. The formulas below describe the textbook
methods; where a script deviates from them, the difference is noted and
explained in [code-overview.md](code-overview.md).

## Linear systems — `A·x = B`

### Gauss-Jordan elimination (`src/linear/GaussJordan.m`)

A direct method. The augmented matrix `[A | B]` is transformed into
`[I | x]`. The script does it with **elementary matrices**: for each column
`k` it builds `E = I` and replaces column `k` by

```
E(:,k) = -AB(:,k) / AB(k,k),   E(k,k) = 1 / AB(k,k)
```

so `E·AB` normalizes the pivot row and eliminates column `k` in every other
row. After `n` steps the last column of `AB` holds the solution.
Requires non-zero pivots (no pivoting is done).

### Matrix splitting for iterative methods

Write `A = L* + D + U*`, where `D` is the diagonal, `L*` the strictly lower
and `U*` the strictly upper triangle. In the scripts:

```
D = triu(A) + tril(A) - A     % diagonal of A
```

### Jacobi (`src/linear/Jacobi.m`)

```
x(k+1) = D⁻¹ · (B − (L* + U*)·x(k))
```

The script uses `R = A − D` for `L* + U*`.

### Gauss-Seidel (`src/linear/GaussSeidel.m`)

Textbook form:

```
x(k+1) = (D + L*)⁻¹ · (B − U*·x(k))
```

The script builds `L = tril(A)` (= `D + L*`) but iterates with `inv(D)`
instead of `inv(L)` — see [code-overview.md](code-overview.md#gaussseidelm).

### Convergence

Both iterative methods converge for any starting vector when the spectral
radius of the iteration matrix is `< 1`; a sufficient condition is **strict
diagonal dominance** of `A`. The 5×5 system used in the scripts is **not**
diagonally dominant.

### Stopping criterion used in the scripts

```
errAbs = ‖x(k) − x(k+1)‖₂        errRel = errAbs / ‖x(k+1)‖₂
```

Iteration stops when `errAbs ≤ tol` (or `< tol` for Gauss-Seidel).
If `tol ≥ 1`, the value is reused as a fixed **number of iterations**.

## Non-linear systems — `F(x) = 0`

All three scripts use symbolic variables `x, y`, build `F` symbolically and
obtain the Jacobian with `jacobian(F, v)`; values are then evaluated
numerically with `double(subs(...))`.

### Newton-Raphson, multivariate (`src/nonlinear/NewtonRaphsonBi.m`)

For a square system (as many equations as unknowns):

```
x(k+1) = x(k) − J(x(k))⁻¹ · F(x(k))
```

### Fixed-point iteration, multivariate (`src/nonlinear/PuntoFijoMultivariable.m`)

Rewrite `F(x) = 0` as `x = G(x)` and iterate:

```
x(k+1) = G(x(k))
```

For the system `e^(x²+3y) = 3`, `x² = y` the script uses

```
G(x, y) = [ sqrt(ln 3 − 3y) ;  x² ]
```

Convergence requires `G` to be a contraction near the root
(‖J_G‖ < 1), which depends on the chosen rearrangement.

### Gauss-Newton (`src/nonlinear/GaussNewton.m`)

For over-determined systems (more equations than unknowns) it minimizes
`‖F(x)‖²` using the normal equations of the linearized problem:

```
x(k+1) = x(k) − (Jᵀ J)⁻¹ Jᵀ · F(x(k))
```

When the Jacobian is square and invertible this reduces to Newton-Raphson.
