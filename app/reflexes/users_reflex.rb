require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def action
    start_hex = current_user.reload.hex
    end_hex = Hex.find(element.dataset.id)

    if start_hex.distance(end_hex) == 1
      current_user.move(end_hex)
    else
      if current_user.current_mp >= current_user.current_spell.mp
        current_user.update(mp: current_user.current_mp - current_user.current_spell.mp)
        current_user.render_mp
        current_user.current_spell.cast(start_hex, end_hex)
      end
    end

    morph :nothing
  end
end
