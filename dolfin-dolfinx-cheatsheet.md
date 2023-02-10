# DOLFIN/DOLFINx Cheat Sheet

## Import/include the most important modules/headers

### DOLFINx (Python)

```python
import ufl
from dolfinx import fem, io, mesh, plot
from mpi4py import MPI
from petsc4py import PETSc
```

### DOLFIN (Python)

```python
from dolfin import *
```

### DOLFINx (C++)

```c++
#include <dolfinx.h>
//...
using namespace dolfinx;
```

### DOLFIN (C++)

```c++
#include <dolfin.h>
//...
using namespace dolfin;
```

## Create a mesh

As an example, we create a mesh consisting of 32 x 32 triangles on the unit square $\Omega = [0,1] \times [0,1]$.

### DOLFINx (Python)

```python
msh = mesh.create_unit_square(comm=MPI.COMM_WORLD, nx=32, ny=32,
                              cell_type=mesh.CellType.triangle)
# or
msh = mesh.create_rectangle(comm=MPI.COMM_WORLD,
                            points=((0.0, 0.0), (1.0, 1.0)),
                            n=(32, 32),
                            cell_type=mesh.CellType.triangle)
```

### DOLFIN (Python)

```python
msh = UnitSquareMesh.create(mpi.comm_world,
                            32, 32,
                            CellType.Type.triangle)
```

### DOLFINx (C++)

```c++
auto msh = std::make_shared<mesh::Mesh>(
    mesh::create_rectangle(MPI_COMM_WORLD,
        {{{0.0, 0.0}, {1.0, 1.0}}},
        {32, 32},
        mesh::CellType::triangle,
        mesh::create_cell_partitioner(mesh::GhostMode::shared_facet)));
```

### DOLFIN (C++)

```c++
auto msh = std::make_shared<Mesh>(
    UnitSquareMesh::create({{32, 32}},
                           CellType::Type::triangle));
```

## Define a function space

As an example we create a space `V` consisting of first-order, continuous Lagrange finite element functions.

