module HexHelper

  def hex_classes(hex)
    classes = []
    classes << hex.terrain
    classes << 'player' if hex.user_id.present?
    hex.spells.each do |spell|
      classes << spell.type
    end
    classes.join(' ')
  end

end
