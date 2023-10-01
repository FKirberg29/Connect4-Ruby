#######################################################
#
# Fabian Kirberg 
#
#######################################################
class Connect4
  
  #Constructor
  def initialize(num_rows, num_columns, win_length) 
    @num_rows = num_rows
    @num_columns = num_columns
    @win_length = win_length
  end

  #Helper method to print column labels
  def header
    puts "A B C D E F G H I J K L M N O P"[0, @num_columns*2]
  end

  #Helper method to create and fill board with 0s
  def makeBoard
    @board = Array.new(@num_rows){Array.new(@num_columns, 0)}
  end

  #Helper method that prints the formatted board and header
  def printBoard
    puts @board.map{|i| i.join(" ")}
    header
  end
  
  #Helper method that places player token in the lowest possible row of the selected column
  def makeMove(player, column)
    column = column.codepoints[0] - 65
    @board.reverse.each do |row|
        if row[column] == 0
          row[column] = player
          break
        end
    end
    printBoard
  end

  #Helper method that checks if a player has won the game
  def xInARow(player)
    #Use .each to loop through every value of the board
    @board.each_with_index do |row, r_index|
      row.each_with_index do |val, c_index|
        up_right_counter = 1
        down_right_counter = 1
        horizontal_counter = 1
        vertical_counter = 1

        #Only check for a win if the current board value is a player's token
        if val == player

          # Up Right Diagonal Check. Only runs if board has enough room for a win.
          if r_index >= @win_length-1
              while up_right_counter < @win_length && val == player && @board[r_index - up_right_counter][c_index + up_right_counter] == player
                  up_right_counter += 1
              end
          end

          # Down Right Diagonal and Vertical Check. Only runs if board has enough room for a win.
          if r_index <= @num_rows - @win_length
              while down_right_counter < @win_length && val == player && @board[r_index + down_right_counter][c_index + down_right_counter] == player
                  down_right_counter += 1
              end
              while vertical_counter < @win_length && val == player && @board[r_index + vertical_counter][c_index] == player
                  vertical_counter += 1
              end
          end

          # Horizontal Check
          while horizontal_counter < @win_length && val == player && @board[r_index][c_index + horizontal_counter] == player
              horizontal_counter += 1
          end
        end

        #If any of the directional checks reached the winLength, declare a winner and end the game.
        if up_right_counter == @win_length || down_right_counter == @win_length || horizontal_counter == @win_length || vertical_counter == @win_length
            puts "Congratulations, Player " + player.to_s + ". You win."
            exit(0)
        end
      end
    end
  end

  #Player column selection loop
  def placeToken(player)
    #Get user input
    puts "Player #{player}, which Column?"
    input = $stdin.gets.chomp.upcase

    #If user inputs "q" or "Q", quit
    if input == "Q"
      puts "Goodbye."
      exit(0)
    end

    #If character chosen is invalid
    if  input == "" || input.codepoints[0] <= 64 || input.codepoints[0] > 64+@num_columns
      puts "Invalid input, please try again."
      placeToken(player)
    end

    #If character chosen is within the bounds of the game
    if input.codepoints[0] > 64 && input.codepoints[0] <= 64+@num_columns
      if @board[0][input.codepoints[0] - 65] != 0
        puts "This column is full, please select another."
        placeToken(player)
      end
      #Place the token, print the board, and check for a win.
      makeMove(player, input)
      xInARow(player)
    end
    
    # If a player successfully places their token, swap players and request new input.
    player == 1 ? placeToken(2) : placeToken(1)
  end

  def play_game
   puts "Connect 4 with #{@num_rows} #{@num_columns} and #{@win_length}"
   #Construct the initial board
   makeBoard
   #Print the initial board
   printBoard
   #Begin the game with player 1
   placeToken(1)
  end
end
