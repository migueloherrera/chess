class Chess
  attr_accessor :game, :player
  
  def initialize
    @game = Board.new
    @player = nil
    @lost_blacks = []
    @lost_whites = []
  end
  
  def play
    @game.show
    puts "The first turn is for the white pieces.\n"
    turn = 0
    while true
      @player = turn % 2 == 0 ? @game.white : @game.black
      puts "Total moves: #{turn}"
      puts "It's #{@player.color}'s pieces turn"
      move = @player.read_move
      if valid_move?(move[0], move[1])
        from = move[0]
        to = move[1]
        if (!is_empty? to) && (["\u2654","\u265A"].include? @game.board[to].shape)
          puts "####################"
          puts "# The #{@player.color}'s won! #"
          puts "####################"
          return
        else
          make_move(from, to)
          promotion(to)
          puts "*** Check! ***" if check?(@player.color)
          turn += 1
        end
      else
        puts "From #{move[0]} to #{move[1]} is not a valid move, please try again.\n"
        @game.show
      end
    end
  end
  
  def promotion(row)
    pawn = @game.board[row].shape
    if row[1] == "8" && pawn == "\u2659" # white pawn
      new = read_promotion("white")
      @game.board[row] = new
      @game.show
    elsif row[1] == "1" && pawn == "\u265F" # black pawn
      new = read_promotion("black")
      @game.board[row] = new
      @game.show
    end
  end
  
  def read_promotion(color)
    while true
      puts "Exchange pawn for? (write rook, knight, bishop or queen)"
      new = gets.chomp.downcase
      if ["rook", "knight", "bishop", "queen"].include? new
        case new
        when "rook"
          return Rook.new(color)
        when "knight"
          return Knight.new(color)
        when "bishop"
          return Bishop.new(color)
        when "queen"
          return Queen.new(color)
        end 
      else
        puts "Not a valid piece, please try again!"
      end
    end
  end
  
  def check?(color)
    king_color = color == "black" ? "\u2654" : "\u265A" 
    to_check = @game.board.select {|k,v| v != "*" && v.color == color}.keys
    cell = @game.board.select {|k,v| v != "*" && v.shape == king_color}.keys.join
    to_check.each do |piece|
      return true if possible_moves(piece).include? cell
    end
    false
  end
  
  def make_move(from, to)
    if !is_empty? to
      @player.color == "white" ? @lost_blacks << @game.board[to].shape : @lost_whites << @game.board[to].shape
    end
    @game.board[to] = @game.board[from]
    @game.board[from] = "*"
    puts "Removed black pieces: #{@lost_blacks.join(' ')}" if !@lost_blacks.empty?
    @game.show 
    puts "Removed white pieces: #{@lost_whites.join(' ')}" if !@lost_whites.empty?
  end
  
  def valid_move?(from, to)
    return false if is_empty?(from)
    return false if @player.color != @game.board[from].color
    opposite_color = @player.color == "white" ? "black" : "white" 
    pass = false
    temp = @game.board[to]
    @game.board[to] = @game.board[from]
    @game.board[from] = "*"
    if check?(opposite_color)
      puts "Your King will be in check!! Please try another move!\n"
      pass = true
    end
    @game.board[from] = @game.board[to]
    @game.board[to] = temp
    return false if pass
    possible_moves(from).include? to
  end
  
  def possible_moves(position)
    if is_empty?(position)
      []
    else
      case @game.board[position].shape
      when "\u2654", "\u265A"
        return valid_king_moves(position)
      when "\u2655", "\u265B"
        return (valid_moves_hv(position) + valid_moves_diagonal(position)).sort
      when "\u2656", "\u265C"
        return valid_moves_hv(position)
      when "\u2657", "\u265D"
        return valid_moves_diagonal(position)
      when "\u2658", "\u265E"
        return valid_knight_moves(position)
      when "\u2659", "\u265F" 
        return valid_pawn_moves(position)
      end
    end
  end
  
  private
  
  def valid_pawn_moves(position)
    letter = position[0]
    number = position[1].to_i
    possible_moves = []
    str = 'ABCDEFGH'
    start = str.index(letter)
    direction = @game.board[position].color == "white" ? 1 : -1
    pos1 = "#{letter}#{number+direction}"
    pos2 = "#{str[start-1]}#{number+direction}"
    pos3 = "#{str[start+1]}#{number+direction}"
    possible_moves << pos1 if is_empty?(pos1)
    possible_moves << pos2 if start-1 >= 0 && !is_empty?(pos2) && !same_color?(position, pos2)
    possible_moves << pos3 if start+1 < 8 && !is_empty?(pos3) && !same_color?(position, pos3)
    possible_moves
  end
  
  def valid_king_moves(position)
    letter = position[0]
    number = position[1].to_i
    possible_moves = []
    s = 'ABCDEFGHI'
    i = s.index(letter)
    [-1,0,1].each do |l|
      [-1,0,1].each do |n|
        pos = "#{s[i+l]}#{number+n}"
        possible_moves << pos if @game.board.key?(pos) && position != pos
      end
    end  
    possible_moves.keep_if { |p| is_empty?(p) || !same_color?(position,p) }
    possible_moves.sort
  end
  
  def valid_knight_moves(position)
    letter = position[0]
    number = position[1].to_i
    all_moves = []
    s = 'ABCDEFGH'
    i = s.index(letter)
    all_moves << "#{s[i-2]}#{number+1}" if (i-2 >= 0 && number+1 < 8)
    all_moves << "#{s[i-2]}#{number-1}" if (i-2 >= 0 && number-1 > 0)
    all_moves << "#{s[i+2]}#{number+1}" if (i+2 < 8 && number+1 < 8)
    all_moves << "#{s[i+2]}#{number-1}" if (i+2 < 8 && number-1 > 0)
    all_moves << "#{s[i-1]}#{number+2}" if (i-1 >= 0 && number+1 < 8)
    all_moves << "#{s[i-1]}#{number-2}" if (i-1 >= 0 && number-1 > 0)
    all_moves << "#{s[i+1]}#{number+2}" if (i+1 < 8 && number+1 < 8)
    all_moves << "#{s[i+1]}#{number-2}" if (i+1 < 8 && number-1 > 0)
    all_moves.keep_if { |p| is_empty?(p) || !same_color?(position, p) }
    all_moves.sort
  end
  
  def valid_moves_diagonal(position)
    letter = position[0]
    number = position[1]
    possible_moves = []
    start = 'ABCDEFGH'.index(letter)+1
    start = 7 if start > 7
    n = number.to_i + 1
    ('ABCDEFGH'[start]..'H').each do |l| 
      if @game.board.key?("#{l}#{n}")
        if @game.board["#{l}#{n}"] == "*" 
          possible_moves << "#{l}#{n}"
          n += 1
        else
          possible_moves << "#{l}#{n}" if !same_color?(position, "#{l}#{n}")
          break
        end
      end
    end

    n = number.to_i - 1
    ('ABCDEFGH'[start]..'H').each do |l| 
      if @game.board.key?("#{l}#{n}")
        if @game.board["#{l}#{n}"] == "*" 
          possible_moves << "#{l}#{n}"
          n -= 1
        else
          possible_moves << "#{l}#{n}" if !same_color?(position, "#{l}#{n}")
          break
        end
      end
    end

    start = 'ABCDEFGH'.index(letter)-1
    start = 0 if start < 0
    str = 'ABCDEFGH'[0..start].reverse.split("")
    n = number.to_i + 1
    str.each do |l| 
      if @game.board.key?("#{l}#{n}")
        if @game.board["#{l}#{n}"] == "*" 
          possible_moves << "#{l}#{n}"
          n += 1
        else
          possible_moves << "#{l}#{n}" if !same_color?(position, "#{l}#{n}")
          break
        end
      end
    end

    n = number.to_i - 1
    str.each do |l| 
      if @game.board.key?("#{l}#{n}")
        if @game.board["#{l}#{n}"] == "*" 
          possible_moves << "#{l}#{n}"
          n -= 1
        else
          possible_moves << "#{l}#{n}" if !same_color?(position, "#{l}#{n}")
          break
        end
      end
    end

    possible_moves.sort
  end
  
  def valid_moves_hv(position)
    letter = position[0]
    number = position[1]
    possible_moves = []

    (number.to_i - 1).downto(1) do |n| 
      if @game.board["#{letter}#{n}"] == "*"
        possible_moves << "#{letter}#{n}" 
      else
        possible_moves << "#{letter}#{n}" if !same_color?(position, "#{letter}#{n}") 
        break
      end
    end

    (number.to_i + 1).upto(8) do |n|
      if @game.board["#{letter}#{n}"] == "*"
        possible_moves << "#{letter}#{n}" 
      else
        possible_moves << "#{letter}#{n}" if !same_color?(position, "#{letter}#{n}") 
        break
      end
    end

    start = 'ABCDEFGH'.index(letter)+1
    start = 7 if start > 7
    ('ABCDEFGH'[start]..'H').each do |l| 
      if @game.board[l+number] == "*" 
        possible_moves << "#{l}#{number}"
      else
        possible_moves << "#{l}#{number}" if !same_color?(position, "#{l}#{number}")
        break
      end
    end

    start = 'ABCDEFGH'.index(letter)-1
    start = 0 if start < 0 
    ('ABCDEFGH'[start]..'H').each do |l| 
      if @game.board[l+number] == "*" 
        possible_moves << "#{l}#{number}"
      else
        possible_moves << "#{l}#{number}" if !same_color?(position, "#{l}#{number}")
        break
      end
    end
    possible_moves.sort
  end
  
  def is_empty?(position)
    @game.board[position] == "*"
  end
  
  def same_color?(first_position, second_position)
    @game.board[first_position].color == @game.board[second_position].color
  end
