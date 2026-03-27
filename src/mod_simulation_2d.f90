module mod_simulation_2d
   use mod_precision
   use mod_rng
   use mod_lattice_2d
   use mod_ising_2d
   use mod_observables_2d
   implicit none

contains

   subroutine run_simulation_2d(Lx, Ly, beta, n_therm, n_steps, &
      m_avg, e_avg, chi, Cv)

      integer(i4), intent(in) :: Lx, Ly
      integer(i4), intent(in) :: n_therm, n_steps
      real(dp), intent(in) :: beta
      real(dp), intent(out) :: m_avg, e_avg, chi, Cv

      integer(i4), allocatable :: spin(:,:)
      integer(i4) :: i, sweep
      real(dp) :: m, e
      real(dp) :: m2_avg, e2_avg

      call init_lattice_2d(spin, Lx, Ly)

      ! thermalization
      do sweep = 1, n_therm
         call metropolis_sweep_2d(spin,Lx,Ly,beta)
         !do i = 1, Lx*Ly
         !  call metropolis_step_2d(spin, Lx, Ly, beta)
         !end do
      end do

      m_avg = 0.0_dp
      e_avg = 0.0_dp
      m2_avg = 0.0_dp
      e2_avg = 0.0_dp

      ! measurement
      do sweep = 1, n_steps
         call metropolis_sweep_2d(spin,Lx,Ly,beta)
         !do i = 1, Lx*Ly
         !call metropolis_step_2d(spin, Lx, Ly, beta)
         !end do

         m = magnetization_2d(spin, Lx, Ly)
         e = energy_2d(spin, Lx, Ly)

         m_avg = m_avg + m
         e_avg = e_avg + e
         m2_avg = m2_avg + m*m
         e2_avg = e2_avg + e*e

      end do

      m_avg = m_avg / real(n_steps, dp)
      e_avg = e_avg / real(n_steps, dp)
      m2_avg = m2_avg / real(n_steps, dp)
      e2_avg = e2_avg / real(n_steps, dp)

      chi = beta * (m2_avg - m_avg*m_avg)
      Cv  = beta*beta * (e2_avg - e_avg*e_avg)

   end subroutine run_simulation_2d

end module mod_simulation_2d
