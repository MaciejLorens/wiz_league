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

  def current_movement
    return max_movement if movement_at.blank?
    [(movement + (Time.now - self.movement_at) * speed).to_i, max_movement].min
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
  end

  def render_hp
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#max_hp",
      html: render(partial: "home/current_hp", locals: { user: self })
    )
    cable_ready["visitors-#{id}"].broadcast
  end

  def render_mp
    cable_ready["visitors-#{id}"].inner_html(
      selector: "#max_mp",
      html: render(partial: "home/current_mp", locals: { user: self })
    )
    cable_ready["visitors-#{id}"].broadcast
  end

end
