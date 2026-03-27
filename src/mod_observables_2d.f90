module mod_observables_2d
   use mod_precision
   use mod_lattice_2d
   implicit none

contains

   function magnetization_2d(spin, Lx, Ly) result(m)
      integer(i4), intent(in) :: spin(:,:)
      integer(i4), intent(in) :: Lx, Ly
      real(dp) :: m
      integer(i4) :: i, j

      m = 0.0_dp

      do i = 1, Lx
         do j = 1, Ly
            m = m + spin(i,j)
         end do
      end do

      m = m / real(Lx*Ly, dp)

   end function magnetization_2d


   function energy_2d(spin, Lx, Ly) result(e)
      integer(i4), intent(in) :: spin(:,:)
      integer(i4), intent(in) :: Lx, Ly
      real(dp) :: e
      integer(i4) :: i, j, right, up

      e = 0.0_dp

      do i = 1, Lx
         do j = 1, Ly

            right = periodic(i+1, Lx)
            up    = periodic(j+1, Ly)

            e = e - spin(i,j) * spin(right,j)
            e = e - spin(i,j) * spin(i,up)

         end do
      end do

      e = e / real(Lx*Ly, dp)

   end function energy_2d

end module mod_observables_2d
