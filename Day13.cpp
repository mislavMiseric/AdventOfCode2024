#include <fstream>
#include <iostream>
#include <cmath>

using namespace std;

long long solveEquation(int a, int b, int c, int d, long long e, long long f) {
    double determinant = a*d - b*c;
    if(determinant != 0) {
        double x = (e*d - b*f)/determinant;
        double y = (a*f - e*c)/determinant;

        return trunc(x) == x && trunc(y) == y ? x*3 + y : 0;
    } else {
        return 0;
    }
}

int main()
{

    ifstream file("resource/day13/input.txt");
    string line;
    string first;
    string second;

    int ax;
    int ay;
    int bx;
    int by;
    long long resX;
    long long rexY;

    long long sumPart1 = 0;
    long long sumPart2 = 0;

    if (file.is_open()) {
        while( file >> line >> line >> first >> second)
        {
            ax = stoi(first.substr(2));
            ay = stoi(second.substr(2));

            file >> line >> line >> first >> second;
            bx = stoi(first.substr(2));
            by = stoi(second.substr(2));

            file >> line >> first >> second;
            resX = stoll(first.substr(2));
            rexY = stoll(second.substr(2));

            sumPart1 += solveEquation(ax, bx, ay, by, resX, rexY);
            sumPart2 += solveEquation(ax, bx, ay, by, resX + 10000000000000, rexY + 10000000000000);
        }
        file.close();
    }
    else {
        cerr << "Unable to open file!" << endl;
    }

    cout << "Sum part 1: " << sumPart1 << endl;
    cout << "Sum part 2: " << sumPart2 << endl;

    return 0;
}