# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  delegate :render, to: ApplicationController
end
