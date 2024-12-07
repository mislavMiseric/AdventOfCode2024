def calculate(result, currentResult, numbers):
    tmpNumbers = numbers.split(" ", 1)
    if(currentResult > result):
        return False
    if(len(tmpNumbers) == 1):
        if((int(tmpNumbers[0]) * currentResult) == result or (int(tmpNumbers[0]) + currentResult) == result) or (int(str(currentResult) + tmpNumbers[0]) == result):
            return result
        return 0
    return calculate(result, (int(tmpNumbers[0]) * currentResult), tmpNumbers[1]) or calculate(result, (int(tmpNumbers[0]) + currentResult), tmpNumbers[1]) or calculate(result, int(str(currentResult) + tmpNumbers[0]), tmpNumbers[1])

def taskDay7(content):
    content = content.split("\n")
    sum = 0
    
    for line in content:
        numbers = line.split(": ")
        tmpNumbers = numbers[1].split(" ", 1)
        sum += calculate(int(numbers[0]), int(tmpNumbers[0]), tmpNumbers[1])
    print(sum)

filename = "resource/day7/input.txt"

try:
    # Open the file and read its contents
    with open(filename, "r") as file:
        content = file.read()
    taskDay7(content)
except FileNotFoundError:
    print(f"The file {filename} does not exist.")

