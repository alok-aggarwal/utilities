
#include "Poco/LRUCache.h"
#include "Poco/SharedPtr.h"

namespace drift_cache
{
class ContainerDriftLRUCache
{
private:
	Poco::LRUCache<std::string, int> m_cache;

public:
	ContainerDriftLRUCache(const int cacheSize) : m_cache(cacheSize) {}

	int Get(std::string key)
	{
		int* value = m_cache.get(key);
		return value == nullptr ? 0 : *value;
	}

	bool Has(std::string key) { return m_cache.has(key); }

	void Put(std::string key, int value) { m_cache.add(key, value); }

	int Size() { return m_cache.size(); }
};
}  // namespace drift_cache



int main()
{

	drift_cache::ContainerDriftLRUCache* m_lru_verdicts =
	    new drift_cache::ContainerDriftLRUCache(10);

	printf("Cache Size = %d", m_lru_verdicts->Size());






	delete m_lru_verdicts;

}
