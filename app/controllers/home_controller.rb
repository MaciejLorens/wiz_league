class HomeController < ApplicationController
  def index
    @range = 5
    @current_hex = current_user.hex
    @hexes = @current_hex.neighbors(@range)
  end
end
