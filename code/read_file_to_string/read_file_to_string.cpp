#include <fstream>
#include <iostream>
#include <sstream> //std::stringstream
void func() {


    std::ifstream inFile("test.txt");
    //inFile.open("test.txt"); //open the input file

    std::stringstream strStream;
    std::string str;
    while(std::getline(inFile, str))
    {
	strStream << str << ' ';
    }
    //strStream << inFile.rdbuf(); //read the file
    std::string str_out = strStream.str(); //str holds the content of the file

    //printf("string = %s", str_out.c_str());
    //std::cout << str_out << "\n"; //you can do anything with the string!!!
}


int main()
{
    int i = 0;
    for (i; i < 100000; i++) //call many times and time it
    {
    	func();
    }
}
