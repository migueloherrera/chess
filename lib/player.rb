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
