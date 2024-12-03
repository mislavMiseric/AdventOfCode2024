package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
    "sort"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("resource/day1/input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var leftIntegers []int
	var rightIntegers []int

	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Fields(line)

		if len(parts) != 2 {
			log.Printf("Skipping invalid line: %s\n", line)
			continue
		}

		left, err := strconv.Atoi(parts[0])
		if err != nil {
			log.Printf("Error converting '%s' to integer: %v\n", parts[0], err)
			continue
		}

		right, err := strconv.Atoi(parts[1])
		if err != nil {
			log.Printf("Error converting '%s' to integer: %v\n", parts[1], err)
			continue
		}

		leftIntegers = append(leftIntegers, left)
		rightIntegers = append(rightIntegers, right)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

    sort.Ints(leftIntegers)
	sort.Ints(rightIntegers)

    total := 0
	sum := 0

    for i := 0; i < len(leftIntegers); i++ {
		if i > 1 && leftIntegers[i] == leftIntegers[i-1] {
			total += sum
			continue
		}
		sum = 0
		for j := 0; j < len(rightIntegers); j++ {
			if(rightIntegers[j] > leftIntegers[i]) {
				break;
			}
			if(rightIntegers[j] == leftIntegers[i]){
				sum += rightIntegers[j]
			}

		}
		total += sum
	}

	fmt.Println(total)
}