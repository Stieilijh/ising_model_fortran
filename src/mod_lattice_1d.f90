module mod_lattice_1d
   use mod_precision
   use mod_rng
   implicit none

contains

   subroutine init_lattice_1d(spin_lattice, L)
      integer(i4), intent(in) :: L
      integer(i4), allocatable, intent(out) :: spin_lattice(:)
      integer(i4) :: i

      allocate(spin_lattice(L))

      do i = 1, L
         if (rand_uniform() < 0.5_dp) then
            spin_lattice(i) = 1
         else
            spin_lattice(i) = -1
         end if
      end do

   end subroutine init_lattice_1d


   function periodic_1d(i, L) result(ip)
      integer(i4), intent(in) :: i, L
      integer(i4) :: ip
      ip = modulo(i-1, L) + 1
   end function periodic_1d

end module mod_lattice_1d
