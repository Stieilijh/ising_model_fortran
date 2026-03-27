module mod_observables_1d
   use mod_precision
   use mod_lattice_1d
   implicit none

contains

   function magnetization_1d(spin, L) result(m)
      integer(i4), intent(in) :: spin(:)
      integer(i4), intent(in) :: L
      real(dp) :: m
      integer(i4) :: i

      m = 0.0_dp

      do i = 1, L
         m = m + spin(i)
      end do

      m = m / real(L, dp)

   end function magnetization_1d


   function energy_1d(spin, L) result(e)
      integer(i4), intent(in) :: spin(:)
      integer(i4), intent(in) :: L
      real(dp) :: e
      integer(i4) :: i, right

      e = 0.0_dp

      do i = 1, L
         right = periodic_1d(i+1, L)
         e = e - spin(i) * spin(right)
      end do

      e = e / real(L, dp)

   end function energy_1d

end module mod_observables_1d
