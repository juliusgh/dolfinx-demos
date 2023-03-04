# RSE infrastructure of FEniCSx

## Git workflow and external contributions

The FEniCSx team employs a [forking workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow) using feature branches on the developer's forks. Even maintainers work on their forks except when finalizing a release.
The contribution process starts by creating a fork of the repository. It is recommended to announce new contributions via GitHub issues.
After implementing the new feature, a pull request can be made to the [main branch](https://github.com/FEniCS/dolfinx/tree/main) of the origin repository. When the test and build pipeline succeeds and the review of a maintainer is successful, the pull requests can be merged.
Whenever a new version is released, the current code on the main branch is merged into the [release branch](https://github.com/FEniCS/dolfinx/tree/release).

The FEniCSx ecosystem consists of various building blocks.
Besides the repository for [DOLFINx](https://github.com/FEniCS/dolfinx) there are separate repositories for [ffcx](https://github.com/FEniCS/ffcx), [ufl](https://github.com/FEniCS/ufl) and [basix](https://github.com/FEniCS/basix).
Their RSE infrastructure is similar to the DOLFINx repository.
In addition, there are further repositories, such as for the [documentation](https://github.com/FEniCS/docs) and the [website](https://github.com/FEniCS/web).

Possibilities to contribute are explained in [CONTRIBUTING.md](https://github.com/FEniCS/dolfinx/blob/main/CONTRIBUTING.md). Contributions from new developers are welcome but should follow the [code of conduct](https://fenicsproject.org/code-of-conduct/) and the style guides of the project such as the [C++ style guide](https://docs.fenicsproject.org/dolfinx/v0.5.1/python/styleguide_cpp.html).
There are also issues targeting new developers that are labeled as ["good first issue"](https://github.com/FEniCS/dolfinx/contribute).

The long-term goals of the project are formulated in the [road map](https://fenicsproject.org/roadmap/) on the website.
Questions about the usage of FEniCS can be asked on [Discourse](https://fenicsproject.discourse.group/). The communication between developers takes place on [Slack](https://fenicsproject.slack.com/).

## Virtualization and containers

The [Docker](https://www.docker.com/) platform is used extensively to test and ship the code.
On the one hand, Docker containers are used by the testing and CI pipeline to create a standardized environment.
On the other hand, Docker containers can be used easily to run the latest stable release of DOLFINx

```shell
docker run -ti dolfinx/dolfinx:stable
```

to run the latest nightly build of DOLFINx

```shell
docker run -ti dolfinx/dolfinx:nightly
```

or to run a Jupyter Lab with the latest stable release of DOLFINx

```shell
docker run --init -ti -p 8888:8888 dolfinx/lab:stable
```

## Building and packaging

The C++ code is built using `cmake` based on `CMakeLists.txt` files.
The Python code is packaged using `build` based on the `setup.py` file.

Spack packages are available and can be installed via

```shell
spack env create fenicsx-env
spack env activate fenicsx-env
spack add py-fenics-dolfinx cflags="-O3" fflags="-O3"
spack install
```

There are also distribution packages, e.g. for [Ubuntu](https://launchpad.net/~fenics-packages/+archive/ubuntu/fenics) and [Debian](https://tracker.debian.org/pkg/fenics-dolfinx), but they are rather outdated.

## Documentation

The documentation of FEniCSx consists of the [DOLFINx C++ API reference](https://docs.fenicsproject.org/dolfinx/main/cpp/), the [DOLFINx Python API reference](https://docs.fenicsproject.org/dolfinx/main/python/), and the API references of the other building blocks of FEniCSx.
Besides that, there are some [tutorials](https://jorgensd.github.io/dolfinx-tutorial/) on the website of a maintainer that are treated as semi-official tutorials.

According to the [README.md of the C++ API reference](https://github.com/FEniCS/dolfinx/blob/main/cpp/doc/README.md)

> The C++ API documentation is generated from the source code using Doxygen, and the Doxygen output is curated and rendered using reStructured text with Sphinx and Breathe.

The Python API reference is created using [reStructured text](https://docutils.sourceforge.io/rst.html) with [Sphinx](https://www.sphinx-doc.org/).

## Testing and CI

Different tools are used to automate the testing and CI tasks. Besides [GitHub Actions](https://docs.github.com/en/actions), the FEniCSx team also uses [CircleCI](https://circleci.com/) and [SonarCloud](https://www.sonarsource.com/products/sonarcloud/) for automation purposes.

According to the [configuration](https://github.com/FEniCS/dolfinx/tree/main/.github/workflows), GitHub Actions are used to build Docker images, build the software in different configurations, and update the documentation on the website. When you make a pull request, GitHub actions are automatically triggered.
CircleCI is used to run the tests for different build configurations. Details can be found in the [configuration file](https://github.com/FEniCS/dolfinx/blob/main/.circleci/config.yml).

For C++, [unit tests](https://github.com/FEniCS/dolfinx/tree/main/cpp/test) using the test framework [Catch2](https://github.com/catchorg/Catch2) and some [demos](https://github.com/FEniCS/dolfinx/tree/main/cpp/demo) are executed automatically.
For Python, [unit tests](https://github.com/FEniCS/dolfinx/tree/main/python/test) are run using [pytest](https://docs.pytest.org/).
