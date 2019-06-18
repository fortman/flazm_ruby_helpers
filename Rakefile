# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'open3'
require_relative 'lib/flazm_ruby_helpers/os'
require_relative 'lib/flazm_ruby_helpers/project'

spec_file = Gem::Specification.load('flazm_ruby_helpers.gemspec')

task default: :build

task :publish do
  FlazmRubyHelpers::Project::Git.publish(spec_file.version.to_s, 'origin', 'master')
  FlazmRubyHelpers::Project::Gem.publish(spec_file.name.to_s, spec_file.version.to_s)
end

task :install do
  cmd_gem = "bundle exec gem install pkg/flazm_ruby_helpers-#{spec_file.version}.gem"
  _output, _status = FlazmRubyHelpers::Os.exec(cmd_gem, stream_log: true)
end
