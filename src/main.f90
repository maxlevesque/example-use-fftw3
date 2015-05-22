program main
    use iso_c_binding
    implicit none
    include "fftw3.f03" ! FFTW3 est une librairie. Voir www.fftw.org
    integer :: nx, nfft
    real(c_double), allocatable :: tablein(:,:,:)
    real(c_double) :: t0,t1
    complex(c_double), allocatable :: tableout(:,:,:)
    type(c_ptr) :: fftwplan
    integer :: i
    open(11,file='planingtime')
    open(10,file='ffttime')
    ! look at http://www.fftw.org/doc/Planner-Flags.html
    do nx=2,256
         allocate( tablein(nx,nx,nx), source=1._c_double )
         allocate( tableout(nx/2+1,nx,nx) )
         tablein = 1.
         tableout=cmplx(0.,0.)
         call cpu_time(t0)
         call dfftw_plan_dft_r2c_3d( fftwplan, nx, nx, nx, tablein, tableout, FFTW_ESTIMATE) 
         call cpu_time(t1)
         print*,"n=",nx
         print*,"It took me",t1-t0,"seconds to optimize FFTW3 to your hardware for this kind of real to complex."
         write(11,*) nx, t1-t0
         tablein = 0
         tableout = 0
         call cpu_time(t0)
         nfft = 10
         print*,"C'est parti pour",nfft," FFT de reel à complex de",nx,"^3"
         do i=1,nfft
             call dfftw_execute( fftwplan ) 
         end do
         call cpu_time(t1)
         deallocate( tablein )
         deallocate( tableout )
         print*,"It took me",t1-t0,"seconds to do a FFT real to complex of size",nx,"^3"
         print*,
         write(10,*) nx, (t1-t0)/real(nfft)
    end do
end program main
