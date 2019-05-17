#!/usr/bin/env ruby

# frozen_string_literal: true

require 'open3'

module FlazmRubyHelpers
  module OsHelper
    def self.exec(command, stream: true)
      output = [] ; threads = [] ; status = nil
      Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
        { out: stdout, err: stderr }.each do |_key, stream|
          threads << Thread.new do
            until (raw_line = stream.gets).nil?
              output << raw_line.to_s
              puts raw_line.to_s if stream
            end
          end
        end
        threads.each(&:join)
        status = wait_thr.value.success?
      end
      return output, status
    end
  end
end
