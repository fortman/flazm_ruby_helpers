# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'open3'
require_relative 'lib/flazm_ruby_helpers/rake_helper'

spec_file = Gem::Specification.load('flazm_ruby_helpers.gemspec')

task default: :build

task :publish do
  cmd_gem = "gem push pkg/flazm_ruby_helpers-#{spec_file.version}.gem"
  _output, _status = FlazmRubyHelpers::RakeHelper.exec(cmd_gem)
end
