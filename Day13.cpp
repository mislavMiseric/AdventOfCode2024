#include <fstream>
#include <iostream>
#include <cmath>

using namespace std;

unsigned long long solveEquation(double a, double b, double c, double d, double e, double f) {
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

    double ax;
    double ay;
    double bx;
    double by;
    double resX;
    double rexY;

    unsigned long long sumPart1 = 0;
    unsigned long long sumPart2 = 0;

    if (file.is_open()) {
        while( file >> line >> line >> first >> second)
        {
            ax = stod(first.substr(2));
            ay = stod(second.substr(2));

            file >> line >> line >> first >> second;
            bx = stod(first.substr(2));
            by = stod(second.substr(2));

            file >> line >> first >> second;
            resX = stod(first.substr(2));
            rexY = stod(second.substr(2));

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