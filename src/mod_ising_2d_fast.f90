module mod_ising_2d
   use mod_precision
   use mod_rng
   use omp_lib
   implicit none

contains

   subroutine metropolis_sweep_2d(spin, Lx, Ly, beta)

      integer(i4), intent(in) :: Lx, Ly
      integer(i4), intent(inout) :: spin(Lx,Ly)
      real(dp), intent(in) :: beta

      integer(i4) :: i, j
      integer(i4) :: left, right, up, down
      integer(i4) :: dE
      real(dp) :: r
      real(dp) :: w(-8:8)

      ! Precompute Boltzmann weights
      w(-8) = exp(8.0_dp*beta)
      w(-4) = exp(4.0_dp*beta)
      w(0)  = 1.0_dp
      w(4)  = exp(-4.0_dp*beta)
      w(8)  = exp(-8.0_dp*beta)

      ! ---------- RED SITES ----------
      !$omp parallel do private(i,j,left,right,up,down,dE,r) collapse(2)
      do j = 1, Ly
         do i = 1, Lx

            if (mod(i+j,2) == 0) then

               left  = modulo(i-2,Lx)+1
               right = modulo(i,  Lx)+1
               down  = modulo(j-2,Ly)+1
               up    = modulo(j,  Ly)+1

               dE = 2*spin(i,j)*( &
                  spin(left,j) + spin(right,j) + &
                  spin(i,down) + spin(i,up) )

               if (dE <= 0) then
                  spin(i,j) = -spin(i,j)
               else
                  r = rand_uniform()
                  if (r < w(dE)) spin(i,j) = -spin(i,j)
               end if

            end if

         end do
      end do
      !$omp end parallel do


      ! ---------- BLACK SITES ----------
      !$omp parallel do private(i,j,left,right,up,down,dE,r) collapse(2)
      do j = 1, Ly
         do i = 1, Lx

            if (mod(i+j,2) == 1) then

               left  = modulo(i-2,Lx)+1
               right = modulo(i,  Lx)+1
               down  = modulo(j-2,Ly)+1
               up    = modulo(j,  Ly)+1

               dE = 2*spin(i,j)*( &
                  spin(left,j) + spin(right,j) + &
                  spin(i,down) + spin(i,up) )

               if (dE <= 0) then
                  spin(i,j) = -spin(i,j)
               else
                  r = rand_uniform()
                  if (r < w(dE)) spin(i,j) = -spin(i,j)
               end if

            end if

         end do
      end do
      !$omp end parallel do

   end subroutine metropolis_sweep_2d

end module mod_ising_2d
