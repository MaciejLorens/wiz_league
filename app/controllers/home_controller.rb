class HomeController < ApplicationController
  def index
    @range = 5
    @current_hex = Hex.find_by(player_id: 1)
    @hexes = @current_hex.neighbors(@range)
  end
end