end

class Board
  attr_accessor :board, :white, :black

  def initialize
    @board = Hash.new
    'ABCDEFGH'.split("").each do |column|
      '87654321'.split("").each do |row|
        @board["#{column}#{row}"] = "*"
      end
    end
    @white = Player.new("white")
    @black = Player.new("black")
    ('A'..'H').each do |letter|
      @board[letter+'1'] = @white.pieces[letter+'1']
      @board[letter+'2'] = @white.pieces[letter+'2']
      @board[letter+'7'] = @black.pieces[letter+'7']
      @board[letter+'8'] = @black.pieces[letter+'8']
    end
   end
  
  def show
    '87654321'.split("").each do |row|
      print "#{row} "
      'ABCDEFGH'.split("").each do |column|
        if @board["#{column}#{row}"] == "*" 
          print " * "
        else
          print " " + @board["#{column}#{row}"].shape + " "
        end
      end
      print " #{row}"
      puts ""
    end
    puts "   A  B  C  D  E  F  G  H"
  end
end

class Player
  attr_accessor :pieces, :color
  
  def initialize(color)
    @color = color
    number = color == "white" ? '2' : '7' 
    @pieces = {}
    ('A'..'H').each do |letter|
      @pieces[letter+number] = Pawn.new(color)
    end
    number = number == '2' ? (number.to_i - 1).to_s : (number.to_i + 1).to_s
    @pieces['A'+number] = Rook.new(color)
    @pieces['H'+number] = Rook.new(color)
    @pieces['B'+number] = Knight.new(color)
    @pieces['G'+number] = Knight.new(color)
    @pieces['C'+number] = Bishop.new(color)
    @pieces['F'+number] = Bishop.new(color)
    @pieces['D'+number] = Queen.new(color)
    @pieces['E'+number] = King.new(color)
  end
  
  def read_move
    print "Move from: "
    from = validate_entry
    print "To: "
    to = validate_entry
    [from, to]
  end
  
  private
  def validate_entry
    while true
      pos = gets.chomp.to_s.upcase
      if (pos.length >= 2) && ('ABCDEFGH'.include? pos[0]) && ('12345678'.include? pos[1])
        break
      else
        puts "Invalid entry, please try again\n"
      end
    end  
    pos[0..1]
  end
