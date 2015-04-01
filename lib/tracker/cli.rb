require 'tracker'
require 'thor'

module Tracker
  class CLI < Thor
    #default_command :trace

    desc "trace", "TODO: run tracking no trace."
    method_option :force, type: :boolean, aliases: '-f'
    method_option :verbose, type: :boolean, aliases: '-v'
    option :number, type: :string, aliases: '-n', desc: 'tracking number', required: true
    option :shipper, type: :string, aliases: '-s', desc: 'shipping company'
    def trace
      no = options[:number]
      result = Tracker::Test.execute(no)
      say("input: #{no}", :yellow)
      say("output: #{result}", :yellow)
      say("shipping company: #{options[:shipper]}") if options[:shipper]
      say("verbose", :blue) if options[:verbose]
    end
  end
end
