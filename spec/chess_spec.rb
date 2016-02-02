require_relative "../chess.rb"

describe "Chess" do
  describe "#possible_moves" do
    before :each do
      @chess = Chess.new
    end
    it "returns the possible moves for rook in 'A1' " do
      pm = @chess.possible_moves('A1')
      expect(pm).to eq([])
    end
    it "returns the possible moves for rook in 'A5' " do
      @chess.game.board['A5'] = @chess.game.board['A1']
      puts @chess.game.board['A5'].position # TO DO: delete the position attribute from the Piece object
      @chess.game.board['A1'] = "*"
      @chess.game.show 
      pm = @chess.possible_moves('A5')
      expect(pm).to eq(["A3", "A4", "A6", "A7", "B5", "C5", "D5", "E5", "F5", "G5", "H5"])
    end
  end
end


# Objects: 
#   Board: 
#     8x8 grid, piece_in_position 
#   Player: 
#     white and black, pieces, moves_piece_to(piece, destination) 
#   Piece: 
#     type, position, color, can_move_to
#   Pieces: Rook, Knight, Bishop, Queen, King, Pawn
#   
# 1.- create a board with 8 black pieces and 8 whites pieces 
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
