require 'async'

class Spell
  include CableReady::Broadcaster
  delegate :render, to: ApplicationController

  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :damage, type: Float
  field :mp, type: Float

  belongs_to :user, optional: true
  has_and_belongs_to_many :hex

  def initialize(attrs)
    super
  end

end
