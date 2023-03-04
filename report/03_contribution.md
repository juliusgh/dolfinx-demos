# Contribution to FEniCSx

## Overview

I have made the following contributions to improve the demos of FEniCSx:

- Adding a demo for the Stokes equation with various stable pairs of finite elements in
  [PR #2505](https://github.com/FEniCS/dolfinx/pull/2505) that aims to resolve
  [issue #2312](https://github.com/FEniCS/dolfinx/issues/2312)

- Adding a Python demo that solves the Poisson equation using matrix-free CG methods in
  [PR #2517](https://github.com/FEniCS/dolfinx/pull/2517) to resolve
  [issue #1776](https://github.com/FEniCS/dolfinx/issues/1776)

- Reimplementing Python and C++ demos from legacy FEniCS for FEniCSx that
  solve the biharmonic equation using a discontinuous Galerkin method in
  [PR #2508](https://github.com/FEniCS/dolfinx/pull/2508)

- Adding a DOLFIN to DOLFINx cheat sheet in
  [issue #2330](https://github.com/FEniCS/dolfinx/issues/2330)

Apart from that I also made some minor contributions on the way:

- Fixing isort checks for some demos in
  [PR #2506](https://github.com/FEniCS/dolfinx/pull/2506) that has been merged

- Updating the Slack invite link in the `README.md` in
  [PR #2485](https://github.com/FEniCS/dolfinx/pull/2485) that has been merged and on the
  website in [issue FEniCS/web#121](https://github.com/FEniCS/web/issues/121)

- Slightly improving the semi-official DOLFINx tutorial in
  [PR jorgensd/dolfinx-tutorial#110](https://github.com/jorgensd/dolfinx-tutorial/pull/110)
  that has been merged

## Contribution process

### Motivation

I have noticed that many users have not yet switched from legacy FEniCS to the new FEniCSx.
In my opinion, this is mainly because FEniCSx is not backward compatible and there are
few demos available for reference. That makes it difficult for new users to get started
with FEniCSx and to migrate code from legacy FEniCS to FEniCSx.

### Issue selection

I discovered the following issues that seemed interesting for my contribution:

- [Issue #2312](https://github.com/FEniCS/dolfinx/issues/2312):
  Add a demo using an Enriched Element

- [Issue #1776](https://github.com/FEniCS/dolfinx/issues/1776):
  Add matrix-free solver demos

- [Issue #2330](https://github.com/FEniCS/dolfinx/issues/2330):
  Create a DOLFIN to DOLFINx "cheat sheet"

- [Issue #28](https://github.com/FEniCS/dolfinx/issues/28):
  Reimplement PointSource

Then I decided as follows:

[Issue #28](https://github.com/FEniCS/dolfinx/issues/28)
is one of the oldest issues of FEniCSx and deals with the reimplementation
of an important feature.
However, the FEniCSx maintainers are not sure yet how exactly the feature should be
implemented. Hence, I did not consider this issue further.

Therefore I selected the three other issues for my contributions.

### Implementation

I started with
[issue #2312](https://github.com/FEniCS/dolfinx/issues/2312),
i.e. adding a demo using an Enriched Element. A popular Enriched
Element is the MINI element which can be used to solve the Stokes equations.
Hence, I created a Python demo for the Stokes equation where various
stable pairs of finite elements are compared in
[PR #2505](https://github.com/FEniCS/dolfinx/pull/2505).
The author of the issue and another maintainer appreciated the effort and also suggested
extending the demo, which I did then.

After that, I looked through the
[demos of legacy FEniCS](https://bitbucket.org/fenics-project/dolfin/src/master/demo/)
and found the following demos that seemed interesting also for FEniCSx, which I started
to prepare:

- Biharmonic C++ demo
- Nonlinear Poisson C++ demo
- Geometric Multigrid Poisson C++ demo

Later I found out that there is already a
[demo similar to the nonlinear Poisson demo](https://jsdokken.com/dolfinx-tutorial/chapter2/nonlinpoisson.html)
outside the repository. Thus, I did not add my reimplementation as a PR.

Unfortunately, it was not possible to get the multigrid demo to work for FEniCSx
without "hacking" since the
[necessary interpolation operator](https://github.com/FEniCS/dolfinx/pull/942)
has been removed.

Instead, I added my reimplementations of Python and C++ demos from
legacy DOLFIN that solve the biharmonic equation using a discontinuous Galerkin method in
[PR #2508](https://github.com/FEniCS/dolfinx/pull/2508).

Then, I turned my focus to the matrix-free solver demo for Python that was requested in
[issue #1776](https://github.com/FEniCS/dolfinx/issues/1776).
There was already a C++ demo from
[PR #1959](https://github.com/FEniCS/dolfinx/pull/1959),
which should be reimplemented for Python.
I found several ways to implement matrix-free solvers for FEniCSx in Python.
I created [PR #2517](https://github.com/FEniCS/dolfinx/pull/2517)
to add the implemented demo to FEniCSx.

The first version of my PR did not support MPI parallelization like the C++ demo.
Achieving this was not straightforward, as the C++ and Python APIs of DOLFINx are inconsistent
about when and how exactly to communicate between processes. After some time of debugging,
I was able to solve the problems, making the Python demo behave the same as
the C++ demo.

Finally, I have attached a DOLFIN to DOLFINx cheat sheet that I created along the way to
[issue #2330](https://github.com/FEniCS/dolfinx/issues/2330).

### Review and further course

As far as I can tell, my demos are working as intended and the pipeline is running successfully.
While some maintainers already reacted positively to my Stokes demo in
[PR #2505](https://github.com/FEniCS/dolfinx/pull/2505)
and the matrix-free solver demo in
[PR #2517](https://github.com/FEniCS/dolfinx/pull/2517),
there was unfortunately no detailed review yet.
As soon as this is available, I will adjust the demos accordingly.
There is also still no feedback on my biharmonic demos in
[PR #2508](https://github.com/FEniCS/dolfinx/pull/2508).
If the maintainers decide not to merge the demos,
I will try to add them to a FEniCSx tutorial outside the repository instead.

## Learnings

- Maintainers of large open-source projects tend to be busy, resulting in delayed reviews. Still, they put in a lot of effort and are supportive.
- Even if some maintainers indicate approval, this does not imply that all of them are behind it.
- Don't forget to test your code on a FEniCSx build with `PETSC_ARCH=linux-gnu-complex-32`, since the DOLFINx pipeline runs the demos also on this architecture and with complex numbers things can be different!
- For `petsc4py` it is easier to look in the source code than in the incomplete documentation.
- `jupytext` is a great tool to create a `git diff`-able format for Jupyter notebooks.
