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

  def cast(start_hex, end_hex)
    line_hexes = start_hex.hex_linedraw(end_hex)

    Thread.new do
      (1..line_hexes.count).each do |i|
        unless i == 0
          previous_hex = line_hexes[i - 1]
          previous_hex.reload.spells.delete(self)
          previous_hex.render_hex
        end

        current_hex = line_hexes[i]
        if current_hex
          current_hex.reload.spells << self
          current_hex.user.apply_damage(self) if current_hex.user
          current_hex.render_hex
        end

        cable_ready["visitors"].broadcast
        sleep 1
      end
    end
  end
end
