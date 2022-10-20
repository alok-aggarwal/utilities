#include <stdio.h>
#include <stdlib.h>
#include <functional>
namespace userspace_shared
{

class scope_guard
{
public:
	template<class GF>
	scope_guard(GF&& guard_func)
        try : m_guard_func(std::forward<GF>(guard_func))
	{
	}
	catch (...)
	{
		guard_func();
		throw;
	}

	// move from other
	scope_guard(scope_guard&& other) : m_guard_func(std::move(other.m_guard_func))
	{
		other.m_guard_func = nullptr;
	}

	// exec guard
	~scope_guard()
	{
		if (m_guard_func)
		{
			m_guard_func();  // must not throw
		}
	}

	// cancel guard
	void dismiss() noexcept { m_guard_func = nullptr; }

	// make it noncopyable
	scope_guard(const scope_guard&) = delete;
	void operator=(const scope_guard&) = delete;

private:
	std::function<void()> m_guard_func;
};
}  // namespace userspace_shared


void note_action_complete()
{
    printf("lambda called");
}


int main()
{
    printf("before\n");
    //demonstrate an action taken whenever the object action_complete_guard goes out of scope.
    userspace_shared::scope_guard action_complete_guard = [](){note_action_complete();};
    printf("after\n");
}
