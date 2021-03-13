require 'async'

class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def action
    start_hex = current_user.reload.hex
    end_hex = Hex.find(element.dataset.id)

    if start_hex.distance(end_hex) == 1
      move(start_hex, end_hex)
    else
      if current_user.current_mp >= current_user.current_spell.mp
        current_user.update(mp: current_user.current_mp - current_user.current_spell.mp)
        current_user.render_mp
        current_user.current_spell.cast(start_hex, end_hex)
      end
    end

    cable_ready["visitors"].broadcast
    cable_ready["visitors-#{current_user.id}"].broadcast

    morph :nothing
  end

  def move(start_hex, end_hex)
    if current_user.current_stamina >= end_hex.stamina_required
      current_user.update(stamina: current_user.current_stamina - end_hex.stamina_required, stamina_at: Time.now)

      start_hex.update(user_id: nil)
      end_hex.update(user_id: current_user.id)
      current_user.apply_damage(*end_hex.spells)
      start_hex.render_hex
      end_hex.render_hex

      render_map(end_hex)
      render_stamina_bar
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

  def render_stamina_bar
    cable_ready["visitors-#{current_user.id}"].inner_html(
      selector: "#stamina_max",
      html: render(partial: "home/current_stamina", locals: { user: current_user })
    )
  end

end
