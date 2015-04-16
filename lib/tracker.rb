require "tracker/version"
require 'tracker/cli'
require 'json'

require 'tracker/api/validation'
require 'tracker/api/yamato'
require 'tracker/api/sagawa'
require 'tracker/api/yuusei'
require 'tracker/api/seinou'

module Tracker # :nodoc:
  # 荷物追跡 
  class Base
    # 荷物の追跡を実行する
    # @todo クラス名を変える
    # @todo validationの改修
    # @param no [String] 追跡番号
    # @param company [String] 運送会社 (yamato, sawaga, yuusei, seinou)
    def self.execute(no: nil, company: nil)
      validate = Tracker::Api::Validation.new no: no
      return "number validation error. #{validate.errors.inspect}" if !validate.valid?

      data = []
      coms = ["yamato", "sagawa", "yuusei"]
      coms = ["seinou"] if no.length == 10
      companies = company.to_s.empty? ? coms : [company]

      companies.each do |c|
        str = "Tracker::Api::#{c.capitalize}"
        klass = Object.const_get(str)
        a = klass.new no: no
        data << JSON.parse(a.execute)
      end

      data.to_json
    end
  end
end
