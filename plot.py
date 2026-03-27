import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt(
    "/home/gopalkrishna/tushar_data/code/fortran/monte_carlo_simulations/ising_model_fortran/data/ising_2d.dat")

beta = data[:, 0]
m = np.abs(data[:, 1])
e = data[:, 2]
chi = data[:, 3]
Cv = data[:, 4]

plt.figure(figsize=(10, 8))

plt.subplot(2, 2, 1)
plt.plot(beta, m, marker='o')
plt.xlabel(r'$\beta$')
plt.ylabel('Magnetization')

plt.subplot(2, 2, 2)
plt.plot(beta, e, marker='o')
plt.xlabel(r'$\beta$')
plt.ylabel('Energy')

plt.subplot(2, 2, 3)
plt.plot(beta, chi, marker='o')
plt.xlabel(r'$\beta$')
plt.ylabel('Susceptibility')

plt.subplot(2, 2, 4)
plt.plot(beta, Cv, marker='o')
plt.xlabel(r'$\beta$')
plt.ylabel('Heat Capacity')

plt.tight_layout()

for ax in plt.gcf().axes:
    ax.axvline(0.440686, linestyle='--')
plt.show()
