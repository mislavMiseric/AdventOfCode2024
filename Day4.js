let fileContent;
let wordPartOne = "XMAS";
let wordPartTwo = "MAS";

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("calculatePartOne").setAttribute("disabled", "");
    document.getElementById("calculatePartTwo").setAttribute("disabled", "");
    document.getElementById('fileInput').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (file) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            fileContent = e.target.result;
            document.getElementById("calculatePartOne").removeAttribute("disabled");
            document.getElementById("calculatePartTwo").removeAttribute("disabled");
            document.getElementById("inputLabel").style.display = 'none';
        };
        
        reader.readAsText(file);

        } else {
            document.getElementById("inputLabel").style.display = 'block';
            document.getElementById("calculatePartOne").setAttribute("disabled", "");
            document.getElementById("calculatePartTwo").setAttribute("disabled", "");
        }
    });
});

function calculatePartOne() {
    const lines = fileContent.split('\n').map(line => line.trim());
    let countOrWordOccurrences = 0;
    for (let i = 0; i < lines.length; i++) {
        for (let j = 0; j < lines[i].length; j++) {
            if(wordPartOne[0] === lines[i][j] || wordPartOne[wordPartOne.length - 1] === lines[i][j]){
                
                let isBackward = checkBackward(lines, i, j, wordPartOne)
                
                // Overlapping with checkRight because of backward possibility
                /*if(checkLeft(lines, i , j, isBackward, 1)){
                    ++countOrWordOccurrences;
                }*/

                if(checkRight(lines, i ,j , isBackward, 1, wordPartOne)){
                    ++countOrWordOccurrences;
                }

                if(checkDown(lines, i , j, isBackward, 1, wordPartOne)){
                    ++countOrWordOccurrences;
                }

                if(checkDownLeft(lines, i , j, isBackward, 1, wordPartOne)){
                    ++countOrWordOccurrences;
                }

                if(checkDownRight(lines, i , j, isBackward, 1, wordPartOne)){
                    ++countOrWordOccurrences;
                }

            }
        }
    }
    document.getElementById("result").textContent = `Word: [${wordPartOne}] is reapting: ${countOrWordOccurrences} times`;
}

function calculatePartTwo(){

    const lines = fileContent.split('\n').map(line => line.trim());
    let countOrWordOccurrences = 0;
    for (let i = 0; i < lines.length; i++) {

        for (let j = 0; j < lines[i].length; j++) {

            // check first diagonal with checkDownRight
            if(wordPartTwo[0] === lines[i][j] || wordPartTwo[wordPartTwo.length - 1] === lines[i][j]){
                let isBackward = checkBackward(lines, i, j, wordPartTwo)

                if(checkDownRight(lines, i , j, isBackward, 1, wordPartTwo)){

                    // check other diagonal with checkDownLeft
                    if(wordPartTwo[0] === lines[i][j + wordPartTwo.length - 1] || wordPartTwo[wordPartTwo.length - 1] === lines[i][j + wordPartTwo.length - 1]){
                        let isBackward = checkBackward(lines, i, j + wordPartTwo.length - 1, wordPartTwo)
                        if(checkDownLeft(lines, i , j + wordPartTwo.length - 1, isBackward, 1, wordPartTwo)){
                            ++countOrWordOccurrences;
                        }
                    }

                }

            }
        }
    }
    document.getElementById("result").textContent = `Word: [${wordPartTwo}] is reapting in X shape: ${countOrWordOccurrences} times`;

}

function checkBackward(lines, i, j, word){
    if(word[0] === lines[i][j]){
        return false;
    } else {
        return true;
    }
}

function checkLeft(lines, i ,j, isBackward, correctLettersInWord, word){
    if(correctLettersInWord === word.length){
        return true;
    } else if (j > 0 && ((!isBackward  && lines[i][j-1] === word[correctLettersInWord]) || (isBackward && lines[i][j-1] === word[word.length -1 - correctLettersInWord]))){
        return checkLeft(lines, i, j-1, isBackward, ++correctLettersInWord, word);
    } else {
        return false;
    }
}

function checkRight(lines, i ,j, isBackward, correctLettersInWord, word) {
    if(correctLettersInWord === word.length){
        return true;
    } else if (j < lines[i].length-1 && ((!isBackward  && lines[i][j+1] === word[correctLettersInWord]) || (isBackward && lines[i][j+1] === word[word.length -1 - correctLettersInWord]))){
        return checkRight(lines, i, j+1, isBackward, ++correctLettersInWord, word);
    } else {
        return false;
    }
}

function checkDown(lines, i ,j, isBackward, correctLettersInWord, word){
    if(correctLettersInWord === word.length){
        return true;
    } else if (i < lines.length - 1 && ((!isBackward  && lines[i+1][j] === word[correctLettersInWord]) || (isBackward && lines[i+1][j] === word[word.length -1 - correctLettersInWord]))){
        return checkDown(lines, i+1, j, isBackward, ++correctLettersInWord, word);
    } else {
        return false;
    }
}

function checkDownLeft(lines, i ,j, isBackward, correctLettersInWord, word){
    if(correctLettersInWord === word.length){
        return true;
    } else if (i < lines.length - 1 && j > 0 && ((!isBackward  && lines[i+1][j-1] === word[correctLettersInWord]) || (isBackward && lines[i+1][j-1] === word[word.length -1 - correctLettersInWord]))){
        return checkDownLeft(lines, i+1, j-1, isBackward, ++correctLettersInWord, word);
    } else {
        return false;
    }
}

function checkDownRight(lines, i ,j, isBackward, correctLettersInWord, word){
    if(correctLettersInWord === word.length){
        return true;
    } else if (i < lines.length - 1 && j < lines[i].length-1 && ((!isBackward  && lines[i+1][j+1] === word[correctLettersInWord]) || (isBackward && lines[i+1][j+1] === word[word.length -1 - correctLettersInWord]))){
        return checkDownRight(lines, i+1, j+1, isBackward, ++correctLettersInWord, word);
    } else {
        return false;
    }
}
