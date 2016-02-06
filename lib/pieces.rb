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
