require 'async'

class Spell
  include CableReady::Broadcaster
  delegate :render, to: ApplicationController

  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :damage, type: Float

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
          previous_hex.spells.delete(self)
        end

        current_hex = line_hexes[i]
        if current_hex
          current_hex.spells << self
        end

        cable_ready["visitors"].broadcast
        sleep 1
      end
    end
  end
end
