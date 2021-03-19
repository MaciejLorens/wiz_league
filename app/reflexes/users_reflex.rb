require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def action
    start_hex = current_user.reload.hex
    end_hex = Hex.find(element.dataset.id)

    if start_hex.distance(end_hex) > 1
      current_user.cast(end_hex)
    elsif start_hex.distance(end_hex) == 1
      current_user.move(end_hex)
    end

    morph :nothing
  end

  def spell_q
    cable_ready.console_log(message: "spell_q spell_q").broadcast
    morph :nothing
  end

  def spell_w
    cable_ready.console_log(message: "spell_w spell_w").broadcast
    morph :nothing
  end

  def spell_e
    cable_ready.console_log(message: "spell_e spell_e").broadcast
    morph :nothing
  end

  def spell_r
    cable_ready.console_log(message: "spell_r spell_r").broadcast
    morph :nothing
  end
end
