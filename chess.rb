class Chess
  attr_accessor :game
  def initialize
    @game = Board.new
  end
  def possible_moves(position)
    if !is_empty?(position)
      case @game.board[position].shape
      when "\u2654", "\u265A"
        return "White_King"
      when "\u2655", "\u265B"
        return "White_Queen"
      when "\u2656", "\u265C"
        return rook_valid_moves(position)
      when "\u2657", "\u265D"
        return bishop_valid_moves(position)
      when "\u2658", "\u265E"
        return "White_Knight"
      when "\u2659", "\u265F" 
        return "White_Pawn"
      end
    end
  end
  
  def bishop_valid_moves(position)
    letter = position[0]
    number = position[1]
    possible_moves = []
    start = 'ABCDEFGH'.index(letter)+1
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
  
  def rook_valid_moves(position)
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
  attr_accessor :board

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
      puts ""
    end
    puts "   A  B  C  D  E  F  G  H"
  end
end

class Player
  attr_accessor :pieces
  
  def initialize(color)
    @color = color
    number = color == "white" ? '2' : '7' 
    @pieces = {}
    ('A'..'H').each do |letter|
      @pieces[letter+number] = Pawn.new(letter+number, color)
    end
    number = number == '2' ? (number.to_i - 1).to_s : (number.to_i + 1).to_s
    @pieces['A'+number] = Rook.new('A'+number, color)
    @pieces['H'+number] = Rook.new('H'+number, color)
    @pieces['B'+number] = Knight.new('B'+number, color)
    @pieces['G'+number] = Knight.new('G'+number, color)
    @pieces['C'+number] = Bishop.new('C'+number, color)
    @pieces['F'+number] = Bishop.new('F'+number, color)
    @pieces['D'+number] = Queen.new('D'+number, color)
    @pieces['E'+number] = King.new('E'+number, color)
  end
end

class Piece
  attr_accessor :position, :color, :shape
  
  def initialize(position, color)
    @position = position
    @color = color
  end
end

class Rook < Piece
  White_Rook = "\u2656"
  Black_Rook = "\u265C"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_Rook : Black_Rook
    @color = color
  end
end

class Knight < Piece
  White_Knight = "\u2658"
  Black_Knight = "\u265E"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_Knight : Black_Knight
    @color = color
  end
end

class Bishop < Piece
  White_Bishop = "\u2657"
  Black_Bishop = "\u265D"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_Bishop : Black_Bishop
    @color = color
  end
end

class Queen < Piece
  White_Queen = "\u2655"
  Black_Queen = "\u265B"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_Queen : Black_Queen
    @color = color
  end
end

class King < Piece
  White_King = "\u2654"
  Black_King = "\u265A"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_King : Black_King
    @color = color
  end
end

class Pawn < Piece
  White_Pawn = "\u2659"
  Black_Pawn = "\u265F"
  def initialize(position, color)
    @position = position
    @shape = color == "white" ? White_Pawn : Black_Pawn
    @color = color
  end
end
