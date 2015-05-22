# ——————————————— Program property ———————————————

EXE = example-use-fftw3
MKFLAGS = $(NULLSTRING)

# ——————————————— Variables of locations ———————————————

MODDIR = obj
SRCDIR = src
OBJDIR = obj

# _______________ Libraries and other folders __________

FFTW_INCLUDES  = -I${HOME}/usr/include
FFTW_LIBRARIES = -lfftw3 -lfftw3_threads -L${HOME}/usr/lib   -Wl,-rpath=${HOME}/usr/lib

# ——————————————— Fortran compiler ———————————————

FC = gfortran

# ——————————————— Compiling options ———————————————

FCFLAGS = -J$(MODDIR) -I$(MODDIR) $(FFTW_INCLUDES) -fdiagnostics-color=auto -O3 -march=native -fimplicit-none -ffree-line-length-none -ffast-math#-ffpe-trap=invalid,zero,overflow# -Wall -fcheck=all -g3 -fbacktrace
LDFLAGS = $(FFTW_LIBRARIES)

DEBUG = -Og -g -fimplicit-none -fbacktrace -pedantic -fwhole-file -Wline-truncation -Wcharacter-truncation -Wsurprising -Waliasing -fbounds-check -pg -frecursive -fcheck=all -Wall 
# -g turns on debugging
# -p turns on profiling
# -Wextra turns on extra warning. It is extremely verbose.
# -fcheck-array-temporaries -Warray-temporaries -Wconversion -Wimplicit-interface

OPTIM = #-O3 -march=native -mpc64  -fno-exceptions -ffast-math -funroll-loops -fstrict-aliasing
# FOR BACKUP : -march=native -O3 -ffast-math -funroll-loops   VERY AGRESSIVE
# -fopenmp for OPENMP support

# ——————————————— Files to compile ———————————————

FOBJ = $(OBJDIR)/main.o

# ——————————————— Global rules ———————————————

all: $(EXE)
	@ $(FC) $(FCFLAGS) $(MKFLAGS) -o $(EXE) $(FOBJ) $(LDFLAGS) && ./$(EXE)

clean:
	-@ rm -vf gmon.out $(EXE) $(MODDIR)/* $(OBJDIR)/* >/dev/null 2>/dev/null

# ——————————————— Pattern rules ———————————————

$(OBJDIR)/%.o : $(SRCDIR)/%.f90
	@ $(FC) $(FCFLAGS) $(MKFLAGS) -c $< -o $@

# For GNU make, *.f90 cannot be compiled automatically.

# ——————————————— Dependence rules ———————————————

$(EXE): $(FOBJ)

$(OBJDIR)/main.o:\
	$(SRCDIR)/main.f90
