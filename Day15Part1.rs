use std::fs::File;
use std::io::{self, prelude::*, BufReader};

static WAREHOUSE_WIDTH: usize  = 50;
static WAREHOUSE_HEIGHT: usize = 50;

static MOVE_NUMBER: usize = 20000;

static mut WAREHOUSE: [[char; WAREHOUSE_WIDTH]; WAREHOUSE_HEIGHT] = [['\0'; WAREHOUSE_WIDTH]; WAREHOUSE_HEIGHT];

static mut MOVES: [char; MOVE_NUMBER] = ['\0'; MOVE_NUMBER];

fn main() -> io::Result<()> {
    let file = File::open("resource/day15/input.txt")?;
    let reader = BufReader::new(file);
    let mut is_warehouse = true;

    let mut robot_position_x: usize = 0;   
    let mut robot_position_y: usize = 0;

    let mut counter_warehouse_x: usize = 0;
    let mut counter_warehouse_y: usize = 0;

    let mut counter_moves: usize = 0;

    for input in reader.lines() {
        let line = input?;
        if is_warehouse && line.trim().is_empty() {
            is_warehouse = false;
        } else {
            for c in line.chars() { 
                if is_warehouse {
                    if c == '@'{
                        robot_position_x = counter_warehouse_x;
                        robot_position_y = counter_warehouse_y;
                    }
                    unsafe {
                        WAREHOUSE[counter_warehouse_y][counter_warehouse_x] = c;
                        counter_warehouse_x += 1;
                    }
                } else {
                    unsafe {
                        MOVES[counter_moves] = c;
                        counter_moves += 1;
                    }
                }
            }
            counter_warehouse_y += 1;
            counter_warehouse_x = 0;
        }
    }
    unsafe {
        IntoIterator::into_iter(MOVES).for_each(|el| {
            let mut add_to_x = 0 as isize;
            let mut add_to_y = 0 as isize;
            check_orientation_and_set_add_variables_by_ref(el, &mut add_to_x, &mut add_to_y);
            if can_move(robot_position_x as isize, robot_position_y as isize, add_to_x, add_to_y) {
                WAREHOUSE[robot_position_y][robot_position_x] = '.';
                robot_position_x = (robot_position_x as isize + add_to_x) as usize;
                robot_position_y = (robot_position_y as isize + add_to_y) as usize;
            }
        });
    }
    print_warehouse();
    count_warehouse();


    Ok(())
}

fn print_warehouse(){
    unsafe{
        for row in IntoIterator::into_iter(WAREHOUSE) {
            for &c in row.iter() {
                print!("{}", c); // Print each character
            }
            println!(); // New line after each row
        }
    }
}

fn count_warehouse(){
    let mut result = 0;
    unsafe{
        for (row_idx, row) in WAREHOUSE.iter().enumerate() {
            for (col_idx, &c) in row.iter().enumerate() {
                // Print the index and the character
                if c == 'O'{
                    result = result + row_idx * 100 + col_idx;
                }
            }
        }
    }
    println!("Result: {}", result);
}

fn check_orientation_and_set_add_variables_by_ref(el: char, add_to_x: &mut isize, add_to_y: &mut isize) {
    if el == '^' {
        *add_to_y = -1; // Dereference the mutable reference to assign
    } else if el == '>' {
        *add_to_x = 1;
    } else if el == 'v' {
        *add_to_y = 1;
    } else {
        *add_to_x = -1;
    }
}

fn can_move(position_x: isize, position_y: isize, add_to_x: isize, add_to_y: isize) -> bool{
    let next_x = (position_x + add_to_x) as usize;
    let next_y = (position_y + add_to_y) as usize;
    unsafe{
        if WAREHOUSE[next_y][next_x] == '#' {
            return false;
        } else if WAREHOUSE[next_y][next_x] == 'O' {
            if can_move(next_x as isize, next_y as isize, add_to_x, add_to_y) {
                WAREHOUSE[next_y][next_x] = WAREHOUSE[position_y as usize][position_x as usize];
                return true;
            }
            return false;
        } else {
            WAREHOUSE[next_y][next_x] = WAREHOUSE[position_y as usize][position_x as usize];
            return true;
        }
    }
    
}