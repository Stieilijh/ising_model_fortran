program test_sweep_file_1d
   use mod_precision
   use mod_rng
   use mod_sweep_1d
   implicit none

   integer(i4) :: L, n_beta, n_therm, n_steps

   L = 1000
   n_beta = 100
   n_therm = 1000
   n_steps = 2000

   call seed_rng(1234)

   call temperature_sweep_1d(L, 0.1_dp, 1.5_dp, n_beta, &
      n_therm, n_steps, "data/ising_1d.dat")

   print *, "Data written to data/ising_1d.dat"

end program test_sweep_file_1d
