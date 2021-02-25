class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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

  include Mongoid::Timestamps

  has_one :hex

  def current_movement
    return max_movement if movement_at.blank?
    [(movement + (Time.now - self.movement_at) * speed).to_i, max_movement].min
  end
end