A complete list of implemented finite elements can be found on
[defelement.com](https://defelement.com/lists/implementations/ufl.html).

### DOLFINx (Python)

```python
V = fem.FunctionSpace(msh, ("Lagrange", 1))
```

### DOLFIN (Python)

```python
V = FunctionSpace(msh, "Lagrange", 1)
```

### DOLFINx (C++)

First define the UFL form in the corresponding Python file.

```python
from ufl import (FiniteElement, triangle)
# ...
element = FiniteElement("Lagrange", triangle, 1)
# ...
coord_element = create_vector_element("Lagrange", "triangle", 1)
mesh = Mesh(coord_element)
V = FunctionSpace(mesh, element)
u = TrialFunction(V)
v = TestFunction(V)
a = inner(grad(u), grad(v)) * dx
```

Then define the function space in C++.

```c++
#include "poisson.h"
// ...
// `functionspace_form_poisson_a` is defined in "poisson.h",
// which is compiled using FFCx
auto V = std::make_shared<fem::FunctionSpace>(
        fem::create_functionspace(functionspace_form_poisson_a, "u", msh));
```

### DOLFIN (C++)

First define the UFL form in the corresponding Python file (see DOLFINx case).
Then define the function space in C++.

```c++
#include "Poisson.h"
// ...
// `Poisson` is defined in "Poisson.h" which is compiled using FFC
auto V = std::make_shared<Poisson::FunctionSpace>(msh);
```

## Apply Dirichlet boundary conditions

Here we set the function $$u_\text{D}(x) = 1 + x^2 + 2y^2$$ as Dirichlet boundary condition on the entire boundary.

### DOLFINx (Python)

```python
msh.topology.create_connectivity(1, msh.topology.dim)
facets = mesh.exterior_facet_indices(msh.topology)

dofs = fem.locate_dofs_topological(V=V, entity_dim=1, entities=facets)

uD = fem.Function(V, dtype=ScalarType)
uD.interpolate(lambda x: 1 + x[0]**2 + 2 * x[1]**2)
bc = fem.dirichletbc(value=uD, dofs=dofs)
```

### DOLFIN (Python)

```python
class DirichletBoundary(SubDomain):
    def inside(self, x, on_boundary):
        return on_boundary
# ...
uD = Expression("1 + (pow(x[0], 2) + 2 * pow(x[1], 2)", degree=2)
bc = DirichletBC(V, uD, DirichletBoundary())
```

### DOLFINx (C++)

```c++
auto uD = std::make_shared<fem::Function<T>>(V);
uD->interpolate(
    [](auto x) -> std::pair<std::vector<T>, std::vector<std::size_t>>
    {
        std::vector<T> f;
        for (std::size_t p = 0; p < x.extent(1); ++p)
            f.push_back(1 + x(0, p) * x(0, p) + 2 * x(1, p) * x(1, p));
        return {f, {f.size()}};
    });
// ...
msh->topology_mutable().create_connectivity(1, 2);
const std::vector<std::int32_t> facets = mesh::exterior_facet_indices(msh->topology());
std::vector<std::int32_t> dofs = fem::locate_dofs_topological({*V}, 1, facets);
auto bc = std::make_shared<const fem::DirichletBC<T>>(uD, dofs);
```

### DOLFIN (C++)

```c++
class BoundaryValue : public Expression
{
    public:
        BoundaryValue() : Expression(2) {}
        void eval(Array<double>& values, const Array<double>& x) const
        {
            values[0] = 1 + pow(x[0], 2) + 2 * pow(x[1], 2);
        }
};
// ...
class DirichletBoundary : public SubDomain
{
    bool inside(const Array<double>& x, bool on_boundary) const
    {
       return on_boundary;
    }
};
// ...
auto dirichlet_boundary = std::make_shared<DirichletBoundary>();
auto uD = std::make_shared<BoundaryValue>);
DirichletBC bc(V, uD, dirichlet_boundary);
```

## Define a variational problem

The variational problem
$$
 \begin{align}
 a(u, v) &:= \int_{\Omega} \nabla u \cdot \nabla v \, {\rm d} x, \\
 L(v)    &:= \int_{\Omega} f v \, {\rm d} x + \int_{\Gamma_{N}} g v \, {\rm d} s.
\end{align}
$$
with
$g = \sin(5x)$
and
$f = 10\exp(-((x - 0.5)^2 + (y - 0.5)^2) / 0.02)$
can be expressed in UFL as follows:

### DOLFINx (Python)

```python
u = ufl.TrialFunction(V)
v = ufl.TestFunction(V)
x = ufl.SpatialCoordinate(msh)
f = 10 * ufl.exp(-((x[0] - 0.5) ** 2 + (x[1] - 0.5) ** 2) / 0.02)
g = ufl.sin(5 * x[0])
a = inner(grad(u), grad(v)) * dx
L = inner(f, v) * dx + inner(g, v) * ds
```

### DOLFIN (Python)

```python
u = TrialFunction(V)
v = TestFunction(V)
f = Expression("10*exp(-(pow(x[0] - 0.5, 2) + pow(x[1] - 0.5, 2)) / 0.02)", degree=2)
g = Expression("sin(5*x[0])", degree=2)
a = inner(grad(u), grad(v))*dx
L = inner(f, v) * dx + inner(g, v) * ds
```

### DOLFINx (C++)

The variational problem is defined in the UFL file as Python code.

### DOLFIN (C++)

The variational problem is defined in the UFL file as Python code.

## Solve a linear problem

### DOLFINx (Python)

```python
problem = fem.petsc.LinearProblem(a, L, bcs=[bc], petsc_options={"ksp_type": "preonly", "pc_type": "lu"})
uh = problem.solve()
```

### DOLFIN (Python)

```python
uh = Function(V)
solve(a == L, u, bc)
```

### DOLFINx (C++)

```c++
la::petsc::KrylovSolver lu(MPI_COMM_WORLD);
la::petsc::options::set("ksp_type", "preonly");
la::petsc::options::set("pc_type", "lu");
lu.set_from_options();

lu.set_operator(A.mat());
la::petsc::Vector _u(la::petsc::create_vector_wrap(*u.x()), false);
la::petsc::Vector _b(la::petsc::create_vector_wrap(b), false);
lu.solve(_u.vec(), _b.vec());
```

### DOLFIN (C++)

```c++
Function uh(V);
solve(a == L, uh, bc);
```

## Write the solution to a vtk file

### DOLFINx (Python)

```python
with io.XDMFFile(msh.comm, "solution.xdmf", "w") as file:
    file.write_mesh(msh)
    file.write_function(uh)
```

### DOLFIN (Python)

```python
file = File("solution.pvd")
file << uh
```

### DOLFINx (C++)

```c++
io::VTKFile file(MPI_COMM_WORLD, "solution.pvd", "w");
file.write<T>({uh}, 0.0);
```

### DOLFIN (C++)

```c++
File file("solution.pvd");
file << uh;
```

## Assemble the matrix and RHS vector

### DOLFINx (Python)

```python
A = fem.petsc.assemble_matrix(a)
A.assemble()
b = fem.petsc.assemble_vector(L)
bcs = [bc] # collect boundary conditions
fem.petsc.apply_lifting(b, [a], bcs=[bcs])
```

### DOLFIN (Python)

```python
bcs = [bc] # collect boundary conditions
A, b = assemble_system(a, L, bcs)
```

## Solver configuration

Here, we want to apply a CG solver without preconditioning.

### DOLFINx (Python)

```python
solver = PETSc.KSP().create(msh.comm)
solver.setOperators(A)
solver.setType(PETSc.KSP.Type.CG)
solver.getPC().setType(PETSc.PC.Type.NONE)
uh = Function(V)
# Note the swapped arguments compared to DOLFIN!
solver.solve(b, uh.vector)
```

### DOLFIN (Python)

```python
parameters["linear_algebra_backend"] = "PETSc"
# ...
solver = KrylovSolver(krylov_method, "cg")
solver.set_operator(A)
uh = Function(V)
# Note the swapped arguments compared to DOLFINx!
solver.solve(uh.vector(), b)
```
