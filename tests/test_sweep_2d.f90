program test_sweep_2d
   use mod_precision
   use mod_rng
   use mod_sweep_2d
   implicit none

   integer(i4) :: Lx, Ly, n_beta, n_therm, n_steps

   Lx = 128
   Ly = 128
   n_beta = 30
   n_therm = 1000
   n_steps = 2000

   call seed_rng(123)

   call temperature_sweep_2d(Lx, Ly, 0.2_dp, 0.7_dp, n_beta, &
      n_therm, n_steps, "data/ising_2d.dat")

end program test_sweep_2d
