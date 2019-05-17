# frozen_string_literal: true

module FlazmRubyHelpers
  # Define methods to handle default initialization behavior
  module ClassHelper
    def initialize_variables(config = {})
      # define the defaults method in the class that includes this
      # defaults method returns a hash of instance variables mapped to values
      defaults.each_pair do |key, default_value|
        key = key.to_s
        if config[key]
          instance_variable_set("@#{key}", config[key])
        elsif ENV[key.upcase.to_s]
          instance_variable_set("@#{key}", ENV[key.upcase.to_s])
        else
          instance_variable_set("@#{key}", default_value)
        end
      end
    end
  end
end
