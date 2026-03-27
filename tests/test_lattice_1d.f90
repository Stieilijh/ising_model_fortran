program test_lattice_1d
   use mod_precision
   use mod_rng
   use mod_lattice_1d
   implicit none

   integer(i4), allocatable :: spin_lattice(:)
   integer(i4) :: L

   L = 10

   call seed_rng(42)
   call init_lattice_1d(spin_lattice, L)

   print *, "Spin chain:"
   print *, spin_lattice

   print *, "Periodic test:"
   print *, periodic_1d(0, L),"<----- should be 10(L)"
   print *, periodic_1d(L+1, L),"<----- should be 1(L+1)"

end program test_lattice_1d
