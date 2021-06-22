[User, Hex, Spell].each(&:delete_all)

user1 = User.create(
  email: 'a@a.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

user2 = User.create(
  email: 'b@b.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

user3 = User.create(
  email: 'c@c.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

user4 = User.create(
  email: 'd@d.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

user5 = User.create(
  email: 'e@e.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

user6 = User.create(
  email: 'f@f.pl',
  password: '1234567890',
  password_confirmation: '1234567890',
  stamina_reg: 100,
  stamina: 500,
  stamina_max: 500,
  hp: 500,
  max_hp: 500,
  regeneration_hp: 10,
  hp_at: Time.now,
  mp: 500,
  max_mp: 500,
  regeneration_mp: 20,
  mp_at: Time.now,
)

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

User.all.each_with_index do |user, index|
  user.spells.create(type: 'fire', damage: 100, mp: 30)
  # user1.spells.create(type: 'ice', damage: 60, mp: 20)

end

Hex.find_by(q: 20, r: 20).update(user_id: User.all[0].id)
Hex.find_by(q: 20, r: 24).update(user_id: User.all[1].id)
Hex.find_by(q: 22, r: 20).update(user_id: User.all[2].id)
Hex.find_by(q: 20, r: 22).update(user_id: User.all[3].id)
Hex.find_by(q: 18, r: 20).update(user_id: User.all[4].id)
Hex.find_by(q: 18, r: 18).update(user_id: User.all[5].id)
