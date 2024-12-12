#include <stdio.h>
#include <string.h>

int check(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){

    char leftDown = i<(rowSize-1) && j>0 ? lines[i+1][j-1] : '.';
    char left = i>=0 && j > 0 ? lines[i][j-1] : '.';
    char down = i<(rowSize-1) && j<(colSize) ? lines[i+1][j] : '.';
    char current = i>=0 && j<(colSize) ? lines[i][j] : '.';

    if(leftDown != lowercaseChar && left != lowercaseChar && down != lowercaseChar && current != lowercaseChar){
        if(leftDown == current && down == current && left == current){
            return 0;
        }
        return 1;
    }
    return 0;
}

int countPerimeterForAllDirections(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int perimeter = 0;

    //check left down
    perimeter += check(i, j, lines, rowSize,colSize, lowercaseChar);
    //check right down
    perimeter += check(i, j+1, lines, rowSize,colSize, lowercaseChar);
    //check left up
    perimeter += check(i-1, j, lines, rowSize,colSize, lowercaseChar);
    //check right up
    perimeter += check(i-1, j+1, lines, rowSize,colSize, lowercaseChar);
    
    return perimeter;
}

int checkRegion(int* occurrence, int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int perimeter = 0;
    if(i>0 && lines[i-1][j] == (lowercaseChar-32)){
        ++(*occurrence);
        perimeter += countPerimeterForAllDirections(i-1, j, lines, rowSize, colSize, lowercaseChar);
        lines[i-1][j] = lowercaseChar;
        perimeter += checkRegion(occurrence, i-1, j, lines, rowSize, colSize, lowercaseChar);
    }
    if(j>0 && lines[i][j-1] == (lowercaseChar-32)){
        ++(*occurrence);
        perimeter += countPerimeterForAllDirections(i, j-1, lines, rowSize, colSize, lowercaseChar);
        lines[i][j-1] = lowercaseChar;
        perimeter += checkRegion(occurrence, i, j-1, lines, rowSize, colSize, lowercaseChar);
    }
    if(i<(rowSize-1) && lines[i+1][j] == (lowercaseChar-32)){
        ++(*occurrence);
        perimeter += countPerimeterForAllDirections(i+1, j, lines, rowSize, colSize, lowercaseChar);
        lines[i+1][j] = lowercaseChar;
        perimeter += checkRegion(occurrence, i+1, j, lines, rowSize, colSize, lowercaseChar);
    }
    if(j<(colSize-1) && lines[i][j+1] == (lowercaseChar-32)){
        ++(*occurrence);
        perimeter += countPerimeterForAllDirections(i, j+1, lines, rowSize, colSize, lowercaseChar);
        lines[i][j+1] = lowercaseChar;
        perimeter += checkRegion(occurrence, i, j+1, lines, rowSize, colSize, lowercaseChar);
    }
    
    return perimeter;
}

long countPriceForArea(int i, int j, char lines[200][200], int rowSize, int colSize, char lowercaseChar){
    int occurrence = 1;
    int perimeter = countPerimeterForAllDirections(i, j, lines, rowSize, colSize, lowercaseChar);
    lines[i][j] = lowercaseChar;
    perimeter += checkRegion(&occurrence, i, j, lines, rowSize, colSize, lowercaseChar);
    for(int p = 0; p< rowSize; p++){
        for(int q = 0; q < colSize; q++){
            if(lines[p][q] == lowercaseChar && lines[p][q-1] != lowercaseChar && lines[p+1][q] != lowercaseChar && lines[p+1][q-1]==lowercaseChar){
                printf("\n%c %d %d", lowercaseChar, p, q);
                ++perimeter;
            }
            else if(lines[p][q] == lowercaseChar && lines[p][q+1] != lowercaseChar && lines[p+1][q] != lowercaseChar && lines[p+1][q+1]==lowercaseChar){
                printf("\n%c %d %d", lowercaseChar, p, q);
                ++perimeter;
            }
        }
    }
    //printf("\n%c %d %d %d", lowercaseChar, perimeter, occurrence, perimeter * occurrence);
    for(int k = 0; k< rowSize; k++){
        for(int r = 0; r < colSize; r++){
            if(lines[k][r] == lowercaseChar){
                lines[k][r] = '_';
            }
        }
    }
    return perimeter * occurrence;
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