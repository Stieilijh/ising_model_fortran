# 2D Ising Model Simulation in Fortran

This repository contains a high-performance Fortran implementation of the 2D Ising model using Markov Chain Monte Carlo (MCMC) methods. It is designed to simulate ferromagnetic phase transitions, calculate macroscopic thermodynamic observables, and generate physical data for Python-based visualization.

## 1. Mathematical Foundation

The Ising model describes magnetic dipole moments of atomic spins that can occupy one of two states: s_i ∈ {+1, -1}. The total energy (Hamiltonian) of a specific spin configuration on a 2D square lattice is given by:

H = -J _ Σ(s_i _ s_j) - h \* Σ(s_i)

Where:

- J is the exchange coupling constant (J > 0 for ferromagnetic interactions).
- The first summation runs over nearest-neighbor pairs <i,j> only.
- h represents the external magnetic field.

The probability of the system occupying a microstate μ at thermal equilibrium is governed by the Boltzmann weight, P(μ) ∝ exp(-H(μ) / (k_B \* T)). From this, the macroscopic thermodynamic observables are calculated as statistical ensemble averages:

- Energy: <E> = Σ H(μ) \* P(μ)
- Magnetization: <M> = (1/N) \* <|Σ s_i|>
- Specific Heat: C_V = (1 / (k_B _ T^2)) _ (<E^2> - <E>^2)
- Susceptibility: χ = (1 / (k_B _ T)) _ (<M^2> - <M>^2)

## 2. Algorithm: Metropolis-Hastings

Computing the exact partition function is computationally intractable (2^N operations) for macroscopic lattices. This code utilizes the Metropolis-Hastings algorithm to sample the phase space efficiently.

**Simulation Steps:**

1. **Initialization:** Assign a spin state (s_i = ±1) to each site on an L × L grid.
2. **Selection:** Select a random lattice site using a robust Pseudo-Random Number Generator (PRNG).
3. **Trial Flip:** Calculate the change in energy, ΔE, if the selected spin were flipped. For nearest-neighbor interactions, this is an O(1) operation:
   ΔE = 2 _ J _ s_i \* Σ(s_j)
4. **Acceptance Criteria:**
   - If ΔE ≤ 0: Accept the flip immediately.
   - If ΔE > 0: Generate a uniform random number r ∈ [0, 1). Accept the flip only if r < exp(-ΔE / (k_B \* T)).
5. **Iteration:** Repeat steps 2-4 for N = L^2 times to complete one full Monte Carlo Sweep (MCS).
6. **Measurement:** Discard initial sweeps for thermal equilibration, then sample configurations at fixed intervals to calculate C_V and χ.

## 3. Repository Structure

| Directory / File | Description                                                                     |
| :--------------- | :------------------------------------------------------------------------------ |
| `src/`           | Contains the core Fortran source files (`.f90` or `.f`).                        |
| `tests/`         | Sub-programs to unit-test specific Fortran modules and math routines.           |
| `bin/`           | Stores the compiled executable after running the Makefile.                      |
| `obj/`           | Stores intermediate object files (`.o`) and module dependencies (`.mod`).       |
| `data/`          | Default output path for simulated raw data files (`.dat`).                      |
| `graphs/`        | Designated folder for Python-generated visual plots.                            |
| `Makefile`       | Automates compilation, dependency tracking, and linking.                        |
| `plot.py`        | Python script (using NumPy/Matplotlib) to parse data and visualize observables. |

## 4. Compilation and Usage

**Step 1: Clone the repository**

```bash
git clone [https://github.com/Stieilijh/ising_model_fortran.git](https://github.com/Stieilijh/ising_model_fortran.git)
cd ising_model_fortran
```

**Step 2: Build the executable**
Execute the Makefile to systematically compile the code using `gfortran`.

```bash
make
```

**Step 3: Run the simulation**
Execute the binary to start the MCMC run.

```bash
./bin/test_sweep_2d_fast.o
```

_The simulation will export raw arrays to the `data/` directory._

**Step 4: Data Visualization**
Ensure you have the required Python libraries installed (`pip install numpy matplotlib`), then run the plotting utility:

```bash
python plot.py
```

_This will read the output arrays and export thermodynamic graphs to `graphs/`._

## 5. Critical Phenomena & Exact Solutions

The 2D square lattice Ising model (at h=0) was analytically solved by Lars Onsager. The continuous phase transition occurs exactly at the critical temperature T_c:

(k_B \* T_c) / J = 2 / ln(1 + √2) ≈ 2.269

In the immediate vicinity of T_c, thermodynamic observables exhibit power-law singularities governed by universal critical exponents. As you scale up the lattice size L in the simulation, finite-size scaling should yield behaviors approaching these exact 2D exponents:

| Observable             | Power Law near T_c (Reduced temp: t) | Exact 2D Exponent |
| :--------------------- | :----------------------------------- | :---------------- | ----- | ------------------------------ |
| Specific Heat (C_V)    | C_V ∝                                | t                 | ^(-α) | α = 0 (logarithmic divergence) |
| Magnetization (M)      | M ∝ (-t)^β for T < T_c               | β = 1/8 = 0.125   |
| Susceptibility (χ)     | χ ∝                                  | t                 | ^(-γ) | γ = 7/4 = 1.75                 |
| Correlation Length (ξ) | ξ ∝                                  | t                 | ^(-ν) | ν = 1                          |

When checking your generated graphs, look for the sharp divergences in C_V and χ around β ≈ 0.44 .
