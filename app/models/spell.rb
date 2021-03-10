require 'async'

class Spell
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :damage, type: Float

  belongs_to :user, optional: true
  has_and_belongs_to_many :hex

  def initialize(attrs)
    super
  end

end
