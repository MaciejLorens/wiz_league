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

  field :speed, type: Integer, default: 0
  field :movement, type: Integer, default: 0
  field :movement_at, type: Time
  field :max_movement, type: Integer, default: 0

  field :regeneration_hp, type: Integer, default: 0
  field :hp, type: Integer, default: 0
  field :hp_at, type: Time
  field :max_hp, type: Integer, default: 0
  field :death, type: Boolean, default: false

  include Mongoid::Timestamps

  has_many :spells
  has_one :hex

  def current_movement
    return max_movement if movement_at.blank?
    [(movement + (Time.now - self.movement_at) * speed).to_i, max_movement].min
  end

  def current_hp
    return max_hp if hp_at.blank?
    [(hp + (Time.now - self.hp_at) * regeneration_hp).to_i, max_hp].min
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

    render_user
    cable_ready["visitors-#{id}"].broadcast
  end

  def render_user
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#max_hp",
      html: render(partial: "home/current_hp", locals: { user: self })
    )
  end

end