end

class Piece
  attr_accessor :color, :shape
  
  def initialize(color)
    @color = color
  end
end

class Rook < Piece
  White_Rook = "\u2656"
  Black_Rook = "\u265C"
  def initialize(color)
    @shape = color == "white" ? White_Rook : Black_Rook
    @color = color
  end
end

class Knight < Piece
  White_Knight = "\u2658"
  Black_Knight = "\u265E"
  def initialize(color)
    @shape = color == "white" ? White_Knight : Black_Knight
    @color = color
  end
end

class Bishop < Piece
  White_Bishop = "\u2657"
  Black_Bishop = "\u265D"
  def initialize(color)
    @shape = color == "white" ? White_Bishop : Black_Bishop
    @color = color
  end
end

class Queen < Piece
  White_Queen = "\u2655"
  Black_Queen = "\u265B"
  def initialize(color)
    @shape = color == "white" ? White_Queen : Black_Queen
    @color = color
  end
end

class King < Piece
  White_King = "\u2654"
  Black_King = "\u265A"
  def initialize(color)
    @shape = color == "white" ? White_King : Black_King
    @color = color
  end
end

class Pawn < Piece
  White_Pawn = "\u2659"
  Black_Pawn = "\u265F"
  def initialize(color)
    @shape = color == "white" ? White_Pawn : Black_Pawn
    @color = color
  end
end
