#include <stdio.h>
#include <unistd.h>
int main(){
	pid_t pid = fork(); // get forked
	if (!pid) { // pid == 0
		// u r child
		printf("process %d\t exits in 3 seconds:\n",getpid());
		sleep(3);
		printf("child process kill\n"); _exit(0);
	} else if (pid > 0) {
		printf("get child %d\t from %d\t\n",pid,getpid());
		printf("parent never stops itself\n");
		while(1) sleep(1);
	} else { // pid < 0
		perror("fork: fail, exiting\n"); return pid;
	}
	return 0; // PROCESS_EXIT_OK
}
