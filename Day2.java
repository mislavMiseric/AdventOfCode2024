import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.stream.IntStream;

public class Day2 {

	public static void main(String[] args) {
		String testFile = "resource/day2/test.txt";
		String inputFile = "resource/day2/input.txt";
		String file = args != null && args.length > 0 && args[0].equalsIgnoreCase("t") ? testFile : inputFile;
        int validLines = 0;
        int totalLines = 0;
		
		try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
            	totalLines++;
            	if(isReportValid(line)) {
            		validLines++;
            	};
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
		
		System.out.printf("Valid %d of %d lines", validLines, totalLines);

	}
	
	private static boolean isReportValid(String line) {
	    int[] reportValues = Arrays.stream(line.split(" ")).mapToInt(Integer::parseInt).toArray();
	    
        return IntStream.range(0, reportValues.length)
                .anyMatch(i -> {
                    int[] subArray = IntStream.range(0, reportValues.length)
                            .filter(j -> j != i)
                            .map(j -> reportValues[j])
                            .toArray();

                    boolean isAscendingValid = IntStream.range(0, subArray.length - 1)
                            .allMatch(k -> subArray[k + 1] > subArray[k] &&
                                    (subArray[k + 1] - subArray[k] >= 1 && subArray[k + 1] - subArray[k] <= 3));

                    boolean isDescendingValid = IntStream.range(0, subArray.length - 1)
                            .allMatch(k -> subArray[k + 1] < subArray[k] &&
                                    (subArray[k] - subArray[k + 1] >= 1 && subArray[k] - subArray[k + 1] <= 3));

                    return isAscendingValid || isDescendingValid;
                });
	}
}