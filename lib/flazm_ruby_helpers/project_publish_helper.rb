# frozen_string_literal: true

require 'git'

module FlazmRubyHelpers
  module DevProject
    # Helper module to publish git projects
    module GitPublish
      def self.validate_workspace
      end
    end

    # Helper module to publish docker projects
    module DockerPublish
    end

    # Helper module to publish gem projects
    module GemPublish
    end
  end
end
