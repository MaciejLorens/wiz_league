require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def action
    start_hex = current_user.reload.hex
    end_hex = Hex.find(element.dataset.id)

    if start_hex.distance(end_hex) == 1
      current_user.move(end_hex)
    else
      current_user.cast(end_hex)
    end

    morph :nothing
  end
end
