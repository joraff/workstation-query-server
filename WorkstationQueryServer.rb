#!/usr/bin/env ruby -wKU

require 'socket'
require 'thread'
require 'rubygems'
require 'json'
require "#{File.dirname(__FILE__)}/Workstation.rb"

class LogFile
  def initialize(l, *args)
    @l = l
  end
  
  def puts(s)
    File.open(@l, "a") { |f| f.write("#{`date`.strip}: #{s}\n") }
    super
  end
end

log = LogFile.new("#{File.dirname(__FILE__)}/queries.log")


server = TCPServer.open('0.0.0.0', 4525)

loop do
  
  Thread.start(server.accept) do |s|
    log.puts "Request from #{s.peeraddr[2]}: (#{s.peeraddr[3]}:#{s.peeraddr[1]})"
    begin
      while line = s.gets.strip.upcase
        log.puts "#{s.peeraddr[2]}: Asked for #{line}"
        if line =~ /^[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}$/
          if w = Workstation.find_by_mac_address(line).to_hash
            log.puts "#{s.peeraddr[2]}: Request was valid. Sending information"
            s.puts w.to_json
          else
            log.puts "No equipment matches #{line}"
          end
        else
          log.puts "#{s.peeraddr[2]}: Request was improperly formatted."
          s.puts "nil"
        end
      end
    ensure
      log.puts "#{s.peeraddr[2]}: Closing socket..."
      s.close
    end
  end

end