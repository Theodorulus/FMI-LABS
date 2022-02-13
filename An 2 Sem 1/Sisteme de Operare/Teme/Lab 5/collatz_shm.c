#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
	printf("Starting parent %d\n", getpid());
	int shm_fd;
	char shm_name[] = "collatz";
	pid_t pid;
	unsigned int offset = 0;
	size_t shm_size = getpagesize() * (argc - 1);
	shm_fd = shm_open(shm_name, O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
	if(shm_fd < 0)
	{
		perror("fork");
		exit(1);
	}
	ftruncate(shm_fd, shm_size);
	for(int i = 1; i < argc; i ++)
	{
		pid = fork();
		if(pid < 0)
		{
			perror("fork");
			exit(1);
		}
		else if(pid == 0)
		{
			// Copil
			int x = atoi(argv[i]);
			char *shm_ptr_child = mmap(0, getpagesize(), PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, (i - 1) * getpagesize());
			if(shm_ptr_child == MAP_FAILED)
			{
				shm_unlink(shm_name);
				exit(1);
			}
			offset = sprintf(shm_ptr_child, "%d : %d ", x, x);
			shm_ptr_child += offset;
			while(x != 1)
			{
				if(x % 2== 0)
					x /= 2;
				else
					x = 3 * x + 1;
				offset = sprintf(shm_ptr_child, "%d ", x);
				shm_ptr_child += offset;
			}
			munmap(shm_ptr_child, getpagesize());
			printf("Done Parent: %d Me: %d \n", getppid(), getpid());
			exit(0);
		}
		else
		{
			//Parinte
			wait(NULL);
		}
	}
	for(int i = 0; i < argc - 1; i++)
	{
		char *shm_ptr = mmap(0, getpagesize(), PROT_READ, MAP_SHARED, shm_fd, i * getpagesize());
		printf("%s\n", shm_ptr);
		munmap(shm_ptr, getpagesize());
	}
	shm_unlink(shm_name);
	printf("\nDone Parent: %d Me: %d \n", getppid(), getpid());
	return 0;
}