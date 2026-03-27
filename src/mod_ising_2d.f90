module mod_ising_2d
   use mod_precision
   use mod_rng
   use mod_lattice_2d
   implicit none

contains

   subroutine metropolis_step_2d(spin, Lx, Ly, beta)
      integer(i4), intent(in) :: Lx, Ly
      integer(i4), intent(inout) :: spin(:,:)
      real(dp), intent(in) :: beta

      integer(i4) :: i, j
      integer(i4) :: left, right, up, down
      real(dp) :: dE, r

      i = rand_int(Lx)
      j = rand_int(Ly)

      left  = periodic(i-1, Lx)
      right = periodic(i+1, Lx)
      down  = periodic(j-1, Ly)
      up    = periodic(j+1, Ly)

      dE = 2.0_dp * spin(i,j) * &
         ( spin(left,j) + spin(right,j) + &
         spin(i,down) + spin(i,up) )

      r = rand_uniform()

      if (dE <= 0.0_dp .or. r < exp(-beta*dE)) then
         spin(i,j) = -spin(i,j)
      end if

   end subroutine metropolis_step_2d

end module mod_ising_2d
