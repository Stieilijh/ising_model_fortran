module mod_simulation_1d
   use mod_precision
   use mod_rng
   use mod_lattice_1d
   use mod_ising_1d
   use mod_observables_1d
   implicit none

contains

   subroutine run_simulation_1d(L, beta, n_therm, n_steps, m_avg, e_avg)
      integer(i4), intent(in) :: L
      integer(i4), intent(in) :: n_therm, n_steps
      real(dp), intent(in) :: beta
      real(dp), intent(out) :: m_avg, e_avg

      integer(i4), allocatable :: spin(:)
      integer(i4) :: i, sweep
      real(dp) :: m, e

      call init_lattice_1d(spin, L)

      ! ---- Thermalization ----
      do sweep = 1, n_therm
         do i = 1, L ! Intial steps to reach equilibrium also 1 mc = L steps
            call metropolis_step(spin, L, beta)
         end do
      end do

      m_avg = 0.0_dp
      e_avg = 0.0_dp

      ! ---- Measurement ----
      do sweep = 1, n_steps
         do i = 1, L
            call metropolis_step(spin, L, beta)
         end do

         m = magnetization_1d(spin, L)
         e = energy_1d(spin, L)

         m_avg = m_avg + m
         e_avg = e_avg + e
      end do

      m_avg = m_avg / real(n_steps, dp)
      e_avg = e_avg / real(n_steps, dp)

   end subroutine run_simulation_1d

end module mod_simulation_1d
