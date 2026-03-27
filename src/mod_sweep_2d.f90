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
      real(dp) :: beta, m_avg, e_avg, chi, Cv, dbeta

      real(dp), allocatable :: beta_vals(:)
      real(dp), allocatable :: m_vals(:)
      real(dp), allocatable :: e_vals(:)
      real(dp), allocatable :: chi_vals(:)
      real(dp), allocatable :: Cv_vals(:)

      allocate(beta_vals(n_beta))
      allocate(m_vals(n_beta))
      allocate(e_vals(n_beta))
      allocate(chi_vals(n_beta))
      allocate(Cv_vals(n_beta))

      dbeta = (beta_max - beta_min) / real(n_beta-1, dp)

      !$omp parallel do private(i, beta, m_avg, e_avg, chi, Cv) schedule(dynamic)
      do i = 1, n_beta

         call seed_rng(1234)

         beta = beta_min + (i-1)*dbeta

         call run_simulation_2d(Lx, Ly, beta, n_therm, n_steps, &
            m_avg, e_avg, chi, Cv)

         beta_vals(i) = beta
         m_vals(i) = m_avg
         e_vals(i) = e_avg
         chi_vals(i) = chi
         Cv_vals(i) = Cv

      end do
      !$omp end parallel do

      unit = 10
      open(unit=unit, file=filename, status="replace", action="write")

      write(unit,*) "# beta  m  e  chi  Cv"

      do i = 1, n_beta
         write(unit,*) beta_vals(i), m_vals(i), e_vals(i), &
            chi_vals(i), Cv_vals(i)
      end do

      close(unit)

   end subroutine temperature_sweep_2d

end module mod_sweep_2d
