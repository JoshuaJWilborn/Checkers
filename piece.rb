class Piece
  
  attr_reader :color
  def initialize(color)
    @color = color
    @king = false    
    @string = " ● "
    set_vectors  
  end
  
  def king
    unless @king
      if @color == :w
        @vectors << [1,-1] << [1,1]
      else
        @vectors << [[-1,-1], [-1,1]]
      end
      @king = true
      @string = " ■ "
    end
  end
  
  def to_s
    @string
  end
  
  def set_vectors
    if @color == :w
      @vectors = [[-1,-1], [-1,1]]
    else
      @vectors = [[1,-1], [1,1]]
    end
  end
end
