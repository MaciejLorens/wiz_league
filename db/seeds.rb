[User, Hex, Spell].each(&:delete_all)

user1 = User.create(
  email: 'a@a.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  speed: 50,
  movement: 200,
  max_movement: 500
)

user2 = User.create(
  email: 'b@b.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  speed: 30,
  movement: 300,
  max_movement: 300
)

user1.spells.create(type: 'fire', damage: 11)
user1.spells.create(type: 'ice', damage: 6)

user2.spells.create(type: 'fire', damage: 14)
user2.spells.create(type: 'ice', damage: 3)

50.times do |q|
  50.times do |r|
    if q <= 10 || r <= 10 || q >= 90 || r >= 90
      Hex.create(q: q, r: r, x: q, z: r, y: -q - r, terrain: 'bedrock')
    else
      Hex.create(q: q, r: r, x: q, z: r, y: -q - r, terrain: Hex::TERRAIN.sample)
    end
  end
end

Hex.update_all(user_id: nil)
Hex.find_by(q: 20, r: 20).update(user_id: user1.id)
Hex.find_by(q: 22, r: 22).update(user_id: user2.id)
