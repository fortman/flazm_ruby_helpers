#!/usr/bin/env ruby

# frozen_string_literal: true

require 'net/http'

module FlazmRubyHelpers
  module Http
    def self.wait_for_urls(urls)
      urls.each do |url|
        uri = URI(url)
        error = true
        puts "uri: #{uri}"
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
