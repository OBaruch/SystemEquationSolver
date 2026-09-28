# Intent

[← Back to README](../../README.md) · Next: [spec.md](spec.md) → [plan.md](plan.md)

This is the first of three spec-driven records (**intent → spec → plan**)
reconstructed from what already exists in the repository. The intent states
*why* and *what outcome*; the [spec](spec.md) states *what exactly*; the
[plan](plan.md) states *how* and *how it is verified*.

There are two intents to capture, and they must not be confused:

1. the intent of the **original project** (2021), reconstructed from
   evidence;
2. the intent of the **repository reorganization** (2026), which is new work.

---

## 1. Original project intent (reconstructed, 2021)

**Status:** Inferred from code and comments — no written statement of intent
exists in the original upload. See [project-context.md](../project-context.md).

### Problem

Systems of equations — linear `A·x = B` and non-linear `F(x) = 0` — often
need to be solved numerically, and each method has different applicability
conditions and convergence behavior.

### Intended outcome

A set of small, independent MATLAB/Octave scripts, one per method, that:

- apply the method to a concrete example system;
- print every intermediate step so the process can be followed and checked;
- document in comments *when* each method should be used (square vs.
  over-determined systems, implicit form `= 0`).

### Users

The author (most likely as study material for a numerical methods course —
Inferred).

### Non-goals (evidenced by absence)

Reusable library, user input, error handling, tests, performance, plotting.

---

## 2. Repository reorganization intent (2026)

**Status:** Confirmed — this is the goal of the current change.

### Problem

The repository had no README or documentation, Spanish folder names (one
with a space), and no explanation of what the scripts do, which runtime they
target, or which of them work. A reader could not understand the project
without opening every file.

### Intended outcome

A clear, navigable, portfolio-ready **historical** repository that:

- explains the project, its context and its methods in English;
- separates original code (`src/`) from modern documentation (`docs/`);
- preserves the original implementation **byte-for-byte**, including its
  defects;
- distinguishes Confirmed, Inferred and Unknown information;
- records known issues without fixing them.

### Guiding principle

> Modernize the repository, not the project.

### Hard constraints

- Source file contents must not change (verified by SHA-256).
- No invented context, commands, versions or dependencies.
- No added infrastructure (CI, containers, build tools, test frameworks,
  package managers).

### Success looks like

A reader can understand what the project does, how each method works, what
is known about its origin and what is broken — from the README and `docs/`
alone — while `sha256sum -c docs/sdlc/source-integrity.sha256` passes.
