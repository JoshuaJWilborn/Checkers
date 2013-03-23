class Board
  PIECES_TO_COLOR = {:w => :light_white, :b => :light_black}
  BACKGROUND_COLOR = [:black, :white]
  attr_accessor :board, :kills, :kill_pos
  def initialize
    build_board
  end
  
  def build_board

    board = []
    8.times do |row_num|
      if (0..2).to_a.include?(row_num)
        board << build_row(:w, row_num)
      elsif (3..4).to_a.include?(row_num)  
        board << Array.new(10, nil)
      elsif (5..7).to_a.include?(row_num)
        board << build_row(:b, row_num)
      end
    end
    @board = board
  end
  
  def build_row(color, offset)
    row = []
    5.times do
      if offset.even?
        row << Piece.new(color)
        row << nil
      else
        row << nil
        row << Piece.new(color)
      end
    end
    row
  end
  
  def display
    color_index = 0
    puts (' ' * 20) + '||' + ('=' * 30) + '||'
    @board.each_with_index do |row, row_num|
      print ' ' * 20
      row_display = '||'
      row.each_with_index do |space, col_num|
        space_display = ''
        if space.nil?
          space_display << '   '
        else
          space_display << space.to_s
        end
        if space
          color = space.color
        else
          color = :w
        end
        row_display << space_display.colorize({:color => PIECES_TO_COLOR[color], :background => BACKGROUND_COLOR[color_index]})
        color_index = color_index == 0 ? 1 : 0 
      end
      row_display << "||"
      print "#{row_display}\n"
      color_index = color_index == 0 ? 1 : 0 
    end
    puts (' ' * 20) + '||' + ('=' * 30) + '||'
  end
  
  def on_board?(start, finish = [0,0])
    if ( (0..7).include?(start[0]) && (0..9).include?(start[1])  &&
      (0..7).include?(finish[0]) && (0..9).include?(finish[1]) )
      return true
    end
    false
  end
  
  def opp_color?(start, finish)
    @board[start[0]][start[1]].color != @board[finish[0]][finish[1]]
  end
  
  def empty?(coords)
    @board[coords[0]][coords[1]].nil?
  end
  
  def kill(coords)
    @board[coords[0]][coords[1]] = nil
  end
  
  def get_piece(coords)
    return nil if coords.nil?
    @board[coords[0]][coords[1]]
  end
  
  def kingable?(coords)
    return false unless on_board?(coords)
    piece = @board[coords[0]][coords[1]]
    if piece && piece.color == :w && coords[0] == 7
      true
    elsif piece && piece.color == :b && coords[0] == 0
      true
    else
      false
    end
  end
  
  def complete_move(start, finish)
    @board[finish[0]][finish[1]] = @board[start[0]][start[1]]
    @board[start[0]][start[1]] = nil
    if kingable?(finish)
      get_piece(finish).king
    end
  end
  
  def move_piece(start, finish) 
    return false unless valid_move?(start, finish)
    complete_move(start, finish)
    distance = distance(start, finish)     
    case distance
    when 1
      @kills = false
      @kill_pos = nil
    when 2
      vector = vector_once(start, finish)
      take_piece_coords = [(start[0] + vector[0]), (start[1] + vector[1])]
      kill(take_piece_coords)
      @kills = true
      @kill_pos = finish
    end
    true
  end
  
  def valid_move?(start, finish)
    return false unless (!empty?(start) && empty?(finish) &&
                         direction_valid?(start, finish) &&
                         on_board?(start, finish) )
    distance = distance(start, finish)     
    case distance
    when 1
      true
    when 2
      vector = vector_once(start, finish)
      take_piece_coords = [(start[0] + vector[0]), (start[1] + vector[1])]
      return true if ( empty?(finish) && opp_color?(start, take_piece_coords))
      false
    else
      false
    end
  end
  
  def vector_once(start, finish)
    row, col = (finish[0] - start[0]), (finish[1] - start[1])
    finished = false
    until finished
    finished = true
      row, col = [row,col].map do |coord|
        if coord < -1
          finished = false
          coord + 1
        elsif coord > 1
          finished = false
          coord - 1
        else
          coord  
        end
      end
      [row, col]
    end
    [row, col]    
  end
  
  def direction(start, finish)
    piece = @board[start[0]][start[0]]
    row, col = (finish[0] - start[0]), (finish[1] - start[1])
    piece.vectors.select
  end  
  
  def direction_valid?(start, finish)
    row, col = (finish[0] - start[0]), (finish[1] - start[1])
    return true if row.abs == col.abs
    false
  end
  
  def distance(start, finish)
    #moves will always be diagonal, only one coord must be checked
    distance = (finish[0] - start[0]).abs
  end
  
  def won?
    @board.flatten.compact.select {|piece| piece.color == :b ||
                                           piece.color == :w }.empty?
  end
  
  def winner?
    return nil unless won?
    if @board.flatten.compact.select {|piece| piece.color == :b}.empty?
      return :w
    else
      return :b 
    end 
  end 
end
