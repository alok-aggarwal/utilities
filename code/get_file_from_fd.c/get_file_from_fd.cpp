#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <string>
#include <iostream>

void fcntl_wrap(int fd)
{
	char buf[4096];
	std::string path =
	   std::string("/proc/self/fd") + std::to_string(fd);

	int n = readlink(path.c_str(), buf, sizeof(buf));
	if (n < 0)
	{
		return;
	}

	if (n == sizeof(buf))
	{
		n--;
	}
	buf[n] = 0;
	std::cout << buf << std::endl;
}


int main()
{
        int fd = open("/tmp/abc", O_CREAT);
	fcntl_wrap(fd);
	return 0;
}

