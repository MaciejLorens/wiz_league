Hex.delete_all

100.times do |q|
  100.times do |r|
    if q <= 10 || r <= 10 || q >= 90 || r >= 90
      Hex.create(q: q, r: r, x: q, z: r, y: -q - r, terrain: 'bedrock')
    else
      Hex.create(q: q, r: r, x: q, z: r, y: -q - r, terrain: Hex::TERRAIN.sample)
    end
  end
end

Hex.find_by(q: rand(60) + 20, r: rand(60) + 20).update(player_id: 1)
