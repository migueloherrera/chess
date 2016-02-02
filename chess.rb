class Chess
  attr_accessor :game
  def initialize
    @game = Board.new
  end
  def possible_moves(position)
    if @game.board[position] != "*"
      case @game.board[position].shape
      when "\u2654" 
        return "White_King"
      when "\u2655" 
        return "White_Queen"
      when "\u2656" 
        return rook_valid_moves(position)
      when "\u2657" 
        return "White_Bishop"
      when "\u2658" 
        return "White_Knight"
      when "\u2659" 
        return "White_Pawn"
      when "\u265A" 
        return "Black_King"
      when "\u265B" 
        return "Black_Queen"
      when "\u265C" 
        return "Black_Rook"
      when "\u265D" 
        return "Black_Bishop"
      when "\u265E" 
        return "Black_Knight"
      when "\u265F" 
        return "Black_Pawn"
      end
    end
  end
  
  def rook_valid_moves(position)
    letter = position[0]
    number = position[1]
    possible_moves = []
    (number.to_i - 1).downto(1) do |n| 
      if @game.board["#{letter}#{n}"] == "*"
        possible_moves << "#{letter}#{n}" 
      else
        possible_moves << "#{letter}#{n}" if @game.board[position].color != @game.board["#{letter}#{n}"].color 
        break
      end
    end
    (number.to_i + 1).upto(8) do |n|
    if @game.board["#{letter}#{n}"] == "*"
        possible_moves << "#{letter}#{n}" 
      else
        possible_moves << "#{letter}#{n}" if @game.board[position].color != @game.board["#{letter}#{n}"].color 
        break
      end
    end
    start = 'ABCDEFGH'.index(letter)+1
    ('ABCDEFGH'[start]..'H').each do |l| 
      if @game.board[l+number] == "*" 
        possible_moves << "#{l}#{number}"
      else
        possible_moves << "#{l}#{number}" if @game.board[position].color != @game.board["#{l}#{number}"].color
        break
      end
    end
    start = 'ABCDEFGH'.index(letter)-1
    start = 0 if start < 0 
    ('ABCDEFGH'[start]..'H').each do |l| 
    if @game.board[l+number] == "*" 
        possible_moves << "#{l}#{number}"
      else
        possible_moves << "#{l}#{number}" if @game.board[position].color != @game.board["#{l}#{number}"].color
        break
      end
    end
    possible_moves.sort
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
      'ABCDEFGH'.split("").each do |column|
        if @board["#{column}#{row}"] == "*" 
          print " * "
        else
          print " " + @board["#{column}#{row}"].shape + " "
        end
      end
      puts ""
    end
    puts " A  B  C  D  E  F  G  H"
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
