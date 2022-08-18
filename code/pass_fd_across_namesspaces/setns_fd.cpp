#include <sched.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
	int err = 0, dirfd, fd, host_mnt_fd, container_mnt_fd;
	
	host_mnt_fd = open("/proc/1/ns/mnt", O_RDONLY);
	printf("host_mnt_fd = %d\n", host_mnt_fd);

	err = setns(host_mnt_fd, CLONE_NEWNS);
	if (err< 0) 
	{
		perror("\n Error: switching mount ns to host failed");
	}
	else
	{
		printf("setns to host successful\n");
		unlink("/setns_exp/tmpfile");
	}

	dirfd = open("/setns_exp", O_PATH);

	container_mnt_fd = open("/proc/self/ns/mnt", O_RDONLY);
	printf("container__mnt_fd = %d\n", container_mnt_fd);

	//Confirm that host mnt fd and container mnt fd are different
	if (host_mnt_fd == container_mnt_fd)
	{
		printf("failure: container and host mount fds are same");
		return 1;
	}

	err = setns(container_mnt_fd, CLONE_NEWNS);
	if (err< 0) 
	{
		perror("\n Error: switching mount ns back to container failed");
	}
	else
	{
		printf("setns to container successful\n");
	}

    	fd = openat(dirfd, "tmpfile", O_CREAT, S_IXUSR);
	if (fd>0)
	{
		printf("creating file in host ns successful\n");
	}
	else
	{
		perror("creating file in host ns not successful");
	}
	
	close(fd);
    	close(dirfd);

}
