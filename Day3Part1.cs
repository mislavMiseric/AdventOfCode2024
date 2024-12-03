using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public class Day3Part1
{
    public static void Main()
    {
        string filePath = "resource/day3/input.txt";
        int result = 0;

        try
        {
            string input = File.ReadAllText(filePath);

            string pattern = @"mul\((\d+),(\d+)\)";

            MatchCollection matches = Regex.Matches(input, pattern);
            foreach (Match match in matches)
            {
                int num1 = int.Parse(match.Groups[1].Value);
                int num2 = int.Parse(match.Groups[2].Value);
                result += num1 * num2;
            }

        }
        catch (Exception)
        {
            
        }
        Console.WriteLine("Result is: " + result);
    }
}