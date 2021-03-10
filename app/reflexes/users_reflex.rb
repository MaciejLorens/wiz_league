require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def action
    current_user = User.first
    start_hex = current_user.reload.hex
    end_hex = Hex.find(element.dataset.id)

    if start_hex.distance(end_hex) == 1
      move(start_hex, end_hex)
    else
      cast(start_hex, end_hex)
    end

    cable_ready["visitors"].broadcast
    cable_ready["visitors-#{current_user.id}"].broadcast

    morph :nothing
  end

  def move(start_hex, end_hex)
    if current_user.current_movement >= end_hex.movement_required
      current_user.update(movement: current_user.current_movement - end_hex.movement_required, movement_at: Time.now)

      start_hex.update(user_id: nil)
      end_hex.update(user_id: current_user.id)

      render_hexes(start_hex, end_hex)
      render_map(end_hex)
      render_movement_bar
    end
  end

  def cast(start_hex, end_hex)
    line_hexes = start_hex.hex_linedraw(end_hex)

    Thread.new do
      (line_hexes.count + 1).times do |index|
        previous_hex = line_hexes[index - 1]
        previous_hex.spells.delete(current_user.current_spell) if previous_hex

        current_hex = line_hexes[index]
        if current_hex
          current_hex.spells << current_user.current_spell
          render_hexes(previous_hex, current_hex)
          cable_ready["visitors"].broadcast
          sleep 1
        end
      end
    end
  end

  private

  def render_map(hex)
    hexes = hex.neighbors(5)
    cable_ready["visitors-#{current_user.id}"].inner_html(
      selector: "#map",
      html: render(partial: "home/map", locals: { hexes: hexes, range: 5 })
    )
  end

  def render_hexes(*hexes)
    hexes.each do |hex|
      cable_ready["visitors"].inner_html(
        selector: "#hex_#{hex.id}",
        html: render(partial: "home/hex_inner", locals: { hex: hex })
      )
    end
  end

  def render_movement_bar
    cable_ready["visitors-#{current_user.id}"].inner_html(
      selector: "#max_movement",
      html: render(partial: "home/meter", locals: { user: current_user })
    )
  end

end
