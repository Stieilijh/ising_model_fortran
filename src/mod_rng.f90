module mod_rng
   use mod_precision
   use omp_lib
   implicit none

contains

   subroutine seed_rng(base_seed)
      integer(i4), intent(in) :: base_seed
      integer(i4) :: n, i, tid
      integer(i4), allocatable :: seed_array(:)

      call random_seed(size = n)
      allocate(seed_array(n))

      tid = omp_get_thread_num()

      do i = 1, n
         seed_array(i) = base_seed + 37*i + 1000*tid
      end do

      call random_seed(put = seed_array)
      deallocate(seed_array)

   end subroutine seed_rng


   function rand_uniform() result(r)
      real(dp) :: r
      call random_number(r)
   end function rand_uniform


   function rand_int(L) result(x)
      integer(i4), intent(in) :: L
      integer(i4) :: x
      real(dp) :: r

      call random_number(r)
      x = floor(r * L) + 1
   end function rand_int

end module mod_rng
