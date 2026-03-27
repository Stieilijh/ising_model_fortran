module mod_sweep_2d
   use mod_precision
   use mod_simulation_2d
   use mod_rng
   use omp_lib
   implicit none

contains

   subroutine temperature_sweep_2d(Lx, Ly, beta_min, beta_max, n_beta, &
      n_therm, n_steps, filename)

      integer(i4), intent(in) :: Lx, Ly, n_beta, n_therm, n_steps
      real(dp), intent(in) :: beta_min, beta_max
      character(len=*), intent(in) :: filename

      integer(i4) :: i, unit
      real(dp) :: beta, m_avg, e_avg, dbeta

      real(dp), allocatable :: beta_vals(:)
      real(dp), allocatable :: m_vals(:)
      real(dp), allocatable :: e_vals(:)

      allocate(beta_vals(n_beta))
      allocate(m_vals(n_beta))
      allocate(e_vals(n_beta))

      dbeta = (beta_max - beta_min) / real(n_beta-1, dp)

      !$omp parallel do private(i, beta, m_avg, e_avg) schedule(dynamic)
      do i = 1, n_beta

         call seed_rng(1234)

         beta = beta_min + (i-1)*dbeta

         call run_simulation_2d(Lx, Ly, beta, n_therm, n_steps, m_avg, e_avg)

         beta_vals(i) = beta
         m_vals(i) = m_avg
         e_vals(i) = e_avg

      end do
      !$omp end parallel do

      unit = 10
      open(unit=unit, file=filename, status="replace", action="write")

      write(unit,*) "# beta   magnetization   energy"

      do i = 1, n_beta
         write(unit,*) beta_vals(i), m_vals(i), e_vals(i)
      end do

      close(unit)

   end subroutine temperature_sweep_2d

end module mod_sweep_2d
