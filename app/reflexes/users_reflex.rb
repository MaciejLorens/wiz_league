class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def move
    current_hex = current_user.reload.hex
    current_hex.update(user_id: nil)
    cable_ready["visitors"].inner_html(
      selector: "#hex_#{current_hex.id}",
      html: render(partial: "home/hex_inner", locals: {hex: current_hex})
    )

    hex = Hex.find(element.dataset.id)
    hex.update(user_id: current_user.id)
    cable_ready["visitors"].inner_html(
      selector: "#hex_#{hex.id}",
      html: render(partial: "home/hex_inner", locals: {hex: hex})
    )

    cable_ready["visitors"].broadcast

    morph :nothing
  end

end
