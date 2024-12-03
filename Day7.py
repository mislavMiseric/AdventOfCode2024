# Specify the file to be read
filename = "resource/day7/test.txt"

try:
    # Open the file and read its contents
    with open(filename, "r") as file:
        content = file.read()
    print(content)
except FileNotFoundError:
    print(f"The file {filename} does not exist.")