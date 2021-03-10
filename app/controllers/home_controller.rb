class HomeController < ApplicationController
  def index
    @range = 5
    @current_hex = User.first.hex
    @hexes = @current_hex.neighbors(@range)
  end
end
