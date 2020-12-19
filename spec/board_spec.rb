# frozen_string_literal: true

# ./spec/board_spec.rb
require './lib/board'

describe Board do
  let(:board) { Board.new }

  describe '#initalize' do
    it 'boardsetup' do
      expect(board.board[0][3].subclass).to eql('queen')
      expect(board.board[0][4].subclass).to eql('king')
      expect(board.board[1][6].subclass).to eql('pawn')
      expect(board.board[7][5].subclass).to eql('bishop')
      expect(board.board[7][6].subclass).to eql('knight')
      expect(board.board[7][7].subclass).to eql('rook')
      expect(board.board[0][0].color).to eql('white')
      expect(board.board[7][0].color).to eql('black')
    end

    it 'move history' do
      expect(board.move_history).to eql([])
    end

    it 'players' do
      expect(board.instance_variable_get(:@players)[0]).to be_an_instance_of(Player)
      expect(board.instance_variable_get(:@players).length).to eql(2)
    end

    it 'next move' do
      expect(board.instance_variable_get(:@next_move).color).to eql('white')
    end
  end

  describe '#move_piece' do
    it 'should move the piece' do
      expect(board.board[1][0].subclass).to eql('pawn')
      expect(board.board[2][0]).to eql(nil)
      board.move_piece([1, 0], [2, 0])
      expect(board.board[1][0]).to eql(nil)
      expect(board.board[2][0].subclass).to eql('pawn')
    end

    it 'add to the move history' do
      expect(board.move_history).to eql([])
      board.move_piece([1, 0], [2, 0])
      expect(board.move_history).to eql([[[1, 0], [2, 0], 32]])
    end

    it 'should switch player that occupies @next_move' do
      expect(board.instance_variable_get(:@next_move).color).to eql('white')
      board.move_piece([1, 0], [2, 0])
      expect(board.instance_variable_get(:@next_move).color).to eql('black')
    end
  end

  describe '#check_move?' do
    describe 'should return false when' do
      it 'a friendly piece occupies the selected square' do
        board.board[2][0] = Piece.new('pawn', 'white')
        expect(board.check_move?([1, 0], [2, 0])).to be false
      end

      it 'your king is checked and the move doesnt remove the check' do
        board.board[1][4] = nil
        board.board[2][4] = Piece.new('rook', 'black')
        expect(board.check_move?([1, 0], [2, 0])).to be false
      end

      it "it isn't a legal move for the piece" do
        expect(board.check_move?([1, 1], [4, 1])).to be false
        expect(board.check_move?([1, 1], [3, 3])).to be false
        expect(board.check_piece_moves?([1, 1], [2, 1])).to be true
      end

      it 'the move is out of bounds' do
        board.board[1][0] = Piece.new('rook', 'white')
        expect(board.check_move?([1, 0], [9, 3])).to be false
      end

      it "there isn't a controllable piece on the selected square" do
        expect(board.check_move?([3, 0], [4, 0])).to be false
      end

      it 'the piece jumps over another piece' do
        expect(board.check_move?([0, 0], [5, 0])).to be false
        board.board[3][0] = Piece.new('pawn', 'black')
        board.board[1][0] = nil
        expect(board.check_move?([0, 0], [5, 0])).to be false #here something is wonky
      end
    end

    describe 'special pawn rules: ' do
      it "shouldn't move forward when there is a piece in the way; friendly or not" do
        expect(board.check_move?([1, 0], [2, 0])).to be true
        board.board[0][0] = Piece.new('pawn', 'white')
        expect(board.check_move?([0, 0], [1, 0])).to be false
        board.board[2][0] = Piece.new('pawn', 'black')
        expect(board.check_move?([2, 0], [1, 0])).to be false

        expect(board.check_move?([1, 1], [3, 1])).to be true
        board.board[2][0] = Piece.new('pawn', 'black')
        expect(board.check_move?([1, 0], [3, 0])).to be false
      end

      it "should be able to move two steps forward if it's on the first row and nothing is in it's path" do
        expect(board.check_move?([1, 0], [3, 0])).to be true
        board.board[2][0] = Piece.new('pawn', 'white')
        expect(board.check_move?([1, 0], [3, 0])).to be false
      end

      it 'should only be able to move diagonally when it takes' do
        expect(board.check_move?([1, 0], [2, 1])).to be false
        board.move_piece([1,4], [2,4])
        board.move_piece([6,1], [6,2])
        board.board[2][1] = Piece.new('pawn', 'black')
        board.board[2][3] = Piece.new('pawn', 'white')
        expect(board.check_move?([1, 0], [2, 1])).to be true
        expect(board.check_move?([1, 0], [2, 3])).to be false
      end

      it 'en-passant' do
        board.board[3][1] = Piece.new('pawn', 'black')
        board.move_piece([1, 0], [3, 0])
        expect(board.check_move?([3, 1], [2, 0])).to be true
      end
    end

    describe 'should return true when' do
      it 'nothing is false' do
        expect(board.check_move?([1, 0], [2, 0])).to be true
      end
    end
  end

  describe '#game_over?' do
    it 'returns true when lost? returns true' do
      allow(board).to receive(:lost?).and_return(true)
      expect(board.game_over?).to be true
    end

    it 'returns true when draw? returns true' do
      allow(board).to receive(:draw?).and_return(true)
      expect(board.game_over?).to be true
    end

    it 'returns false when lost? and draw? are false' do
      allow(board).to receive(:lost?).and_return(false)
      allow(board).to receive(:draw?).and_return(false)
      expect(board.game_over?).to be false
    end

    describe '#draw?' do
      before(:each) { board.instance_variable_set(:@board, Array.new(8) { Array.new(8) }) }

      it 'should return true if the player cant make a legal move' do
        board.board = Array.new(8) { Array.new(8) }
        board.board[7][1] = Piece.new('rook', 'black')
        board.board[1][7] = Piece.new('rook', 'black')
        board.board[0][0] = Piece.new('king', 'white')
        board.instance_variable_set(:@next_move, Player.new("white"))

        expect(board.draw?).to be true
      end

      it 'should return true if more than fifty moves were played without a taken piece' do
        50.times do
          board.move_piece([rand(8), rand(8)], [rand(8), rand(8)])
        end

        expect(board.draw?).to be true
      end

      it 'should return false if there is a legal move' do
        board.board[7][1] = Piece.new('rook', 'black')
        board.board[1][7] = Piece.new('rook', 'black')
        board.board[0][0] = Piece.new('king', 'white')
        board.board[6][5] = Piece.new('pawn', 'white')
        board.instance_variable_set(:@next_move, Player.new('white'))

        expect(board.draw?).to be false
      end
    end

    describe '#lost?' do
      before(:each) { board.instance_variable_set(:@board, Array.new(8) { Array.new(8) }) }

      it 'should return true if there are no possible ways to escape the check' do
        board.board = Array.new(8) { Array.new(8) }
        board.board[0][7] = Piece.new('rook', 'black')
        board.board[1][0] = Piece.new('pawn', 'white')
        board.board[1][1] = Piece.new('pawn', 'white')
        board.board[0][0] = Piece.new('king', 'white')

        board.instance_variable_set(:@next_move, Player.new('white'))

        expect(board.lost?).to be true
      end

      it 'should return false if there are possible ways to escape the check' do
        board.board[0][7] = Piece.new('pawn', 'white')
        board.board[1][0] = Piece.new('pawn', 'white')
        board.board[1][1] = Piece.new('king', 'white')
        board.board[5][6] = Piece.new('rook', 'white')
        board.board[0][0] = Piece.new('rook', 'black')

        board.instance_variable_set(:@next_move, Player.new('white'))

        expect(board.lost?).to be false
      end
    end
  end
end
