############################################################
#
#   Name:           Joel Balmes
#   Assignment:     Final - Connect Four - PVP
#   Date:           3/16/2019
#   Class:          CIS 282
#   Description:    Create a player vs player connect 4 game
#
############################################################

# encoding: UTF-8

# print_grid, takes a double-array as an input and prints the game-board for connect 4 using that double-array
def print_board(array)
  system('cls')
  puts
  puts "\033[33m  1    2    3    4    5    6    7    8  \033[0m"
  array.each do |row|
    puts"\033[33m│\033[0m #{(row.join" \033[33m││\033[0m ")} \033[33m│\033[0m"
    puts "#{"\033[33m╞---╡\033[0m"*row.count}"
  end
  puts "\033[33m╘─-─╛╘─-─╛╘─-─╛╘─-─╛╘─-─╛╘─-─╛╘─-─╛╘─-─╛\033[0m"
end

# play_piece takes user-input column, and plays the players piece in the lowest empty spot in that column
def play_piece(index,player,grid)
  row = 7
  col = index

  while grid[row][col] != "."
    row -= 1
  end

  # creates "dropping" animation for the piece played
  drop_row = 0
  until drop_row == row
    grid[drop_row][col] = player
    print_board(grid)
    sleep(0.05)
    grid[drop_row][col] = "."
    drop_row += 1
  end

  grid[row][col] = player

  coordinates = [row,col]
  return coordinates
end

# check_win checks for 4-in-a-row horizontally, vertically, and diagonally, returns win = true or win = false
def check_win(player,grid,coordinates)
  win = false
  win_array = []
  play_row = coordinates[0]
  play_col = coordinates[1]

  # horizontal checking
  grid[play_row].each_index do | col |
    if win_array.length != 4
      if grid[play_row][col] == player
        win_array.push([play_row,col])
      else
        win_array = []
      end
    end
  end

  if win_array.length == 4
    win = true
  end

  # vertical checking
  if win == false

    win_array = []

    grid.each_index  do | row |
      if win_array.length != 4
        if grid[row][play_col] == player
          win_array.push([row,play_col])
        else
          win_array = []
        end
      end
    end

    if win_array.length == 4
      win = true
    end
  end

  # diagonal checking SW to NE
  if win == false

    win_array = []
    row = play_row
    col = play_col

    # finds SW-most position in same diagonal line as most recently played piece
    # this is the starting point we check from
    until col == 0 || row == 7
      row += 1
      col -= 1
    end

    until col > 7 || row < 0
      if win_array.length != 4
        if grid[row][col] == player
          win_array.push([row,col])
        else
          win_array = []
        end
      end
      row -= 1
      col += 1
    end

    if win_array.length == 4
      win = true
    end
  end

  # diagonal checking NW to SE
  if win == false

    win_array = []
    row = play_row
    col = play_col

    # finds NW-most position in same diagonal line as most recently played piece
    # this is the starting point we check from
    until col == 0 || row == 0
      row -= 1
      col -= 1
    end

    until col > 7 || row > 7
      if win_array.length != 4
        if grid[row][col] == player
          win_array.push([row,col])
        else
          win_array = []
        end
      end
      row += 1
      col += 1
    end

    if win_array.length == 4
      win = true
    end
  end

  # winning four-in-a-row briefly "flashes" to show where it is
  if win == true
    flash_count = 0
    while flash_count < 4
      #flashing animation
      win_array.each do | element |
        grid[element[0]][element[1]] = "@"
      end
      print_board(grid)
      sleep(0.2)
      win_array.each do | element |
        grid[element[0]][element[1]] = player
      end
      print_board(grid)
      sleep(0.2)
      flash_count += 1
    end
  end

  return win
end

# Sets variables for the game including the piece for each player, and the score

player_one_piece = "\033[31;1m@\033[0m"
player_two_piece = "\033[34;1m@\033[0m"
player_one_score = 0
player_two_score = 0

# Program:
# This is the main program that runs through several game states:

#game_state 0:  First round of gameplay, reset the board, first turn (player goes first)
game_state = 0

while game_state == 0

  turns_taken = 0

  game_board = [
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."],
      [".",".",".",".",".",".",".","."]
  ]

  system('cls')
  puts "Welcome to Connect 4"
  puts "Play a piece by entering the column (1-8) you'd like to drop it in."
  puts "Try to beat the computer by getting 4-in-a-row first."
  puts "Player 1 is red: #{player_one_piece} Player 2 is blue: #{player_two_piece}"
  puts "Player 1 goes first, press enter to begin."
  gets

  print_board(game_board)

  game_state = 1

  # player 1's turn
  while game_state == 1

    valid_choice = false
    puts "Player 1's turn"
    puts "Select a column (1-8)"

    while valid_choice == false

      user_choice = gets.to_i

      if user_choice <= 0 || user_choice >= 9
        puts "Invalid choice. Please select a column by entering a number from 1 to 8"
      elsif game_board[0][(user_choice - 1)] != "."
        puts "That column is full. Please select another column"
      else
        valid_choice = true
      end
    end

    play_index = user_choice - 1

    coordinates = play_piece(play_index,player_one_piece,game_board)
    print_board(game_board)
    win = check_win(player_one_piece,game_board,coordinates)

    turns_taken += 1

    if turns_taken == 64
      game_state = 5
    elsif win == true
      game_state = 3
    else
      game_state = 2
    end

    # player 2's turn
    while game_state == 2

      valid_choice = false
      puts "Player 2's turn"
      puts "Select a column (1-8)"

      while valid_choice == false

        user_choice = gets.to_i

        if user_choice <= 0 || user_choice >= 9
          puts "Invalid choice. Please select a column by entering a number from 1 to 8"
        elsif game_board[0][(user_choice - 1)] != "."
          puts "That column is full. Please select another column"
        else
          valid_choice = true
        end
      end

      play_index = user_choice - 1
      coordinates = play_piece(play_index,player_two_piece,game_board)
      print_board(game_board)
      win = check_win(player_two_piece,game_board,coordinates)

      turns_taken += 1

      if turns_taken == 64
        game_state = 5
      elsif win == true
        game_state = 4
      else
        game_state = 1
      end
    end
  end

  # player 1 'win' results
  while game_state == 3
    player_one_score += 1
    puts "Congratulations Player 1! You win!"
    puts "The score is: Player 1: #{player_one_score}, Player 2: #{player_two_score}"
    puts "Play again?"
    puts "1.-- Play again."
    puts "2.-- Exit game."
    play_again = gets.to_i

    valid_choice = false
    while valid_choice == false
      if play_again == 1
        puts "Starting a new game"
        valid_choice = true
        game_state = 0
      elsif play_again == 2
        puts "Thanks for playing!"
        valid_choice = true
        game_state = -1
      else
        puts "Invalid choice. Enter 1 to play again or 2 to exit the game."
        play_again = gets.to_i
      end
    end

  end

  # player 2 'win' results
  while game_state == 4
    player_two_score += 1
    puts "Congratulations Player 2! You win!"
    puts "The score is: Player 1: #{player_one_score}, Player 2: #{player_two_score}"
    puts "Play again?"
    puts "1.-- Play again."
    puts "2.-- Exit game."
    play_again = gets.to_i

    valid_choice = false
    while valid_choice == false
      if play_again == 1
        puts "Starting a new game"
        valid_choice = true
        game_state = 0
      elsif play_again == 2
        puts "Thanks for playing!"
        valid_choice = true
        game_state = -1
      else
        puts "Invalid choice. Enter 1 to play again or 2 to exit the game."
        play_again = gets.to_i
      end
    end
  end

  # 'stalemate' results (all slots filled with no winner)
  while game_state == 5
    puts "Stalemate. No more moves available."
    puts "Play again?"
    puts "1.-- Play again."
    puts "2.-- Exit game."
    play_again = gets.to_i

    valid_choice = false
    while valid_choice == false
      if play_again == 1
        puts "Starting a new game"
        valid_choice = true
        game_state = 0
      elsif play_again == 2
        puts "Thanks for playing!"
        valid_choice = true
        game_state = -1
      else
        puts "Invalid choice. Enter 1 to play again or 2 to exit the game."
        play_again = gets.to_i
      end
    end
  end

end