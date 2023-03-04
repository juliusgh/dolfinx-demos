# FEniCS(x): Automated solution of PDEs by the FEM

## What is FEniCS(x)?

[FEniCS(x)](https://fenicsproject.org/) (FE: Finite Elements, CS: Computational Software) is a software project that aims for the automated solution of partial differential equations (PDEs) by using the finite element method (FEM). The project targets mainly mathematicians that have already experience with PDEs and different FEM approaches, but do not want to develop an efficient FEM solver from scratch. An user can simply describe the weak formulation of the PDE and the desired Finite Element specifications and then FEniCS(x) handles the entire assembly and solution process in an optimized way.

FEniCS(x) also supports advanced techniques like saddle point problems, Brezzi-Douglas-Marini Finite Elements or enriched/extended Finite Elements, which are not available in commonly used FEM solvers. FEniCS(x) is actively used in research as Google Scholar lists about 3000 [citations to the FEniCS book](https://scholar.google.com/scholar?cites=543273511654441124).
Applications range from solid mechanics, fluid mechanics and FSI to electromagnetics - basically any subject where PDEs are involved.
A great advantage of FEniCS(x) over commercial FEM solvers is that the user always has full control over the PDE models, the Finite Element discretization and the solver configuration.

Development of FEniCS started in 2003 as a collaboration between the [Chalmers University of Technology](https://www.chalmers.se/en/Pages/default.aspx) and the [University of Chicago](https://www.uchicago.edu/). Nowadays, the development is mainly driven by the [FEniCS(x) steering council](https://github.com/FEniCS/governance/blob/master/people.md) around long-term maintainer [Garth Wells](https://www3.eng.cam.ac.uk/~gnw20/index.html).

In 2019, the FEniCS(x) team started a [refactoring process of the entire software](https://web.archive.org/web/20190607131947/https://fenicsproject.org/fenics-project-roadmap-2019/). The new edition is called FEniCSx and developed on [GitHub](https://github.com/FEniCS). The last stable release of the [legacy FEniCS](https://bitbucket.org/fenics-project/) is version 2019.1.0, while FEniCSx has currently the [version 0.5.2](https://github.com/FEniCS/dolfinx/releases/tag/v0.6.0) (as of February 2023) and is still in active development.
Some features of legacy FEniCS are missing in FEniCSx or still experimental and the documentation is not complete yet. In particular, an overview of changes from FEniCS to FEniCSx is not available and an [open issue on GitHub](https://github.com/FEniCS/dolfinx/issues/2330).
However, the developers recommend to use FEniCSx:

> Now that development is focussed on FEniCSx, updates are made very rarely to the legacy FEniCS library. We recommend that users consider using FEniCSx instead of the legacy library.

## How does it work?

FEniCS(x) has the goal to automate the entire workflow of the numerical solution of a PDE. The user provides the weak formulation and defines the solution spaces. Then, FEniCS automatically generates efficient C++ code to assemble the Finite Element system and solves it using a linear algebra backend like PETSc. The generated code supports parallelization using [MPI](https://de.wikipedia.org/wiki/Message_Passing_Interface).

FEniCSx is not a monolithic software system, but rather a combination of several building blocks that need to be used together. It consists of the following libraries:

- [UFL](https://github.com/FEniCS/ufl): Unified Form Language that is used to express the weak formulation of a PDE in Python code
- [FFCx](https://github.com/FEniCS/ffcx): FEniCSx Form Compiler that compiles the weak formulation in UFL to efficient C++ code
- [Basix](https://github.com/FEniCS/basix): Provides the Finite Element basis functions for a wide range of Finite Elements (in legacy FEniCS this was provided by [FIAT](https://github.com/FEniCS/fiat))
- [DOLFINx](https://github.com/FEniCS/dolfinx): Contains all necessary data structures, connects the several parts of FEniCS and provides a unifying Python interface

![Overview of the FEniCS software project](figs/overview.pdf)

FEniCSx employs mixed language programming by providing a convenient Python interface and performing the costly computations in C++. The user only needs to call the `solve` function of the Python interface and a JIT compiler handles everything under the hood.

## Installation

There are multiple options to obtain a FEniCSx installation:

- [Docker container](https://github.com/FEniCS/dolfinx#docker-images): easiest option

```shell
docker run -ti dolfinx/dolfinx:stable
```

- [Binary packages](https://github.com/FEniCS/dolfinx#binary): easy, but usually not the latest version
- [Built from source](https://docs.fenicsproject.org/dolfinx/main/python/installation.html#source): This is a bit cumbersome since all parts of FEniCSx have to be built from source separately before compiling DOLFINx. I collected all necessary steps on Ubuntu in an [installation script](install_fenicsx.sh).

## Getting started

There are really good tutorials for FEniCSx and legacy FEniCS. I would recommend starting with the Poisson problem and then solving real world problems (e.g. linear elasticity).

### Tutorials

- ["The FEniCSx Tutorial"](https://jorgensd.github.io/dolfinx-tutorial/) by Jørgen S. Dokken (for FEniCSx)
- [Solving PDEs in Python: The FEniCS Tutorial I](https://doi.org/10.1007/978-3-319-52462-7) by Hans P. Langtangen and Anders Logg (for legacy FEniCS)

### Further information

- [Documentation of the DOLFINx Python interface](https://docs.fenicsproject.org/dolfinx/main/python/)
- [Documentation of the DOLFINx C++ API](https://docs.fenicsproject.org/dolfinx/main/cpp/)
- [Automated Solution of Differential Equations by the Finite Element Method - "The FEniCS Book"](https://fenicsproject.org/pub/book/book/fenics-book-2011-06-14.pdf) by Anders Logg, Kent-Andre Mardal and Garth Wells (for legacy FEniCS)
- [Roadmap of the FEniCSx project](https://fenicsproject.org/roadmap/)
