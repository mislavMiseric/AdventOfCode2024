#install.packages("gmp")
library(gmp)

register_a <- as.bigz(0)
register_b <- as.bigz(0)
register_c <- as.bigz(0)
instruction_pointer <- 1
found <- FALSE

program_stack <- list()

read_file <- function(file_path) {
    lines <- suppressWarnings(readLines(file_path))

    register_a <<- as.bigz(gsub("Register A: (\\d+)", "\\1", lines[1]))
    register_b <<- as.bigz(gsub("Register B: (\\d+)", "\\1", lines[2]))
    register_c <<- as.bigz(gsub("Register C: (\\d+)", "\\1", lines[3]))

    program_str <- gsub("Program: ", "", lines[5])
    program_stack <<- as.integer(strsplit(program_str, ",")[[1]])
}

adv <- function(value) {
    divisor <- as.bigz(2) ^ value
    register_a <<- floor(register_a / divisor)
}

bxl <- function(value) {
    reg_b_int <- as.integer(register_b %% 256)
    if (!is.na(reg_b_int)) {
        reg_b_int <- bitwXor(reg_b_int, value)
        register_b <<- as.bigz(reg_b_int)
    }
}

bst <- function(value) {
    value_bigz <- as.bigz(value)
    register_b <<- value_bigz %% 8
}

bxc <- function(value) {
    reg_b_int <- as.integer(register_b %% 256)
    reg_c_int <- as.integer(register_c %% 256)
    if (!is.na(reg_b_int) && !is.na(reg_c_int)) {
        reg_b_int <- bitwXor(reg_b_int, reg_c_int)
        register_b <<- as.bigz(reg_b_int)
    }
}

out <- function(value) {
    value_bigz <- as.bigz(value)
    value_mod <- value_bigz %% 8
    
    current_output_bigz <- as.bigz(current_output)
    
    return(value_mod == current_output_bigz)
}

bdv <- function(value) {
    divisor <- as.bigz(2) ^ value
    register_b <<- floor(register_a / divisor)
}

cdv <- function(value) {
    divisor <- as.bigz(2) ^ value
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
       `5` = {
            return(out(value))
        },
       `6` = bdv(value),
       `7` = cdv(value),
       {
         cat("Unhandled case:", instruction, "Value:", value, "\n")
       }
    )  
    return(FALSE)
}

process_program <- function(new_value) {
    register_a <<- as.bigz(new_value)
    instruction_pointer <<- 1
    is_valid <- FALSE
    while (!found & !is_valid & instruction_pointer < length(program_stack)) {
        instruction <- program_stack[[instruction_pointer]]
        value <- program_stack[[instruction_pointer + 1]]
        if (instruction == 3) {
            instruction_pointer <<- instruction_pointer + 2
        } else {
            is_valid <- is_valid | handle_instruction(as.character(instruction), value)
            instruction_pointer <<- instruction_pointer + 2
        }
    }
    return(is_valid)
}

process_from_end <- function(value, current_output_index_local) {
    base_value <- as.bigz(value)
    for(i in 0:7){
        current_output <<- program_stack[[current_output_index_local]]
        new_register_a <- base_value * 8 + as.bigz(i)
        if(process_program(new_register_a)){
            print(new_register_a)
            if(current_output_index_local == 1){
                if(!found){
                    found <<- TRUE
                    print(new_register_a)
                }
            } else {
                process_from_end(new_register_a, current_output_index_local - 1)
            }
        }
    }
}

read_file("resource/day17/input.txt")
for(last_registar_a_possible_values in 1:7){
    current_output_index <- length(program_stack)
    current_output <- program_stack[[current_output_index]]
    if(process_program(last_registar_a_possible_values)){
        process_from_end(last_registar_a_possible_values, current_output_index - 1)
    }   
}