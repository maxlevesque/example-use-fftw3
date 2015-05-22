program main
    use iso_c_binding
    implicit none
    include "fftw3.f03" ! FFTW3 est une librairie. Voir www.fftw.org
    integer :: nx, nfft
    integer, parameter :: nxmax=256
    integer, parameter :: mykind=c_double
    real(mykind), pointer, contiguous :: tablein(:,:,:)
    real(c_double) :: t0,t1
    complex(mykind), pointer, contiguous :: tableout(:,:,:)
    type(c_ptr) :: fftwplan
    real(mykind), target :: bigin(nxmax,nxmax,nxmax)
    complex(mykind), target :: bigout(nxmax,nxmax,nxmax)
    integer :: i
    open(11,file='planingtime')
    open(10,file='ffttime')
    ! look at http://www.fftw.org/doc/Planner-Flags.html
    do nx=2,nxmax ! size of the fft in each direction
        print*,"n=",nx ! size of the fft in each direction
        tablein => bigin(1:nx,1:nx,1:nx)
        tableout => bigout(1:nx,1:nx,1:nx)
        tablein = 0.
        tableout=cmplx(0.,0.)
        call cpu_time(t0) ! timing the planer
        call dfftw_plan_dft_r2c_3d( fftwplan, nx, nx, nx, tablein, tableout, FFTW_ESTIMATE) ! see http://www.fftw.org/doc/Planner-Flags.html
        call cpu_time(t1)
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
        print*,"It took me",(t1-t0)/real(nfft,c_double),"seconds per FFT real to complex of size",nx,"^3"
        print*,
        write(10,*) nx, (t1-t0)/real(nfft,c_double)
        call dfftw_destroy_plan( fftwplan )
    end do
end program main
