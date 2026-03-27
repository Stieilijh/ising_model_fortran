program test_simulation_1d
   use mod_precision
   use mod_rng
   use mod_simulation_1d
   implicit none

   integer(i4) :: L
   integer(i4) :: n_therm, n_steps
   real(dp) :: beta
   real(dp) :: m_avg, e_avg

   L = 50
   beta = 1.0_dp
   n_therm = 1000
   n_steps = 5000

   call seed_rng(123)

   call run_simulation_1d(L, beta, n_therm, n_steps, m_avg, e_avg)

   print *, "Average magnetization =", m_avg
   print *, "Average energy =", e_avg

end program test_simulation_1d
