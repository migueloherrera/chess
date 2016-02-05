require_relative "../chess.rb"

describe "Chess" do

  describe "#valid_moves_hv" do
    before :each do
      @chess = Chess.new
    end
    it "returns the possible moves for rook in 'A1' " do
      pm = @chess.possible_moves('A1')
      expect(pm).to eq([])
    end
    it "returns the possible moves for rook in 'H8' " do
      pm = @chess.possible_moves('H8')
      expect(pm).to eq([])
    end
    it "returns the possible moves for rook in 'A5' " do
      @chess.game.board['A5'] = @chess.game.board['A1']
      @chess.game.board['A1'] = "*"
      pm = @chess.possible_moves('A5')
      expect(pm).to eq(["A3", "A4", "A6", "A7", "B5", "C5", "D5", "E5", "F5", "G5", "H5"])
    end
    it "returns the possible moves for rook in 'A8' " do
      pm = @chess.possible_moves('A8')
      expect(pm).to eq([])
    end
  end

  describe "#valid_moves_diagonal" do
    before :each do
      @chess = Chess.new
      @chess.game.board['B3'] = @chess.game.board['B2']
      @chess.game.board['B2'] = "*"
    end
    it "returns an empty array for bishop in 'F8'" do
      pm = @chess.possible_moves('F8')
      expect(pm).to eq([])
    end
    it "returns ['A3','B2'] for bishop in 'C1'" do
      pm = @chess.possible_moves('C1')
      expect(pm).to eq(['A3','B2'])
    end
    it "returns ['A3','A5','C3','C5','D6'] for bishop in 'B4'" do
      @chess.game.board['B4'] = @chess.game.board['F8']
      @chess.game.board['F8'] = "*"
      pm = @chess.possible_moves('B4')
      expect(pm).to eq(['A3','A5','C3','C5','D2','D6'])
    end
  end

  describe "#valid_knight_moves" do
    before :each do
      @chess = Chess.new
      @chess.game.board['E4'] = @chess.game.board['G8']
      @chess.game.board['G8'] = "*"
    end
    it "returns ['A3','C3'] for knight in 'B1'" do
      @chess.game.show
      pm = @chess.possible_moves('B1')
      expect(pm).to eq(['A3','C3'])
    end
    it "returns ['C3','C5','D2','D6','F2','F6','G3','G5'] for knight in 'E4'" do
      pm = @chess.possible_moves('E4')
      expect(pm).to eq(['C3','C5','D2','D6','F2','F6','G3','G5'])
    end
  end
  
  describe "#valid_king_moves" do
    before :each do
      @chess = Chess.new
      @chess.game.board['D6'] = @chess.game.board['E1']
      @chess.game.board['E1'] = "*"
    end
    it "return an empty array for king in 'E8'" do
      pm = @chess.possible_moves('E8')
      expect(pm).to eq([])
    end
    it "return ['C5','C6','C7','D5','D7','E5','E6','E7'] for king in 'D6'" do
      pm = @chess.possible_moves('D6')
      expect(pm).to eq(['C5','C6','C7','D5','D7','E5','E6','E7'])
    end
    it "return ['G5','G6','H5'] for king in 'H6'" do
      @chess.game.board['H6'] = @chess.game.board['E8']
      @chess.game.board['E8'] = "*"
      pm = @chess.possible_moves('H6')
      expect(pm).to eq(['G5','G6','H5'])
    end
  end
  
  describe "#valid_pawn_moves" do
    before :each do
      @chess = Chess.new
      @chess.game.board['F3'] = @chess.game.board['F7']
      @chess.game.board['F7'] = "*"
      @chess.game.board['C6'] = @chess.game.board['C2']
      @chess.game.board['C2'] = "*"
    end
    it "returns ['A3'] for pawn in 'A2'" do
      pm = @chess.possible_moves('A2')
      expect(pm).to eq(['A3'])
    end
    it "returns ['H6'] for pawn in 'H7'" do
      pm = @chess.possible_moves('H7')
      expect(pm).to eq(['H6'])
    end
    it "returns ['E2', 'G2'] for pawn in 'F3'" do
      pm = @chess.possible_moves('F3')
      expect(pm).to eq(['E2', 'G2'])
    end
    it "returns ['B7', 'D7'] for pawn in 'C6'" do
      pm = @chess.possible_moves('C6')
      expect(pm).to eq(['B7','D7'])
    end
  end
  
  describe "valid moves for the queen" do
    before :each do
      @chess = Chess.new
      @chess.game.board['D4'] = @chess.game.board['D1']
      @chess.game.board['D1'] = "*"
    end
    it "returns an empty array for queen in 'D8'" do
      pm = @chess.possible_moves('D8')
      expect(pm).to eq([])
    end
    it "returns ['A7','B6','C3','C4','C5','D3','D5','D6','D7','E3','E4','E5','F4','F6','G4','G7','H4'] for queen in 'D4'" do
      pm = @chess.possible_moves('D4')
      expect(pm).to eq(['A7','B6','C3','C4','C5','D3','D5','D6','D7','E3','E4','E5','F4','F6','G4','G7','H4'])
    end
  end

  describe "#valid_move?" do
    before :each do
      @chess = Chess.new
    end
    it "returns false for the move from 'A1' to 'A2'" do
      move = @chess.valid_move?('A1','A2')
      expect(move).to eq(false)
    end
    it "returns true for the move from 'B2' to 'B3'" do
      move = @chess.valid_move?('B2','B3')
      expect(move).to eq(true)
    end
  end
