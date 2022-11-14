#include<stdio.h>
#include<string>


int main()
{

		static const std::string overlay_str = "overlay";
		static const std::string upperdir_str = "upperdir=";
		static const std::string slash_str = "/";
		static const std::string comma_str = ",";
		std::string opts = "rw,relatime,lowerdir=/var/lib/docker/overlay2/l/4NL6BK73OUIYN5JS2QTSPPDK4D:/var/lib/docker/overlay2/l/NITVWV66JSSZHXH2DMQ4AZZUGE:/var/lib/docker/overlay2/l/MRTT4AHCDNP7DGJQBCOLSJXR36:/var/lib/docker/overlay2/l/FYXV4PZDHAXXQQGHL63NKZLRP5:/var/lib/docker/overlay2/l/TZHIHD5WXCPI5FINILSIPC4KG6:/var/lib/docker/overlay2/l/KD4E6SGVOHH3EKIIJ7RMHFOB7H:/var/lib/docker/overlay2/l/A3QKUM6DFKQJ6U6A3S5QYYB22J,upperdir=/var/lib/docker/overlay2/b75a872deb7c708fafb01f171efd50e16c03e8a06c148c410cf390e2704f9892/diff,workdir=/var/lib/docker/overlay2/b75a872deb7c708fafb01f171efd50e16c03e8a06c148c410cf390e2704f9892/work";
		
		printf("upper_dir string size = %lu\n", sizeof("/var/lib/docker/overlay2/b75a872deb7c708fafb01f171efd50e16c03e8a06c148c410cf390e2704f9892/diff"));
		
		std::size_t start =
		    opts.find(upperdir_str);
		if (start == std::string::npos)
		{
			printf("drift_debug: detect_overlayfs: upperdir start not found");
			return 0;
		}else
                {
                        printf("start = %lu\n", start);
                }

		
		printf("sizeof upperdir str = %lu, overlay_str = %s, using string size = %lu\n", sizeof(upperdir_str), overlay_str.c_str(), upperdir_str.size());
		start = start+upperdir_str.size();
		printf("start = %lu\n", start);
		
		std::size_t end = opts.find(comma_str, start);
		if (end == std::string::npos)
		{
			printf("drift_debug: detect_overlayfs: upperdir end not found");
			return 0;
		} else
		{
			printf("end = %lu\n", end);
		}
		std::string upper_dir = opts.substr(start,end-start);

		printf("upper_dir = %s\n", upper_dir.c_str());

		return 0;
}
