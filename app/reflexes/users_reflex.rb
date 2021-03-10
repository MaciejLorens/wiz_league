require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def move
    current_user = User.first
    hex = Hex.find(element.dataset.id)
    current_hex = current_user.reload.hex

    distance = current_hex.distance(hex)

    if distance == 1
      move_user(current_hex, hex)
    else
      cast_spell(current_hex, hex)
    end

    cable_ready["visitors"].broadcast
    cable_ready["visitors-#{current_user.id}"].broadcast

    morph :nothing
  end

  def move_user(current_hex, hex)
    if current_user.current_movement >= hex.movement_required
      current_hex.update(user_id: nil)
      cable_ready["visitors"].inner_html(
        selector: "#hex_#{current_hex.id}",
        html: render(partial: "home/hex_inner", locals: { hex: current_hex })
      )

      current_user.update(movement: current_user.current_movement - hex.movement_required, movement_at: Time.now)
      hex.update(user_id: current_user.id)
      hexes = hex.neighbors(5)
      cable_ready["visitors-#{current_user.id}"].inner_html(
        selector: "#map",
        html: render(partial: "home/map", locals: { hexes: hexes, range: 5 })
      )
      cable_ready["visitors-#{current_user.id}"].inner_html(
        selector: "#max_movement",
        html: render(partial: "home/meter", locals: { user: current_user })
      )
      cable_ready["visitors"].inner_html(
        selector: "#hex_#{hex.id}",
        html: render(partial: "home/hex_inner", locals: { hex: hex })
      )
    end
  end

  def cast_spell(current_hex, hex)
    hexes = current_hex.hex_linedraw(hex)
    hexes.each do |hex|
      hex.spells << current_user.current_spell
      cable_ready["visitors"].inner_html(
        selector: "#hex_#{hex.id}",
        html: render(partial: "home/hex_inner", locals: { hex: hex })
      )
    end
  end

end
