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
