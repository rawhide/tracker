require 'tracker'
require 'thor'

module Tracker
  class CLI < Thor
    #default_command :trace

    method_option :force, type: :boolean, aliases: '-f'
    method_option :verbose, type: :boolean, aliases: '-v'
    option :number, type: :string, aliases: '-n', desc: 'tracking number', required: true
    option :company, type: :string, aliases: '-c', desc: 'shipping company'
    desc "trace usage", "TODO: run tracking no trace."
    # 荷物を追跡するためのコマンドライン用メソッド
    # @return [String] json string
    # @example
    #   bundle exec bin/tracker trace -n 123412341231 -c sagawa
    def trace
      no = options[:number]
      result = Tracker::Base.execute(no: options[:number], company: options[:company])
      say("input: #{no}", :red)
      say("output: #{result}", :yellow)
      say("shipping company: #{options[:company]}") if options[:company]
      say("verbose", :blue) if options[:verbose]
    end
  end
end
