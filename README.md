# 2D Ising Model Simulation in Fortran

This repository contains a high-performance Fortran implementation of the 2D Ising model using Monte Carlo methods. It is designed to simulate ferromagnetic phase transitions, calculate thermodynamic observables, and generate physical data that can be efficiently visualized using Python.

## 1. Mathematical Foundation

The Ising model describes magnetic dipole moments of atomic spins that can be in one of two states: $s_i \in \{+1, -1\}$. The energy of a given configuration of spins on a 2D square lattice is determined by the Hamiltonian:

$$\mathcal{H} = -J \sum_{\langle i,j \rangle} s_i s_j - h \sum_i s_i$$

where:
* $J$ is the exchange coupling constant ($J > 0$ denotes a ferromagnetic interaction).
* $\langle i,j \rangle$ indicates summation over nearest neighbors only to prevent double counting.
* $h$ represents the external magnetic field.

The probability of the system occupying a specific microstate $\mu$ in thermal equilibrium at a given temperature $T$ is governed by the Boltzmann distribution:

$$P(\mu) = \frac{1}{\mathcal{Z}} e^{-\beta \mathcal{H}(\mu)}$$

where $\beta = \frac{1}{k_B T}$ and $\mathcal{Z}$ is the canonical partition function, $\mathcal{Z} = \sum_{\{\mu\}} e^{-\beta \mathcal{H}(\mu)}$.

From this framework, the macroscopic thermodynamic observables can be calculated as statistical averages and fluctuations around the mean energy $E$ and magnetization $M$:

$$\langle E \rangle = \frac{1}{\mathcal{Z}} \sum_{\{\mu\}} \mathcal{H}(\mu) e^{-\beta \mathcal{H}(\mu)}$$
$$\langle M \rangle = \frac{1}{N} \langle \left| \sum_i s_i \right| \rangle$$
$$C_V = \frac{\partial \langle E \rangle}{\partial T} = \frac{1}{k_B T^2} (\langle E^2 \rangle - \langle E \rangle^2)$$
$$\chi = \frac{\partial \langle M \rangle}{\partial h} = \frac{1}{k_B T} (\langle M^2 \rangle - \langle M \rangle^2)$$

## 2. Algorithm: Metropolis-Hastings

Since computing $\mathcal{Z}$ directly involves $2^N$ operations (which is computationally intractable for any reasonably sized macroscopic lattice), this Fortran code evaluates the system space using Markov Chain Monte Carlo (MCMC) sampling with the Metropolis-Hastings algorithm.

**Step-by-step update mechanism:**
1.  **Initialization:** Assign a spin $s_i = \pm 1$ to each site on an $L \times L$ grid. This can be initialized uniformly for a $T=0$ (ground state) start or randomly for a $T=\infty$ start.
2.  **Selection:** Select a random lattice site $i$ using a high-quality Pseudo-Random Number Generator (PRNG). *Note: The statistical rigor of the PRNG (e.g., PCG or Mersenne Twister) is critical here. Poor random number generation can introduce artificial correlations that distort scaling laws near the critical temperature.*
3.  **Trial Flip:** Calculate the change in energy, $\Delta E$, if the spin $s_i$ were to be flipped ($s_i \to -s_i$). Because the Hamiltonian only considers local nearest-neighbor interactions, this evaluation is an $O(1)$ operation:
    $$\Delta E = 2J s_i \sum_{\text{neighbors } j} s_j$$
4.  **Acceptance/Rejection:**
    * If $\Delta E \le 0$, the system naturally favors this lower energy state, and the flip is accepted immediately.
    * If $\Delta E > 0$, the flip is accepted probabilistically to simulate thermal fluctuations. A uniformly distributed random number $r \in [0, 1)$ is generated. If $r < e^{-\beta \Delta E}$, the flip is accepted; otherwise, it is rejected.
5.  **Iteration:** Repeat steps 2-4 for $N = L^2$ times to complete one full Monte Carlo Sweep (MCS).
6.  **Measurement:** Discard the initial fraction of sweeps to allow the system to reach thermal equilibration. After equilibration, sample the lattice configurations at fixed intervals to calculate the ensemble averages for $E, M, C_V,$ and $\chi$.

## 3. Repository Structure

The project is structured following standard compiled-language conventions to separate source code from binaries and data.

| Directory / File | Description |
| :--- | :--- |
| `src/` | Contains the core Fortran source files (`.f90` or `.f`). |
| `tests/` | Sub-programs to unit-test specific Fortran modules and math routines. |
| `bin/` | Stores the compiled executable after executing the Makefile. |
| `obj/` | Stores intermediate object files (`.o`) and module dependencies (`.mod`). |
| `data/` | The default output path for simulated raw data files (e.g., `.dat`). |
| `graphs/` | The designated folder where Python saves the generated visual plots. |
| `Makefile` | Automates the dependency tracking, compilation, and linking processes. |
| `plot.py` | Python script relying on `numpy` and `matplotlib` to parse the `data/` files and visualize the physical observables. |

## 4. Compilation and Usage

**Step 1: Clone the repository**
```bash
git clone [https://github.com/Stieilijh/ising_model_fortran.git](https://github.com/Stieilijh/ising_model_fortran.git)
cd ising_model_fortran
