require 'json'
module Tracker # :nodoc:
  module Api # :nodoc:
    class Builder
      # @todo doc
      attr_accessor :no, :status, :date, :place, :company, :description, :origin

      # @todo doc
      def initialize(no: nil, status: nil, date: nil, place: nil, company: nil, description: nil, origin: nil)
        @no = no
        @status = status
        @date = date
        @place = place
        @company = company
        @description = description
        @origin = origin
      end

      # @todo doc
      def to_json
        #data = {}
        #self.instance_variables.each {|n| data[n] = self.instance_variable_get(n) }
        #data.to_json
        {no: no.to_s, status: status, date: date, place: place, company: company, description: description, origin: origin}.to_json
      end
    end
  end
end
