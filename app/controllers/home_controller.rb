class HomeController < ApplicationController
  def index
    @range = 5
    current_hex = Hex.find_by(q: 11, r: 11)
    @hexes = current_hex.neighbors(@range)
  end
end
