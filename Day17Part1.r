register_a <- 0
register_b <- 0
register_c <- 0
instruction_pointer <- 1

program_stack <- list()

read_file <- function(file_path) {
    lines <- suppressWarnings(readLines("resource/day17/test.txt"))

    register_a <<- as.integer(gsub("Register A: (\\d+)", "\\1", lines[1]))
    register_b <<- as.integer(gsub("Register B: (\\d+)", "\\1", lines[2]))
    register_c <<- as.integer(gsub("Register C: (\\d+)", "\\1", lines[3]))

    program_str <- gsub("Program: ", "", lines[5])
    program_stack <<- as.integer(strsplit(program_str, ",")[[1]])
}

adv <- function(value) {
    divisor <- 2 ^ value
    register_a <<- floor(register_a / divisor)
}

bxl <- function(value) {
    register_b <<- bitwXor(register_b, value)
}

bst <- function(value) {
    register_b <<- value %% 8
}

bxc <- function(value) {
    register_b <<- bitwXor(register_b, register_c)
}

out <- function(value) {
    cat(paste(value %% 8, ", "))
}

bdv <- function(value) {
    divisor <- 2 ^ value
    register_b <<- floor(register_a / divisor)
}

cdv <- function(value) {
    divisor <- 2 ^ value
    register_c <<- floor(register_a / divisor)
}

handle_instruction <- function(instruction, literalValue) {
    
    value <- literalValue

    if (literalValue == 4) {
        value <- register_a
    } else if (value == 5) {
        value <- register_b
    } else if (value == 6) {
        value <- register_c
    }

    switch(instruction,
       `0` = adv(value),
       `1` = bxl(literalValue),
       `2` = bst(value),
       `4` = bxc(value),
       `5` = out(value),
       `6` = bdv(value),
       `7` = cdv(value),
       {
         cat("Unhandled case:", instruction, "Value:", value, "\n")
       }
    )   
}

process_program <- function() {
    while (instruction_pointer < length(program_stack)) {
        instruction <- program_stack[[instruction_pointer]]
        value <- program_stack[[instruction_pointer + 1]]
        if (instruction == 3) {
            if(register_a == 0) {
                instruction_pointer <<- instruction_pointer + 2
            } else if(value %% 2 == 0) {
                instruction_pointer <<- value + 1
            } else {
                instruction_pointer = length(program_stack)
            }
        } else {
            handle_instruction(as.character(instruction), value)
            instruction_pointer <<- instruction_pointer + 2
        }
    }
}

read_file("resource/day17/test.txt")
process_program()