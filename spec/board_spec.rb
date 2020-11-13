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

	descirbe '#check_move?' do
		descirbe 'should return false when' do
			it 'a friendly piece occupies the selected square' do
				board.board[2][0] = Piece.new('white', 'pawn', nil)
				expect(check_move?([1,0], [2,0])).to be false
			end 
		end 
  end
end
