#include <stdio.h>
#include <string.h>

int check(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){

    char leftDown = i<(rowSize-1) && j>0 ? lines[i+1][j-1] : '.';
    char left = i>=0 && j > 0 ? lines[i][j-1] : '.';
    char down = i<(rowSize-1) && j<(colSize) ? lines[i+1][j] : '.';
    char current = i>=0 && j<(colSize) ? lines[i][j] : '.';

    if(leftDown != lowercaseChar && left != lowercaseChar && down != lowercaseChar && current != lowercaseChar){
        int temp = (leftDown == lowercaseChar - 32) + (left == lowercaseChar - 32) + (down == lowercaseChar - 32) + (current == lowercaseChar - 32);
        if(temp == 1 || temp == 3){
            return 1;
        }
        if(temp == 2 && ((lowercaseChar - 32 == leftDown && lowercaseChar - 32 == current) || (lowercaseChar - 32 == down && lowercaseChar - 32 == left))){
            return 1;
        }
        return 0;
    }
    return 0;
}

int countSidesForAllDirections(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int sides = 0;

    //check left down
    sides += check(i, j, lines, rowSize,colSize, lowercaseChar);
    //check right down
    sides += check(i, j+1, lines, rowSize,colSize, lowercaseChar);
    //check left up
    sides += check(i-1, j, lines, rowSize,colSize, lowercaseChar);
    //check right up
    sides += check(i-1, j+1, lines, rowSize,colSize, lowercaseChar);
    
    return sides;
}

int countSidesForAllDirectionsAndSetFields(int* occurrence, int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    ++(*occurrence);
    int sides = countSidesForAllDirections(i, j, lines, rowSize, colSize, lowercaseChar);
    lines[i][j] = lowercaseChar;
    return sides;
}

int checkRegion(int* occurrence, int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int sides = 0;
    if(i>0 && lines[i-1][j] == (lowercaseChar-32)){
        sides += countSidesForAllDirectionsAndSetFields(occurrence, i-1, j, lines, rowSize, colSize, lowercaseChar);
        sides += checkRegion(occurrence, i-1, j, lines, rowSize, colSize, lowercaseChar);
    }
    if(j>0 && lines[i][j-1] == (lowercaseChar-32)){
        sides += countSidesForAllDirectionsAndSetFields(occurrence, i, j-1, lines, rowSize, colSize, lowercaseChar);
        sides += checkRegion(occurrence, i, j-1, lines, rowSize, colSize, lowercaseChar);
    }
    if(i<(rowSize-1) && lines[i+1][j] == (lowercaseChar-32)){
        sides += countSidesForAllDirectionsAndSetFields(occurrence, i+1, j, lines, rowSize, colSize, lowercaseChar);
        sides += checkRegion(occurrence, i+1, j, lines, rowSize, colSize, lowercaseChar);
    }
    if(j<(colSize-1) && lines[i][j+1] == (lowercaseChar-32)){
        sides += countSidesForAllDirectionsAndSetFields(occurrence, i, j+1, lines, rowSize, colSize, lowercaseChar);
        sides += checkRegion(occurrence, i, j+1, lines, rowSize, colSize, lowercaseChar);
    }
    
    return sides;
}

int countDiagonalDuplicates(char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int sides = 0;
    for(int p = 0; p< rowSize; p++){
        for(int q = 0; q < colSize; q++){
            if(lines[p][q] == lowercaseChar && lines[p][q-1] != lowercaseChar && lines[p+1][q] != lowercaseChar && lines[p+1][q-1]==lowercaseChar){
                ++sides;
            }
            else if(lines[p][q] == lowercaseChar && lines[p][q+1] != lowercaseChar && lines[p+1][q] != lowercaseChar && lines[p+1][q+1]==lowercaseChar){
                ++sides;
            }
        }
    }
    return sides;

}

void replaceLowercase(char lines[200][200], int rowSize, int colSize, char lowercaseChar){

    for(int i = 0; i< rowSize; i++){
        for(int j = 0; j < colSize; j++){
            if(lines[i][j] == lowercaseChar){
                lines[i][j] = '_';
            }
        }
    }

}

long countPriceForArea(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int occurrence = 1;
    int sides = countSidesForAllDirections(i, j, lines, rowSize, colSize, lowercaseChar);
    lines[i][j] = lowercaseChar;
    sides += checkRegion(&occurrence, i, j, lines, rowSize, colSize, lowercaseChar);

    sides += countDiagonalDuplicates(lines, rowSize, colSize, lowercaseChar);

    replaceLowercase(lines, rowSize, colSize, lowercaseChar);

    return sides * occurrence;
}

int main(void)
{
    FILE* file = fopen("resource/day12/input.txt", "r");
    char lines[200][200];
    int numberOfRows = 0;

    long price = 0;

    int numberOfColumns;

    if (file != NULL) {
        while (fgets(lines[numberOfRows], sizeof(lines[numberOfRows]), file)) {
            ++numberOfRows;
        }
        fclose(file);
    }

    else {
        fprintf(stderr, "Unable to open file!\n");
    }

    numberOfColumns = strlen(lines[0]);

    for (char c = 'A'; c <= 'Z'; c++)
    {
        for(int i = 0; i< numberOfRows; i++){
            for(int j = 0; j < numberOfColumns; j++){
                if(lines[i][j] == c){
                    price += countPriceForArea(i, j, lines, numberOfRows, numberOfColumns, c+32);
                }
            }
        }

    }

    printf("Price is %ld", price);

    return 0;
}