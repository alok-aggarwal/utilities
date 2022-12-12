#include<stdio.h>
#include<string>
#include<unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <filesystem>
/*
 *
pos = 2	substr = /a
pos = 4	substr = /a/b
pos = 6	substr = /a/b/c

 
 *
 * */

#define SCAP_MAX_PATH_SIZE 4096

int main()
{
        std::string lower_dir = "/proc/1/root/var/lib/docker/overlay2/l/M3XJVCF23W53V2SBJ4YMLCLW6B";
        std::string path = "/bin/sleep";


	//e.g. path = /a/b/c/d
	//std::string eg_path = "/a/b/c/d/";
	//std::string eg_path = "";
	std::string eg_path = "/usr/local/man/";
	//std::string eg_path = "/usr/local/mylink/";
        //printf("test substr = %s\n", ts.c_str());

        std::string omit_last = path.substr(0, path.find_last_of('/'));

	std::size_t pos = 0, prev_pos = 0;
	std::filesystem::path resolved("/");
	std::filesystem::path partial_path(lower_dir);
	while (1)
	{
		prev_pos = pos;
		pos+=1;
		pos = eg_path.find('/', pos);
		
		if (pos == std::string::npos)
                {
                        break;
                }
		printf("prev_pos = %lu, pos = %lu\t", prev_pos, pos);
		auto s = eg_path.substr(prev_pos+1,pos-prev_pos-1);
		printf("substr = %s\n", s.c_str());
		std::filesystem::path dir(s);

		partial_path /= dir;
		printf("checking path %s\n", partial_path.c_str());
		if (std::filesystem::exists(partial_path))
		{
			if(std::filesystem::is_symlink(partial_path))
			{
				std::filesystem::path partial_resolved =
				    std::filesystem::read_symlink(partial_path);
				if (!partial_resolved.empty())
				{
					printf("resolved bfr append = %s, partial bfr append = %s", resolved.c_str(), partial_resolved.c_str());
					resolved /=partial_resolved;
				}
				else
				{
					printf("Cannot read link.\n");
					break;
				}
			}
			else
			{
				resolved /= dir;
			}
		}
		else
		{
			printf("path not present\n");
			//break;
		}
		usleep(1000000);
		printf("resolved = %s\n", resolved.c_str());
	}
	

	printf("resolved path = %s\n", resolved.c_str());
        
	
	
	/*printf("last omitted path = %s\n", omit_last.c_str());

        std::string add_back = omit_last.append(path.substr(path.find_last_of('/')));

        printf("added back path = %s\n", add_back.c_str());*/
}



/*
 *char buf[512];
int count = readlink("/x/y/d", buf, sizeof(buf));
if (count >= 0) {
    buf[count] = '\0';
    printf("%s -> %s\n", argv[1], buf);
}
In above code "d" path component should be the symlink. So you will have to iterate and resolve each path component.
 *
 * */
