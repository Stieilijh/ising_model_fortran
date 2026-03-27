# Compiler
FC = gfortran

# Flags
FFLAGS = -O3 -fopenmp -Jobj -Iobj
DBGFLAGS = -g -fcheck=all -Wall -fopenmp -Jobj -Iobj

# Folders
SRC = src
OBJ = obj
BIN = bin
TEST = tests

# ---------- COMMON MODULES ----------
COMMON = \
$(OBJ)/mod_precision.o \
$(OBJ)/mod_rng.o

# ---------- 1D MODULES ----------
MOD1D = \
$(OBJ)/mod_lattice_1d.o \
$(OBJ)/mod_ising_1d.o \
$(OBJ)/mod_observables_1d.o \
$(OBJ)/mod_simulation_1d.o \
$(OBJ)/mod_sweep_1d.o

# ---------- 2D MODULES ----------
MOD2D = \
$(OBJ)/mod_lattice_2d.o \
$(OBJ)/mod_ising_2d.o \
$(OBJ)/mod_observables_2d.o \
$(OBJ)/mod_simulation_2d.o \
$(OBJ)/mod_sweep_2d.o

# ---------- BUILD RULE ----------
$(OBJ)/%.o: $(SRC)/%.f90
	$(FC) $(FFLAGS) -c $< -o $@

# ---------- 1D TEST ----------
test1d: $(COMMON) $(MOD1D) $(TEST)/test_sweep_1d.f90
	$(FC) $(FFLAGS) $^ -o $(BIN)/test_sweep_1d.out

# ---------- 2D TEST ----------
test2d: $(COMMON) $(MOD2D) $(TEST)/test_sweep_2d.f90
	$(FC) $(FFLAGS) $^ -o $(BIN)/test_sweep_2d.out

# ---------- DEBUG 2D ----------
debug2d: $(COMMON) $(MOD2D) $(TEST)/test_sweep_2d.f90
	$(FC) $(DBGFLAGS) $^ -o $(BIN)/test_sweep_2d_debug.out

# ---------- RNG TEST ----------
testrng: $(COMMON) $(TEST)/test_rng.f90
	$(FC) $(FFLAGS) $^ -o $(BIN)/test_rng.out

# ---------- LATTICE TEST ----------
testlattice1d: $(COMMON) $(OBJ)/mod_lattice_1d.o $(TEST)/test_lattice_1d.f90
	$(FC) $(FFLAGS) $^ -o $(BIN)/test_lattice_1d.out

testlattice2d: $(COMMON) $(OBJ)/mod_lattice_2d.o $(TEST)/test_lattice_2d.f90
	$(FC) $(FFLAGS) $^ -o $(BIN)/test_lattice_2d.out

# ---------- CLEAN ----------
clean:
	rm -f $(OBJ)/*.o $(OBJ)/*.mod $(BIN)/*
