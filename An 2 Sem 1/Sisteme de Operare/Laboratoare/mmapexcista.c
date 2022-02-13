#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

int main()
{
	int shm_fd = -1;
	shm_fd = shm_open("shm_lab5", O_RDWR, S_IRUSR | S_IWUSR);
	if(shm_fd < 0)
	{
		puts("Nu am gasit memoria partajata");
	}
	else
	{
		puts("Am gasit memoria partajata");
		shm_unlink("shm_lab5");
	}
	return 0;
}