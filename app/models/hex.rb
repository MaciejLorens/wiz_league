class Hex
  include Mongoid::Document
  include Mongoid::Timestamps

  field :q, type: Integer
  field :r, type: Integer
  field :x, type: Integer
  field :y, type: Integer
  field :z, type: Integer
  field :terrain, type: String
  field :user_id, type: Integer

  TERRAIN = %w[road grass river mountain]

  scope :nearby, -> (location, range) do
    where(q: (location[0] - range)..(location[0] + range), r: (location[1] - range)..(location[1] + range))
  end

  def neighbors(range)
    self.class.nearby(location, range).order(r: :asc, q: :asc).select { |hex| self.distance(hex) <= range }
  end

  def distance(hex)
    ((self.x - hex.x).abs + (self.y - hex.y).abs + (self.z - hex.z).abs) / 2
  end

  def location
    [q, r]
  end

end
