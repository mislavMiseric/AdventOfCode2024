#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main()
{

    ifstream file("resource/day13/test.txt");
    string line;

    if (file.is_open()) {
        while (getline(file, line)) {
            cout << line << endl;
        }
        file.close();
    }
    else {
        cerr << "Unable to open file!" << endl;
    }

    return 0;
}