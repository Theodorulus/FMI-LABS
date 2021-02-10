#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
    int fd1, fd2;
	char *text = (char *) calloc(50, sizeof(char));
	int n;
	
	fd1 = open(argv[1], O_RDONLY);
	fd2 = open(argv[2], O_CREAT|O_WRONLY);
	
    if(fd1 < 0 || fd2 < 0)
	{
        perror("file problem");
        exit(1);
    }
	
	n = read(fd1, text, 50);
	text[n] = '\0';
	
    write(fd2, text, n);
	
    close(fd1);
    close(fd2);
}
