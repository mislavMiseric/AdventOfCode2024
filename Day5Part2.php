<?php
$filename = 'resource/day5/input.txt';

if (file_exists($filename)) {
    $content = file_get_contents($filename);
    $result = separateDifferentPartsOfInput($content);

    $conditions = $result[0];
    $numberLines = $result[1];

    $sumOfResults = 0;
    foreach (explode("\n", $numberLines) as $line) {
        $sumOfResults += validateLine($line, $conditions);
    }
    echo $sumOfResults;

} else {
    echo "File does not exist.";
}

function separateDifferentPartsOfInput($input){
    return preg_split('/\n[\s\n]/', $input );
}

function validateLine($line, $conditions){
    if(strlen($line) == 0){
        return 0;
    }
    $numbersInLine = explode(',', $line);
    foreach (explode("\n", $conditions) as $condition) {
        $conditionExplode = explode('|', $condition);
        //definitely not optimal solution
        if(!validateOneCondtion($numbersInLine, $conditionExplode)){
            $sorted = sortNumbersInLine($numbersInLine, $conditions);
            return findMiddleElement($sorted);
        };
    }
    return 0;
}

function validateOneCondtion($numbersInLine, $conditionArray){
    $firstValueFound = false;
    $secondValueFound = false;
    foreach($numbersInLine as $number){
        if($number == $conditionArray[0]){
            if($secondValueFound){
                return false;
            }
            $firstValueFound = true;
        }
        if($number == $conditionArray[1]){
            if($firstValueFound){
                return true;
            }
            $secondValueFound = true;
        }
    }
    return true;
}

function findMiddleElement($numbersInLine){
    return $numbersInLine[(sizeof($numbersInLine) - 1) / 2];
}

function sortNumbersInLine($numbersInLine, $conditions){
    foreach (explode("\n", $conditions) as $condition) {
        $conditionExplode = explode('|', $condition);
        if(!validateOneCondtion($numbersInLine, $conditionExplode)){
            //change order and reevaluate
            $numbersInLine = switchPlacesOfValues($numbersInLine, $conditionExplode[0], $conditionExplode[1]);
            $numbersInLine = sortNumbersInLine($numbersInLine, $conditions);
        };
    }
    return $numbersInLine;    
}

function switchPlacesOfValues($numbersInLine,$first,$second)
{
    $index1=array_search($first,$numbersInLine);
    $index2=array_search($second,$numbersInLine);
    $numbersInLine[$index1]=$second;
    $numbersInLine[$index2]=$first;
    return $numbersInLine;
}
?>