# frozen_string_literal: true

require 'open3'
require 'logger'

module FlazmRubyHelpers
  module Os
    def self.exec(command, logger: nil, stream_log: false)
      logger ||= Logger.new(STDOUT)
      logger.info("Command: #{command}")
      output = [] ; threads = [] ; status = nil
      Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
        { out: stdout, err: stderr }.each do |_key, stream|
          threads << Thread.new do
            until (raw_line = stream.gets).nil?
              output << raw_line.to_s
              logger.info(raw_line.to_s) if stream_log
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
