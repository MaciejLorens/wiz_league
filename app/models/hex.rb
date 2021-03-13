class Hex
  include CableReady::Broadcaster
  delegate :render, to: ApplicationController

  include Mongoid::Document
  include Mongoid::Timestamps

  field :q, type: Integer
  field :r, type: Integer
  field :x, type: Integer
  field :y, type: Integer
  field :z, type: Integer
  field :terrain, type: String
  field :user_id, type: String

  has_and_belongs_to_many :spells
  belongs_to :user, optional: true

  TERRAIN = %w[road grass river mountain]

  scope :nearby, -> (location, range) do
    where(q: (location[0] - range)..(location[0] + range), r: (location[1] - range)..(location[1] + range))
  end

  def neighbors(range)
    self.class.nearby(location, range).order(r: :asc, q: :asc).select { |hex| self.distance(hex) <= range }
  end

  def location
    [q, r]
  end

  def stamina_required
    case terrain
    when 'road' then
      100;
    when 'grass' then
      200;
    when 'river' then
      300;
    when 'mountain' then
      400;
    end
  end

  def hex_linedraw(hex)
    distance = distance(hex)

    (0..distance).map do |i|
      hex_round(hex_lerp(hex, 1.0 / distance * i))
    end
  end

  def hex_lerp(hex, t)
    x = lerp(self.x, hex.x, t)
    y = lerp(self.y, hex.y, t)
    z = lerp(self.z, hex.z, t)
    {x: x, y: y, z: z}
  end

  def hex_round(hex_lerp)
    rx = (hex_lerp[:x]).round
    ry = (hex_lerp[:y]).round
    rz = (hex_lerp[:z]).round

    x_diff = (rx - hex_lerp[:x]).abs
    y_diff = (ry - hex_lerp[:y]).abs
    z_diff = (rz - hex_lerp[:z]).abs

    if x_diff > y_diff && x_diff > z_diff
      rx = -ry - rz
    elsif y_diff > z_diff
      ry = -rx - rz
    else
      rz = -rx - ry
    end

    Hex.find_by(x: rx, y: ry, z: rz)
  end

  def distance(hex)
    ((self.x - hex.x).abs + (self.y - hex.y).abs + (self.z - hex.z).abs) / 2
  end

  def lerp(a, b, t)
    a + (b - a) * t
  end

  def render_hex
    cable_ready["visitors"].inner_html(
      selector: "#hex_#{id}",
      html: render(partial: "home/hex_inner", locals: { hex: self })
    )
  end

end
