#include <iostream>
#include <chrono>
#include <iomanip>
#include <stdlib.h>
#include <stdio.h>
#include <mntent.h>

#define SCAP_MAX_PATH_SIZE 1024

void test(const std::string& s)
{
    FILE* mounts_fp = setmntent(s.c_str(), "r");
}

int main() {
    uint64_t pid = 123456789;

    auto start = std::chrono::system_clock::now();
    for (int i = 0; i < 1000000; i++)
    {
        char mounts_file[SCAP_MAX_PATH_SIZE];
        snprintf(mounts_file, sizeof(mounts_file), "/proc/%ul/mounts", i);
        std::string s(mounts_file);
        test(s);
    }

    auto end = std::chrono::system_clock::now();
    std::chrono::duration<double> diff = end - start;
    std::cout << "Time to run with buff: " << std::setw(9) << diff.count() << " s\n";

    start = std::chrono::system_clock::now();
    for (int i = 0; i < 1000000; i++)
    {
        std::string s;
        //s.reserve(128);
        s.append("/proc/").append(std::to_string(i)).append("/mounts");
        test(s);
    }

    end = std::chrono::system_clock::now();
    diff = end - start;
    std::cout << "Time to run with string:" << std::setw(9) << diff.count() << " s\n";

    return 0;
}
