class User
  include CableReady::Broadcaster
  delegate :render, to: ApplicationController

  include Mongoid::Document

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at, type: Time

  field :stamina, type: Float, default: 0
  field :stamina_max, type: Float, default: 0
  field :stamina_reg, type: Float, default: 0
  field :stamina_at, type: Time

  field :regeneration_hp, type: Float, default: 0
  field :hp, type: Float, default: 0
  field :max_hp, type: Float, default: 0
  field :hp_at, type: Time

  field :regeneration_mp, type: Float, default: 0
  field :mp, type: Float, default: 0
  field :max_mp, type: Float, default: 0
  field :mp_at, type: Time

  field :death, type: Boolean, default: false

  include Mongoid::Timestamps

  has_many :spells
  has_one :hex

  def move(end_hex)
    return if end_hex.stamina_required > current_stamina

    update(stamina: current_stamina - end_hex.stamina_required, stamina_at: Time.now)
    hex.update(user_id: nil)
    hex.render_hex
    end_hex.update(user_id: id)
    end_hex.render_hex
    apply_damage(*end_hex.spells)

    render_stamina_bar
    render_map(end_hex)

    cable_ready["visitors"].broadcast
    cable_ready["visitors-#{id}"].broadcast
  end

  def cast(end_hex)
    return if current_spell.mp > current_mp

    update(mp: current_mp - current_spell.mp, mp_at: Time.now)
    render_mp
    cable_ready["visitors-#{id}"].broadcast

    line_hexes = hex.hex_linedraw(end_hex)
    Thread.new do
      (1..line_hexes.count).each do |i|
        unless i == 0
          previous_hex = line_hexes[i - 1]
          previous_hex.reload.spells.delete(current_spell)
          previous_hex.render_hex
        end

        current_hex = line_hexes[i]
        if current_hex
          current_hex.reload.spells << current_spell
          current_hex.user.apply_damage(current_spell) if current_hex.user
          current_hex.render_hex
        end

        cable_ready["visitors"].broadcast
        sleep 1
      end
    end
  end

  def current_stamina
    return stamina_max if stamina_at.blank?
    [(stamina + (Time.now - stamina_at) * stamina_reg).to_i, stamina_max].min
  end

  def current_hp
    return max_hp if hp_at.blank?
    [hp + (Time.now - self.hp_at) * regeneration_hp, max_hp].min
  end

  def current_mp
    return max_mp if mp_at.blank?
    [mp + (Time.now - self.mp_at) * regeneration_mp, max_mp].min
  end

  def current_spell
    spells.first
  end

  def apply_damage(*spells)
    return if spells.blank?
    total_damage = spells.map(&:damage).sum

    if total_damage > current_hp
      update(death: true, hp: 0, hp_at: Time.now, regeneration_hp: 0)
    else
      update(hp: current_hp - total_damage, hp_at: Time.now)
    end

    render_hp
    cable_ready["visitors-#{id}"].broadcast
  end

  def render_hp
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#max_hp",
      html: render(partial: "home/current_hp", locals: { user: self })
    )
  end

  def render_mp
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#max_mp",
      html: render(partial: "home/current_mp", locals: { user: self })
    )
  end

  def render_stamina_bar
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#stamina_max",
      html: render(partial: "home/current_stamina", locals: { user: self })
    )
  end

  def render_map(hex)
    hexes = hex.neighbors(5)
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#map",
      html: render(partial: "home/map", locals: { hexes: hexes, range: 5 })
    )
  end
end
