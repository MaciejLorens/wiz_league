class UsersReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def move
    current_hex = current_user.hex
    current_hex.update(user_id: nil)
    cable_ready["visitors"].morph(
      selector: 'li#' + current_hex.id.to_s,
      html: render(partial: "home/hex_inner", locals: {hex: current_hex})
    )

    hex = Hex.find(element.id)
    hex.update(user_id: current_user.id)
    cable_ready["visitors"].morph(
      selector: 'li#' + hex.id.to_s,
      html: render(partial: "home/hex_inner", locals: {hex: hex})
    )

    # morph("#{hex.id}", render(partial: 'hex', locals: { hex: hex }))

    # morph :nothing
    cable_ready["visitors"].broadcast

    morph :nothing
  end

end
