# frozen_string_literal: true

require 'git'
require 'flazm_ruby_helpers/os'

module FlazmRubyHelpers
  module Project
    # Helper module to publish git projects
    module Git
      # Depends on version file

      def self.publish(version, remote, branch)
        g = ::Git.init
        g.fetch

        validate(g, version)
        
        g.add_tag(version)
        puts "Added git tag '#{version}'"
        _output, push_success = FlazmRubyHelpers::Os.exec("git push #{remote} #{version}:master")
        raise "ERROR: Failed to push to #{remote} for branch #{branch}" unless push_success
        _output, tag_success = FlazmRubyHelpers::Os.exec("git push --tags #{remote}")
        raise "ERROR: Failed to push to #{remote} for branch #{branch}" unless tag_success
      end

      private

      def self.validate(g, version)
        previous_version = g.object('origin/master:VERSION').contents
        raise "ERROR: New version (#{version}) is not greater than previous version (#{previous_version})" if ::Gem::Version.new(previous_version) > ::Gem::Version.new(version)
        
        num_changes = g.log.between('origin/master', 'HEAD').size
        raise 'ERROR: Local workspace has changes not checked in' unless g.status.changed.size == 0
        raise "ERROR: Should only have 1 change, have #{num_changes} changes.  Please squash your commit" if num_changes != 1
      end
    end

    # Helper module to publish docker projects
    module Docker
      def self.build(build_cmd)
        output, success = FlazmRubyHelpers::Os.exec(build_cmd)
        match = output[-1].match(/Successfully built (.*)$/i)
        raise 'failed to build docker image' unless success && match
      
        match.captures[0]
      end

      def self.tag(docker_image_name, version, image_id)
        puts "Docker id #{image_id} => tag #{docker_image_name}:#{version}"
        tag_cmd = "docker tag #{image_id} #{docker_image_name}:#{version}"
        _output, success = FlazmRubyHelpers::Os.exec(tag_cmd)
        raise 'docker tag failed' unless success
      end

      def self.publish(image_name, version)
        _output, docker_push_success = FlazmRubyHelpers::Os.exec("docker push #{image_name}:#{version}")
        raise "Docker push failed for image #{image_name}:#{version}" unless docker_push_success
      end

      def self.validate
      end

    end

    # Helper module to publish gem projects
    module Gem
      def self.publish(gem_name, version)
        _output, gem_push_success = FlazmRubyHelpers::Os.exec("gem push pkg/#{gem_name}-#{version}.gem")
        raise "Gem push failed for #{gem_name}:#{version}" unless gem_push_success
      end

      def self.validate
      end
    end
  end
end