end

describe "Player" do
  before :each do
    @white = Player.new("white")
  end
  describe "#read_move" do
    it "returns ['A2', 'A3']" do
      allow(@white).to receive(:gets).and_return('A2\n','A3\n')
      move = @white.read_move
      expect(move).to eq(['A2', 'A3'])
    end
  end
end
#   Player: 
#     white and black, pieces, moves_piece_to(piece, destination) 
#   Pieces: Rook, Knight, Bishop, Queen, King, Pawn
#   

# 2.- Initial position, first row: rook, knight, bishop, queen, king, bishop, knight, and rook; second row: pawns
# 3.- The player with the white pieces always moves first. After the first move, players alternately move one piece per turn (except for castling, when two pieces are moved). Pieces are moved to either an unoccupied square or one occupied by an opponent's piece, which is captured and removed from play. With the sole exception of en passant, all pieces capture by moving to the square that the opponent's piece occupies. A player may not make any move that would put or leave his or her king under attack. A player cannot "pass"; at each turn they have to make a legal move (this is the basis for the finesse called zugzwang). If the player to move has no legal move, the game is over; it is either a checkmate (a loss for the player with no legal moves) if the king is under attack, or a stalemate (a draw) if the king is not.
# 4.- The king moves one square in any direction. The king has also a special move which is called castling and involves also moving a rook.

# 5.- The rook can move any number of squares along any rank or file, but may not leap over other pieces. Along with the king, the rook is involved during the king's castling move.
# 6.- The bishop can move any number of squares diagonally, but may not leap over other pieces.
# 7.- The queen combines the power of the rook and bishop and can move any number of squares along rank, file, or diagonal, but it may not leap over other pieces.
# 8.- The knight moves to any of the closest squares that are not on the same rank, file, or diagonal, thus the move forms an "L"-shape: two squares vertically and one square horizontally, or two squares horizontally and one square vertically. The knight is the only piece that can leap over other pieces.
# 9.- The pawn may move forward to the unoccupied square immediately in front of it on the same file, or on its first move it may advance two squares along the same file provided both squares are unoccupied (black "●"s in the diagram); or the pawn may capture an opponent's piece on a square diagonally in front of it on an adjacent file, by moving to that square (black "x"s). The pawn has two special moves: the en passant capture and pawn promotion.

# 10.- When a king is under immediate attack by one or two of the opponent's pieces, it is said to be in check. 
# 11.- Promotion. Change the pawn to something else when it reaches the 8th row.
