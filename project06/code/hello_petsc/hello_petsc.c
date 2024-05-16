static char help[] = "Hello world program with PETSc.\n\n";

// #include <petscerror.h>
#include <petscsys.h>

int main(int argc,char* argv[]) {

  // Initialize PETSc and MPI
  PetscCall(PetscInitialize(&argc, &argv, NULL, help));

  // Get MPI info
  PetscMPIInt size, rank, len;
  char pname[MPI_MAX_PROCESSOR_NAME];
  PetscCallMPI(MPI_Comm_size(PETSC_COMM_WORLD, &size));
  PetscCallMPI(MPI_Comm_rank(PETSC_COMM_WORLD, &rank));
  PetscCallMPI(MPI_Get_processor_name(pname, &len));

  // Report collected info
  PetscCall(PetscSynchronizedPrintf(PETSC_COMM_SELF,
                                    "Hello world from rank %d "
                                    "out of %d on %s\n",
                                    rank, size, pname));
  PetscCall(PetscSynchronizedFlush(PETSC_COMM_SELF, PETSC_STDOUT));

  // Finalize PETSc and MPI
  PetscCall(PetscFinalize());

  return 0;
}
