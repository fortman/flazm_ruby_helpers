#!/usr/bin/env ruby

# frozen_string_literal: true

require 'open3'
require 'net/http'
require 'bunny'
require 'json'

module FlazmRubyHelpers
  module RakeHelper
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

    def self.wait_for_urls(urls)
      urls.each do |url|
        uri = URI(url)
        error = true
        Net::HTTP.start(uri.host, uri.port, read_timeout: 5, max_retries: 12) do |http|
          while error
            begin
              response = http.request(Net::HTTP::Get.new(uri))
              error = false
            rescue EOFError
              retry
            end
          end
          raise Exception unless response.code == '200'

          puts "up: #{url}"
        end
      end
    end
  end
end
