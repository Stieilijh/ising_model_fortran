program test_rng
   use mod_precision
   use mod_rng
   implicit none

   integer(i4), parameter :: nbins = 20
   integer(i4), parameter :: nsamples = 1000000

   integer(i4) :: i, bin
   real(dp) :: r
   integer(i4) :: hist(nbins)
   call seed_rng(12345)
   hist = 0
   do i = 1, nsamples
      r = rand_uniform()
      bin = int(r * nbins) + 1
      if (bin > nbins) bin = nbins
      hist(bin) = hist(bin) + 1
   end do

   print *, "Bin   Probability"
   do i = 1, nbins
      print *, i, real(hist(i),dp) / nsamples
   end do

   print *, "Testing integer RNG"
   hist = 0

   do i = 1, nsamples
      bin = rand_int(nbins)
      hist(bin) = hist(bin) + 1
   end do

   do i = 1, nbins
      print *, i, real(hist(i),dp)/nsamples
   end do

end program test_rng
