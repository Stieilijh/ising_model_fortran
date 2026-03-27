program test_observables_1d
   use mod_precision
   use mod_rng
   use mod_lattice_1d
   use mod_observables_1d
   implicit none

   integer(i4), allocatable :: spin(:)
   integer(i4) :: L
   real(dp) :: m, e

   L = 10

   call seed_rng(123)
   call init_lattice_1d(spin, L)

   print *, "Spins:"
   print *, spin

   m = magnetization_1d(spin, L)
   e = energy_1d(spin, L)

   print *, "Magnetization =", m
   print *, "Energy =", e

end program test_observables_1d
