class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:sign_as]

  def index
    @range = 5
    @current_hex = current_user.hex
    @hexes = @current_hex.neighbors(@range)
  end

  def sign_as
    Rails.logger.info "     ===== params: #{params[:id].inspect} ====="
    sign_in_and_redirect :user, User.find(params[:id])
  end
end
