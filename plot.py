import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt(
    "/home/gopalkrishna/tushar_data/code/fortran/monte_carlo_simulations/ising_model_fortran/data/ising_2d.dat")
beta, m, e = data.T

plt.plot(beta, m)
plt.xlabel("beta")
plt.ylabel("magnetization")
plt.show()
