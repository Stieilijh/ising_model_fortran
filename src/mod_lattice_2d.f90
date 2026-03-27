module mod_lattice_2d
   use mod_precision
   use mod_rng
   implicit none

contains

   subroutine init_lattice_2d(spin, Lx, Ly)
      integer(i4), intent(in) :: Lx, Ly
      integer(i4), allocatable, intent(out) :: spin(:,:)
      integer(i4) :: i, j

      allocate(spin(Lx, Ly))

      do i = 1, Lx
         do j = 1, Ly
            if (rand_uniform() < 0.5_dp) then
               spin(i,j) = 1
            else
               spin(i,j) = -1
            end if
         end do
      end do

   end subroutine init_lattice_2d


   function periodic(i, L) result(ip)
      integer(i4), intent(in) :: i, L
      integer(i4) :: ip
      ip = modulo(i-1, L) + 1
   end function periodic

end module mod_lattice_2d
