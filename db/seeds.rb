Hex.delete_all

20.times do |q|
  20.times do |r|
    Hex.create(
      q: q,
      r: r,
      x: q,
      z: r,
      y: -q - r,
      terrain: Hex::TERRAIN.sample
    )
  end
end
