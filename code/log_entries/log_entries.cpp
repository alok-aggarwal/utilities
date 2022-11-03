#include <string>
#include <vector>

	struct mount
	{
		std::string device;
		std::string mount_dir;
		std::string type;
		std::string opts;
	};


	std::vector<mount> m_mounts;

void log_container_mounts_parsed(const std::string& container_id)
{
		std::string str = "  " + container_id + ": { ";
		for (const auto& mnt : m_mounts)
		{
			str += mnt.device + ", " + mnt.mount_dir + ", " + mnt.type + ", " + mnt.opts + "\n";
		}
		str = str.substr(0, str.size() - 1) + " }";
		printf("\ndrift_debug log_container_mounts_parsed: mount list = %s", str.c_str());
}


int main()
{
int i = 0;
	for(i = 0; i < 15; i++) { 
	struct mount mount;
		mount.device = std::to_string(i);
		mount.mount_dir = std::to_string(i) + " dir";
		mount.type = std::to_string(i) + " type";
		mount.opts = std::to_string(i) + " opts" + "\0";

		m_mounts.emplace_back(std::move(mount));
	}

	log_container_mounts_parsed("abc123");

}
