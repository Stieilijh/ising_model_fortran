module mod_ising_1d
   use mod_precision
   use mod_rng
   use mod_lattice_1d
   implicit none

contains

   subroutine metropolis_step(spin, L, beta)
      integer(i4), intent(in) :: L
      integer(i4), intent(inout) :: spin(:)
      real(dp), intent(in) :: beta

      integer(i4) :: i, left, right
      real(dp) :: dE, r

      ! choose random site
      i = rand_int(L)

      left  = periodic_1d(i-1, L)
      right = periodic_1d(i+1, L)

      ! ΔE = 2 s_i (s_left + s_right)
      dE = 2.0_dp * spin(i) * (spin(left) + spin(right))

      call random_number(r)

      if (dE <= 0.0_dp .or. r < exp(-beta * dE)) then
         spin(i) = -spin(i)
      end if

   end subroutine metropolis_step

end module mod_ising_1d
