# Build the latest version of FEniCSx from source on an Ubuntu system:
# Install basics
sudo apt update
sudo apt install -y git python3-pip cmake
# Clone repositories
mkdir fenicsx
cd fenicsx
git clone https://github.com/FEniCS/dolfinx.git
git clone https://github.com/FEniCS/basix.git
git clone https://github.com/FEniCS/ufl.git
git clone https://github.com/FEniCS/ffcx.git
# Install dependencies
pip3 install numpy matplotlib pybind11 mpi4py
sudo apt install -y libblas-dev liblapack-dev petsc-dev libpugixml-dev libboost-all-dev pkg-config libparmetis-dev mpich libhdf5-mpi-dev python3-h5py-mpi
# Build basix
mkdir -p basix/cpp/build
cd basix/cpp/build
cmake ..
make install
cd ../..
pip install .
cd ..
# Build ufl
cd ufl
pip install .
cd ..
# Build ffcx
cd ffcx
pip install .
cd ..
# Build dolfinx
mkdir -p dolfinx/cpp/build
cd dolfinx/cpp/build
cmake ..
make install
cd ../../python
pip install .
cd ../..
# Install optional dependencies for the demos
pip3 install pyvista pyqt5 pyvistaqt numba gmsh slepc4py
