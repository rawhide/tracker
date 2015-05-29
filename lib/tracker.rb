require "tracker/version"
require 'tracker/cli'
require 'json'
require 'logger'

require 'tracker/api/validation'
require 'tracker/api/corporations/yamato'
require 'tracker/api/corporations/sagawa'
require 'tracker/api/corporations/yuusei'
require 'tracker/api/corporations/seinou'

module Tracker # :nodoc:
  # 荷物追跡 
  class Base
    # 荷物の追跡を実行する
    # @todo クラス名を変える
    # @todo validationの改修
    # @param no [String] 追跡番号
    # @param company [String] 運送会社 (yamato, sawaga, yuusei, seinou)
    # @param format [Symbol] (nil[:hash], :json)
    # @param validation [Symbol] バリーデーションの利用 default: false
    # @return [Array]
    #
    def self.execute(no: nil, company: nil, format: nil, validation: false)
      log = Logger.new("log/tracker.log")

      if validation
        validate = Tracker::Api::Validation.new no: no
        return "number validation error. #{validate.errors.inspect}" if !validate.valid?
      end

      data = []
      # 運送各社を追加する場合はここ(現状は3社のみ)
      coms = ["yamato", "sagawa", "yuusei"]
      companies = company.to_s.empty? ? coms : [company]

      companies.each do |c|
        str = "Tracker::Api::#{c.capitalize}"
        klass = Object.const_get(str)
        a = klass.new
        a.no = no
        data << a.execute.make.result
      end

      str = data.to_json
      log.info str

      if format == :json
        data.to_json
      else
        data
      end
    end
  end
end
