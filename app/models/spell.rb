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
      (line_hexes.count + 1).times do |index|
        previous_hex = line_hexes[index - 1]
        previous_hex.spells.delete(self) if previous_hex

        current_hex = line_hexes[index]
        if current_hex
          current_hex.spells << self
          render_hexes(previous_hex, current_hex)
          cable_ready["visitors"].broadcast
          sleep 1
        end
      end
    end
  end

  private

  def render_hexes(*hexes)
    hexes.each do |hex|
      cable_ready["visitors"].inner_html(
        selector: "#hex_#{hex.id}",
        html: render(partial: "home/hex_inner", locals: { hex: hex })
      )
    end
  end
end
