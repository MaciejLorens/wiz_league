[User, Hex, Spell].each(&:delete_all)

user1 = User.create(
  email: 'a@a.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 200,
  stamina_max: 500,
  hp: 200,
  max_hp: 400,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 100,
  max_mp: 100,
  regeneration_mp: 0.001,
  mp_at: Time.now,
)

user2 = User.create(
  email: 'b@b.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 30,
  stamina: 300,
  stamina_max: 300,
  hp: 200,
  max_hp: 400,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 150,
  max_mp: 150,
  regeneration_mp: 0.001,
  mp_at: Time.now,
)

user1.spells.create(type: 'fire', damage: 110, mp: 30)
user1.spells.create(type: 'ice', damage: 60, mp: 20)

user2.spells.create(type: 'fire', damage: 140, mp: 30)
user2.spells.create(type: 'ice', damage: 30, mp: 20)

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
