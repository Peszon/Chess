# frozen_string_literal: true

# ./spec/board_spec.rb
require './lib/board'

describe Board do
  let(:board) { Board.new }
  $board = Array.new(8) { Array.new(8) }

  describe '#initalize' do
    it 'boardsetup' do
      expect(board.board[0][3].subclass).to eql('queen')
      expect(board.board[0][4].subclass).to eql('king')
      expect(board.board[1][6].subclass).to eql('pawn')
      expect(board.board[7][5].subclass).to eql('bishop')
      expect(board.board[7][6].subclass).to eql('knight')
      expect(board.board[7][7].subclass).to eql('rook')
      expect(board.board[0][0].colour).to eql('white')
      expect(board.board[7][0].colour).to eql('black')
    end

    it 'move history' do
      expect(board.move_history).to eql([])
    end

    it 'players' do
      expect(board.instance_variable_get(:@players)[0]).to be_an_instance_of(Player)
      expect(board.instance_variable_get(:@players).length).to eql(2)
    end

    it 'next move' do
      expect(board.instance_variable_get(:@next_move).colour).to eql('white')
    end
  end

  describe '::setting the board' do
    it 'should set up all the pieces in standard formation' do # already tested that the pieces are positioned correctly in intialize
      allow(:Board).to recive(:setting_the_board)
      expect(Board.new).to recive(:setting_the_board)
    end
  end

  describe '#move_piece' do
    it 'should move the piece' do
      expect(board.board[1][0].subclass).to eql('pawn')
      expect(board.board[2][0]).to eql(nil)
      move_piece([1, 0], [2, 0])
      expect(board.board[1][0]).to eql(nil)
      expect(board.board[2][0].subclass).to eql('pawn')
    end

    it 'add to the move history' do
      expect(board.move_history).to eql([])
      board.move_piece([1, 0], [2, 0])
      expect(board.move_history).to eql([[[1, 0], [2, 0]]])
    end

    it 'should switch player that occupies @next_move' do
      expect(board.instance_variable_get(:@next_move).colour).to eql('white')
      board.move_piece([1, 0], [2, 0])
      expect(board.instance_variable_get(:@next_move).colour).to eql('black')
    end
  end

  describe '#check_move?' do
    describe 'should return false when' do
      it 'a friendly piece occupies the selected square' do
        board.board[2][0] = Piece.new('white', 'pawn')
        expect(check_move?([1, 0], [2, 0])).to be false
      end

      it 'your king is checked and the move doesnt remove the check' do
        board.board[1][4] = nil
        board.board[2][4] = Piece.new('rook', 'black')
        expect(check_move?([1, 0], [2, 0])).to be false
      end

      it "it isn't a legal move for the piece" do
        expect(check_move?([1, 0], [4, 0])).to be false
      end

      it 'the move is out of bounds' do
        board.board[1][0] = Piece.new('rook', 'white')
        expect(check_move?([1, 0], [9, 3])).to be false
      end

      it "there isn't a controllable piece on the selected square" do
        expect(check_move?([3, 0], [4, 0])).to be false
      end

      it 'the piece jumps over another piece' do
        expect(check_move?([0, 0], [5, 0])).to be false
        board.board[3][0] = Piece.new('black', 'pawn')
        board.board[1][0] = nil
        expect(check_move?([0, 0], [5, 0])).to be false
      end
    end

    describe 'special pawn rules: ' do
      it "shouldn't move forward when there is a piece in the way; friendly or not" do
        board.board[0][0] = Piece.new('white', 'pawn')
        expect(check_move?([0, 0][1, 0])).to be false
        board.board[0][0] = Piece.new('black', 'pawn')
        expect(check_move?([0, 0][1, 0])).to be false
      end

      it "should be able to move two steps forward if it's on the first row and nothing is in it's path" do
        expect(check_move?([1, 0][3, 0])).to be true
        board.board[2][0] = Piece.new('white', 'pawn')
        expect(check_move?([1, 0][3, 0])).to be false
      end

      it 'should only be able to move diagonally when it takes' do
        expect(check_move?([1, 0][2, 1])).to be false
        board.board[2][1] = Piece.new('black', 'pawn')
        board.board[2][3] = Piece.new('white', 'pawn')
        expect(check_move?([1, 0][2, 1])).to be true
        expect(check_move?([1, 0][2, 1])).to be false
      end

      it 'en-passant' do
        board.board[3][1] = Piece.new('black', 'pawn')
        board.make_move([1, 0], [3, 0])
        expect(check_move?([3, 1], [2, 0])).to be true
      end
    end
  end
end
