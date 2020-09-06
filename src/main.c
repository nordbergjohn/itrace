#include <stdio.h>
#include <sys/types.h>
#include <sys/ptrace.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <sys/reg.h>
#include <unistd.h>

static inline void printInstructionPointer(pid_t child)
{
  struct user_regs_struct regs;
  ptrace(PTRACE_GETREGS, child, NULL, &regs);
#ifdef __x86_64__
  printf("%llx\n", regs.rip);
#else
  printf("%lx\n", regs.eip);
#endif
}

int main(int argc, char **argv)
{
  if (argc < 2)
  {
    fprintf(stderr, "No program specified\n");
    return -1; 
  }

  pid_t child = fork();

  if (child == 0)
  {
    // child process
    char* prog = argv[1];
    ptrace(PTRACE_TRACEME, 0, NULL, NULL);
    execvp(prog, &argv[2]);
  }
  else
  {
    // Parent process
    int status;
    while(1)
    {
      wait(&status);
      if(WIFEXITED(status))
        break; 
      printInstructionPointer(child);
      ptrace(PTRACE_SINGLESTEP, child, NULL, NULL);
    }
  }

  return 0;
}

