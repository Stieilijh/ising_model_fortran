program test_ising_2d
   use mod_precision
   use mod_rng
   use mod_lattice_2d
   use mod_ising_2d
   use mod_observables_2d
   implicit none

   integer(i4), allocatable :: spin(:,:)
   integer(i4) :: Lx, Ly, i
   real(dp) :: beta, m, e

   Lx = 20
   Ly = 20
   beta = 0.4_dp

   call seed_rng(1234)
   call init_lattice_2d(spin, Lx, Ly)

   do i = 1, Lx*Ly*10
      call metropolis_step_2d(spin, Lx, Ly, beta)
   end do

   m = magnetization_2d(spin, Lx, Ly)
   e = energy_2d(spin, Lx, Ly)

   print *, "Magnetization =", m
   print *, "Energy =", e

end program test_ising_2d
