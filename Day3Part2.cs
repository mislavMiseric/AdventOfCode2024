using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public class Day3Part2
{
    public static void Main()
    {
        string filePath = "resource/day3/input.txt";
        int result = 0;
        bool isMulActive = true;

        try
        {
            string input = File.ReadAllText(filePath);

            //string patternMul = @"mul\((\d+),(\d+)\)";
            //string patternDoOrDoNot = @"(do(?:n't)?\(\))";
            string combinedPattern = @"(mul\((\d+),(\d+)\))|(do(?:n't)?\(\))";

            MatchCollection matches = Regex.Matches(input, combinedPattern);
            foreach (Match match in matches)
            {

            if (match.Success)
                {
                    if (isMulActive && match.Groups[1].Success)
                    {
                        int num1 = int.Parse(match.Groups[2].Value);
                        int num2 = int.Parse(match.Groups[3].Value);
                        result += num1 * num2;
                    }
                    else if (match.Groups[4].Success)
                    {
                        if (match.Groups[4].Value.StartsWith("don't"))
                        {
                            isMulActive = false;
                        }
                        else
                        {
                            isMulActive = true;
                        }
                    }
                }

            }


        }
        catch (Exception)
        {
            
        }
        Console.WriteLine("Result is: " + result);
    }
}