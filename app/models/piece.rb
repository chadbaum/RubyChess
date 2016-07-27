# Piece superset behavior.
class Piece < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  validates :color, inclusion: { in: %w(black white) }
  validates :type, inclusion: { in: %w(Pawn Rook Bishop Knight King Queen) }

  # Returns true, updates the piece's x and y position
  # to provided coordinates if move is valid, and sets
  # the moved flag to true otherwise do nothing and
  # return false.
  def move!(x, y)
    return false unless valid_move?(x, y)
    victim = occupied?(x, y)
    if victim
      return false unless capturable?(victim)
      capture!(victim)
    end
    update(x_position: x, y_position: y, moved: true)
    true
  end

  # All validation assumes white player is on the
  # 6-7 rows of the array, and black player is on
  # 0-1 rows of the array.
  private

  # if piece is capturable change piece's attributes
  def capture!(victim)
    victim.update(x_position: nil, y_position: nil, captured: true)
  end

  # Returns true if position is occupied by a hostile piece.
  def capturable?(victim)
    color != victim.color
  end

  def occupied?(x, y)
    game.pieces.find_by(x_position: x, y_position: y)
  end

  # Compares a piece's x_position with the
  # coordinate provided and returns the
  # distance between the two.
  def x_distance(new_x_coordinate)
    (x_position - new_x_coordinate).abs
  end

  # Compares a piece's y_position with the
  # coordinate provided and returns the
  # distance between the two.
  def y_distance(new_y_coordinate)
    (y_position - new_y_coordinate).abs
  end

  # Returns true if the coordinates provided
  # are different from the piece's starting
  # position.
  def moved?(x, y)
    x != x_position || y != y_position
  end

  # Returns true if the coordinates provided
  # have the same x-axis value and there are no
  # pieces in between.
  def clear_horizontal_move?(x, y)
    return false unless y_distance(y) == 0
    distance = x_distance(x)
    path_clear?(x, y, distance)
  end

  # Returns true if the coordinates provided
  # have the same y-axis value and there are no
  # pieces in between.
  def clear_vertical_move?(x, y)
    return false unless x_distance(x) == 0
    distance = y_distance(y)
    path_clear?(x, y, distance)
  end

  # Returns true if the coordinates provided
  # are the same distance away from the
  # origin point along both axis and there are no
  # pieces in between.
  def clear_diagonal_move?(x, y)
    return false unless x_distance(x) == y_distance(y)
    distance = x_distance(x)
    path_clear?(x, y, distance)
  end

  # Class constants used to determine path direction
  # for obstruction logic.
  RIGHT = 1
  LEFT = -1
  DOWN = 1
  UP = -1

  # Returns a hash with 1 or -1 values for
  # x and y based on whether those values are
  # increasing or decreasing towards destination
  # to determine direction of path along both axis.
  def path_direction(x, y)
    direction = {}
    direction[:x] = if x_position < x then RIGHT
                    elsif x_position > x then LEFT
                    else 0
                    end
    direction[:y] = if y_position < y then DOWN
                    elsif y_position > y then UP
                    else 0
                    end
    direction
  end

  # Returns an array of x-y coordinate subarrays
  # between origin and destination.
  def generate_path_coordinates(x, y, distance)
    coordinate_sets = []
    direction = path_direction(x, y)
    (distance - 1).times do |i|
      i += 1
      coordinate_sets << [
        x_position + i * direction[:x],
        y_position + i * direction[:y]
      ]
    end
    coordinate_sets
  end

  # Returns true if no x-y coordinate pairs
  # between origin and destination have a piece
  # present.
  def path_clear?(x, y, distance)
    coordinates = generate_path_coordinates(x, y, distance)
    coordinates.each do |coordinate|
      return false if game.pieces.find_by(
        x_position: coordinate[0],
        y_position: coordinate[1]
      )
    end
    true
  end
end
