#include<stdio.h>
#include<string>

int main()
{
	std::string full_path = "/var/lib/docker/overlay2/20defc50d3c2d3ddc34cadafe0313485bfc5996ad3f35d07a6632966d0f0d480/diff/usr/bin/sleep";
	std::string lower_dir = "/var/lib/docker/overlay2/20defc50d3c2d3ddc34cadafe0313485bfc5996ad3f35d07a6632966d0f0d480/diff";
	std::string path = full_path.substr(lower_dir.size());
	if (path.empty())
	{
		printf("drift_debug: detect_overlayfs: lower_dir not found");
		return 1;
	}
	printf("extracted path = %s\n", path.c_str());

	std::string omit_last = full_path.substr(0, full_path.find_last_of('/'));

	printf("last omitted path = %s\n", omit_last.c_str());

	std::string add_back = omit_last.append(full_path.substr(full_path.find_last_of('/')));

	printf("added back path = %s\n", add_back.c_str());
}
